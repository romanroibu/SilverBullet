//
//  LinkTabController.m
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "LinkTabController.h"
#import "PBAPIClient.h"

@interface LinkTabController () {
    NSString *_notificationDescription;
}

@property (weak) IBOutlet NSTextField *titleTextFiled;
@property (weak) IBOutlet NSTextField *linkTextFiled;
@end

@implementation LinkTabController

- (void)pushWithDeviceIDEN:(NSString *)IDEN completionBlock:(void (^)(NSError *))completionBlock
{
    NSString *title = [self.titleTextFiled stringValue];
    NSString *link = [self.linkTextFiled stringValue];
    
    PBAPIClient *client = [PBAPIClient sharedClient];
    [client pushLinkWithDeviceIDEN:IDEN
                             title:title
                               url:link
    success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(nil);
    }
    fail:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(error);
    }];

    // Build the notification description
    _notificationDescription = [NSString stringWithFormat:@"Link titled \"%@\"", title];
}

- (void)resetController
{
    self.titleTextFiled.stringValue = @"";
    self.linkTextFiled.stringValue = @"";
}

- (NSString *)notificationDescription
{
    return _notificationDescription;
}

@end
