//
//  SettingsController.m
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "SettingsTabController.h"
#import "PBAPIClient.h"

static NSString * const kNotFirstTimeApplicationRunning = @"SilverBulletNotFirstTimeApplicationRunning";
static NSString * const kAllowLocalPushNotifications    = @"SilverBulletSettingsAllowLocalPushNotifications";

@interface SettingsTabController () <NSTextFieldDelegate> {
    NSUserDefaults *_defaults;
    PBAPIClient *_client;
}

@property (weak) IBOutlet NSTextField *apiKeyTextField;
@end

@implementation SettingsTabController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [PBAPIClient sharedClient];
        _defaults = [NSUserDefaults standardUserDefaults];
        
        // If the application is running for the first time, set some default behaviour
        if (![_defaults boolForKey:kNotFirstTimeApplicationRunning]) {
            [_defaults setBool:YES forKey:kNotFirstTimeApplicationRunning];
            [_defaults setBool:YES forKey:kAllowLocalPushNotifications];
            [_defaults synchronize];
        }
    }
    return self;
}

#pragma mark - Launch At StartUp Option

- (NSInteger)launchAtStartup
{
    // See if the app is currently in LoginItems.
    LSSharedFileListItemRef itemRef = [self itemRefInLoginItems];
    
    // Store away that boolean.
    BOOL isInList = itemRef != nil;
    
    // Release the reference if it exists.
    if (itemRef != nil) CFRelease(itemRef);
    
    return isInList ? NSOnState : NSOffState;
}

- (IBAction)launchAtStartupCheckboxAction:(NSButton *)sender {
    // Get the current state
    NSInteger isLaunchingAtStartup = [self launchAtStartup];
    
    // Toggle the state.
    sender.state = isLaunchingAtStartup == NSOnState ? NSOffState : NSOnState;
    
    // Get the LoginItems list.
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) return;
    
    LSSharedFileListItemRef itemRef;
    
    if (isLaunchingAtStartup == NSOnState) {
        // Remove the app from the LoginItems list.
        itemRef = [self itemRefInLoginItems];
        LSSharedFileListItemRemove(loginItemsRef,itemRef);
        if (itemRef != nil) CFRelease(itemRef);
    } else {
        // Add the app to the LoginItems list.
        CFURLRef appUrl = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        itemRef = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, appUrl, NULL, NULL);
    }
    
    if (itemRef) CFRelease(itemRef);
    CFRelease(loginItemsRef);
}

- (LSSharedFileListItemRef)itemRefInLoginItems {
    LSSharedFileListItemRef itemRef = nil;
    
    CFURLRef cfItemUrlPointer = NULL;
    NSURL *itemUrl = nil;
    
    // Get the app's URL.
    NSURL *appUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    // Get the LoginItems list.
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) return nil;
    
    // Iterate over the LoginItems.
    NSArray *loginItems = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItemsRef, nil);
    
    for (int currentIndex = 0; currentIndex < [loginItems count]; currentIndex++) {
        
        // Get the current LoginItem and resolve its URL.
        LSSharedFileListItemRef currentItemRef = (__bridge LSSharedFileListItemRef)[loginItems objectAtIndex:currentIndex];
        
        if (LSSharedFileListItemResolve(currentItemRef, 0, &cfItemUrlPointer, NULL) == noErr) {
            // Compare the URLs for the current LoginItem and the app.
            
            itemUrl = (__bridge NSURL *)cfItemUrlPointer;
            if ([itemUrl isEqual:appUrl]) {
                // Save the LoginItem reference.
                itemRef = currentItemRef;
            }
        }
    }

    // Retain the LoginItem reference.
    if (itemRef != nil) CFRetain(itemRef);
    CFRelease(loginItemsRef);
    if (cfItemUrlPointer) CFRelease(cfItemUrlPointer);
    
    return itemRef;
}

#pragma mark - Allow Local Push Notifications Option

- (BOOL)allowNotifications
{
    return [_defaults boolForKey:kAllowLocalPushNotifications];
}

@end
