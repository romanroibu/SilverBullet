//
//  AppDelegate.h
//  SilverBullet
//
//  Created by Roman on 03.23.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppSettings.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *rightClickMenu;

@property (weak) IBOutlet AppSettings *appSettings;

- (IBAction)sendFeedback:(id)sender;
- (IBAction)rateThisApp:(id)sender;

@end
