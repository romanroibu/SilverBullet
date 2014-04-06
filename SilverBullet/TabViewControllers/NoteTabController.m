//
//  NoteTabController.m
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "NoteTabController.h"
#import "PBAPIClient.h"

@interface NoteTabController () {
    NSString *_notificationDescription;
}

@property (weak) IBOutlet NSTextField *titleTextFiled;
@property (weak) IBOutlet NSTextField *messageTextFiled;
@end

@implementation NoteTabController

- (void)pushWithDeviceIDEN:(NSString *)IDEN
       completionBlock:(void (^)(NSError *))completionBlock
{
    NSString *title = [self.titleTextFiled stringValue];
    NSString *message = [self.messageTextFiled stringValue];
    
    PBAPIClient *client = [PBAPIClient sharedClient];
    [client pushNoteWithDeviceIDEN:IDEN
                             title:title
                              body:message
    success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(nil);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(error);
    }];

    // Build the notification description
    _notificationDescription = [NSString stringWithFormat:@"Note titled \"%@\"", title];
}

- (void)resetController
{
    self.titleTextFiled.stringValue = @"";
    self.messageTextFiled.stringValue = @"";
}

- (NSString *)notificationDescription
{
    return _notificationDescription;
}

@end
