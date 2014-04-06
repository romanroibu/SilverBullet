//
//  AppSettings.h
//  SilverBullet
//
//  Created by Roman on 04.06.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

@property (nonatomic) NSInteger launchAtStartup;
- (IBAction)launchAtStartupButtonAction:(NSMenuItem *)sender;

@property (nonatomic) BOOL allowNotifications;
- (IBAction)allowNotificationsButtonAction:(NSMenuItem *)sender;


@end
