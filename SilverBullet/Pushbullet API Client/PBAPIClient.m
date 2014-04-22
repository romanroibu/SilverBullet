//
//  PBAPIClient.m
//
//  Created by Roman on 03.21.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "PBAPIClient.h"

static NSString * const PushbulletAPIBaseURL = @"https://api.pushbullet.com/api/";

@interface PBAPIClient ()
@end

@implementation PBAPIClient

#pragma mark - Class methods

+ (PBAPIClient *)sharedClient
{
    static PBAPIClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:PushbulletAPIBaseURL]];
    });
    
    return _sharedClient;
}

#pragma mark - Lifecycle methods

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer  = [AFJSONRequestSerializer  serializer];
        self.apiKey = self.apiKey; // Trigger setting authorization header
    }

    return self;
}

#pragma mark - Custom accessors

@synthesize apiKey = _apiKey;

static NSString * const kAPIKeyUserDefaults = @"PushbulletAPIKeyDefaultsKey";

- (NSString *)apiKey
{
    if (!_apiKey) {
        _apiKey = [[NSUserDefaults standardUserDefaults] stringForKey:kAPIKeyUserDefaults];
    }
    return _apiKey;
}

- (void)setApiKey:(NSString *)apiKey
{
    _apiKey = apiKey;
    [[NSUserDefaults standardUserDefaults] setObject:apiKey forKey:kAPIKeyUserDefaults];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:apiKey password:@""];
}

#pragma mark - Public API methods

//GET https://api.pushbullet.com/api/devices
- (void)getDevicesWithSuccess:(PBDevicesSuccessBlock)successBlock
                         fail:(PBFailBlock)failBlock
{
    [self GET:@"devices" parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          successBlock(task, responseObject);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          failBlock(task, error);
    }];
}

//title = The title of the note
//body = The note's body
- (void)pushNoteWithDeviceIDEN:(NSString *)deviceIDEN
                         title:(NSString *)title
                          body:(NSString *)body
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"type"]    = @"note";
    parameters[@"title"]   = title ? title : @"";
    parameters[@"body"]    = body ? body : @"";
    
    [self pushWithDeviceIDEN:deviceIDEN
                  parameters:parameters
                     success:successBlock
                        fail:failBlock];
}

//title = The title of the page linked to
//url = The link url
- (void)pushLinkWithDeviceIDEN:(NSString *)deviceIDEN
                         title:(NSString *)title
                           url:(NSString *)urlString
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"type"]    = @"link";
    parameters[@"title"]   = title ? title : @"";
    parameters[@"url"]     = urlString ? urlString : @"";

    [self pushWithDeviceIDEN:deviceIDEN
                  parameters:parameters
                     success:successBlock
                        fail:failBlock];
}

//name = The name of the place at the address
//address = The full address or Google Maps query
- (void)pushAddressWithDeviceIDEN:(NSString *)deviceIDEN
                             name:(NSString *)name
                          address:(NSString *)address
                          success:(PBPushSuccessBlock)successBlock
                             fail:(PBFailBlock)failBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"type"]    = @"address";
    parameters[@"name"]    = name ? name : @"";
    parameters[@"address"] = address ? address : @"";

    [self pushWithDeviceIDEN:deviceIDEN
                  parameters:parameters
                     success:successBlock
                        fail:failBlock];
}

//title = The title of the list
//items = The list items
- (void)pushListWithDeviceIDEN:(NSString *)deviceIDEN
                         title:(NSString *)title
                         items:(NSArray *)items
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"type"]  = @"list";
    parameters[@"title"] = title ? title : @"";
    parameters[@"items"] = items ? items : @[];
    
    [self pushWithDeviceIDEN:deviceIDEN
                  parameters:parameters
                     success:successBlock
                        fail:failBlock];
}

//file = The file to push
- (void)pushFileWithDeviceIDEN:(NSString *)deviceIDEN
                          path:(NSString *)filepath
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"type"]  = @"file";

    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    
    [self POST:@"pushes"
    parameters:parameters
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileURL name:@"file" error:nil]; //FIXIT: figure out how to send non-nil argument
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failBlock(task, error);
    }];

}

#pragma mark - Private helper methods

//POST https://api.pushbullet.com/api/pushes
- (void)pushWithDeviceIDEN:(NSString *)deviceIDEN
                parameters:(NSDictionary *)parameters
                   success:(PBPushSuccessBlock)successBlock
                      fail:(PBFailBlock)failBlock
{
    [self POST:@"pushes"
    parameters:parameters
    success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failBlock(task, error);
    }];
}

#pragma mark - Request Error Codes

// HTTP Status Code Summary
// 200 OK - Everything worked as expected.
// 400 Bad Request - Often missing a required parameter.
// 401 Unauthorized - No valid API key provided.
// 402 Request Failed - Parameters were valid but the request failed.
// 403 Forbidden - The API key is not valid for that request.
// 404 Not Found - The requested item doesn't exist.
// 5XX Server errors - something went wrong on PushBullet's side.

- (NSString *)prettyErrorForCode:(NSInteger)statusCode
{
    NSString *description = nil;

    switch (statusCode) {
        case 200:
            break;
            
        case 400:
            description = @"Bad Request - Often missing a required parameter.";
            break;

        case 401:
            description = @"Unauthorized - No valid API key provided.";
            break;
            
        case 402:
            description = @"Request Failed - Parameters were valid but the request failed.";
            break;

        case 403:
            description = @"Forbidden - The API key is not valid for that request.";
            break;
            
        case 404:
            description = @"Not Found - The requested item doesn't exist.";
            break;
            
        default:
            if (statusCode > 499 && statusCode < 600)
                description = @"Server error - Something went wrong on PushBullet's side.";
            break;
    }
    
    return description;
}


@end
