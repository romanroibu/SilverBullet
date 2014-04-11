//
//  AppDelegate.m
//  SilverBullet
//
//  Created by Roman on 03.23.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "AppDelegate.h"

#import "PBAPIClient.h"

#import "SBTPopupViewController.h"
#import "AXStatusItemPopup.h"

//TODO: Edit the About document

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SBTPopupViewController *popupVC = [[SBTPopupViewController alloc] initWithNibName:@"SBTPopupViewController" bundle:nil];
    AXStatusItemPopup *statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:popupVC
                                                                                     image:[NSImage imageNamed:@"bullet_dark"]
                                                                            alternateImage:[NSImage imageNamed:@"bullet_light"]];
    [popupVC setPopupItem:statusItemPopup];
    [statusItemPopup setRightClickMenu:self.rightClickMenu];
}

- (IBAction)sendFeedback:(id)sender {
    
    NSString *address  = @"roman.roibu@gmail.com";
    NSString *subject  = @"SilverBullet Feedback";
    NSString *mailBody = @"";
    
    NSString *mailToURLString = [NSString stringWithFormat:@"mailto:%@?Subject=%@&Body=%@",
                                 address, subject, mailBody];
    
    NSURL *mailToURL = [NSURL URLWithString:[mailToURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [[NSWorkspace sharedWorkspace] openURL:mailToURL];
}

- (IBAction)rateThisApp:(id)sender {
#warning APP DELEGATE - RATE THIS APP - NOT IMPLEMENTED
    NSLog(@"RATE THIS APP!");
}

@end
