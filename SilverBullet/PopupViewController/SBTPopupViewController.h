//
//  PBPopupViewController.h
//  Pushbullet Statusbar
//
//  Created by Roman on 03.22.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ITSidebar.h"
#import "AXStatusItemPopup.h"

@interface SBTPopupViewController : NSViewController

@property (weak, nonatomic) AXStatusItemPopup *popupItem;
@property (weak, nonatomic) IBOutlet ITSidebar *sidebar;

// UI Elements
@property (weak) IBOutlet NSTabView *mainTabView;
@property (weak) IBOutlet NSTabView *pushTabView;

@property (weak) IBOutlet NSButton *pushButton;
@property (weak) IBOutlet NSComboBox *devicesComboBox;
@property (weak) IBOutlet NSButton *devicesRefreshButton;
@property (weak) IBOutlet NSProgressIndicator *pushSpinner;
@property (weak) IBOutlet NSProgressIndicator *devicesSpinner;

@property (nonatomic) BOOL canPush;

@end
