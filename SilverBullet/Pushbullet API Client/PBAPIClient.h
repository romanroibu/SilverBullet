//
//  PBAPIClient.h
//
//  Created by Roman on 03.21.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface PBAPIClient : AFHTTPSessionManager

typedef void(^PBDevicesSuccessBlock) (NSURLSessionDataTask *task, id responseObject);
typedef void(^PBPushSuccessBlock)    (NSURLSessionDataTask *task, id responseObject);
typedef void(^PBFailBlock)           (NSURLSessionDataTask *task, NSError *error);

@property (strong, nonatomic) NSString *apiKey;

+ (PBAPIClient *)sharedClient;

- (void)getDevicesWithSuccess:(PBDevicesSuccessBlock)successBlock
                         fail:(PBFailBlock)failBlock;

- (void)pushNoteWithDeviceIDEN:(NSString *)deviceIDEN
                         title:(NSString *)title
                          body:(NSString *)body
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock;

- (void)pushLinkWithDeviceIDEN:(NSString *)deviceIDEN
                         title:(NSString *)title
                           url:(NSString *)urlString
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock;

- (void)pushAddressWithDeviceIDEN:(NSString *)deviceIDEN
                             name:(NSString *)name
                          address:(NSString *)address
                          success:(PBPushSuccessBlock)successBlock
                             fail:(PBFailBlock)failBlock;

- (void)pushListWithDeviceIDEN:(NSString *)deviceIDEN
                         title:(NSString *)title
                         items:(NSArray *)items
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock;

- (void)pushFileWithDeviceIDEN:(NSString *)deviceIDEN
                          path:(NSString *)filepath
                       success:(PBPushSuccessBlock)successBlock
                          fail:(PBFailBlock)failBlock;

- (NSString *)prettyErrorForCode:(NSInteger)statusCode;

@end
