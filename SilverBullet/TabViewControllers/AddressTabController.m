//
//  AddressTabController.m
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "AddressTabController.h"
#import "PBAPIClient.h"

@interface AddressTabController () {
    NSString *_notificationDescription;
}

@property (weak) IBOutlet NSTextField *titleTextFiled;
@property (weak) IBOutlet NSTextField *addressTextFiled;
@end

@implementation AddressTabController

- (void)pushWithDeviceIDEN:(NSString *)IDEN completionBlock:(void (^)(NSError *))completionBlock
{
    NSString *title = [self.titleTextFiled stringValue];
    NSString *address = [self.addressTextFiled stringValue];
    
    PBAPIClient *client = [PBAPIClient sharedClient];
    [client pushAddressWithDeviceIDEN:IDEN
                                 name:title
                              address:address
    success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(nil);
    }
    fail:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(error);
    }];
    
    // Build the notification description
    _notificationDescription = [NSString stringWithFormat:@"Address titled \"%@\"", title];
}

- (void)resetController
{
    self.titleTextFiled.stringValue = @"";
    self.addressTextFiled.stringValue = @"";
}

- (NSString *)notificationDescription
{
    return _notificationDescription;
}

@end
