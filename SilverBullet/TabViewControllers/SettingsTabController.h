//
//  SettingsController.h
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBAPIClient.h"

@interface SettingsTabController : NSObject

// Launch At Startup Option
@property (nonatomic) NSInteger launchAtStartup;
- (IBAction)launchAtStartupCheckboxAction:(NSButton *)sender;

// Allow Local Push Notifications Option
@property (nonatomic) BOOL allowNotifications;

// Bottom Buttons' Actions
- (IBAction)sendFeedback:(id)sender;
- (IBAction)rateThisApp:(id)sender;

@end
