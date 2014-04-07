//
//  SBTPopupViewController.m
//
//  Created by Roman on 03.22.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "SBTPopupViewController.h"
#import "ITSidebarItemCell.h"

#import "NSColor+SBTPushButtonColors.h"

#import "PBAPIClient.h"

#import "TabController.h"
#import "SettingsTabController.h"

#import "AppDelegate.h"

@interface SBTPopupViewController () <NSUserNotificationCenterDelegate>

// Tab Controllers
@property (strong) IBOutlet NSObject<TabController> *noteTabController;
@property (strong) IBOutlet NSObject<TabController> *linkTabController;
@property (strong) IBOutlet NSObject<TabController> *addressTabController;
@property (strong) IBOutlet NSObject<TabController> *listTabController;
@property (strong) IBOutlet NSObject<TabController> *fileTabController;
@property (strong) IBOutlet SettingsTabController *settingsTabController;

// Data
@property (strong, nonatomic) PBAPIClient *client;
@property (strong, nonatomic) NSArray *deviceList; //of NSDictionary
@property (strong, nonatomic, readonly) NSDictionary *tabControllers;

@end

@implementation SBTPopupViewController

- (PBAPIClient *)client
{
    if (!_client) {
        _client = [PBAPIClient sharedClient];
    }
    return _client;
}

- (void)setDeviceList:(NSArray *)deviceList
{
    _deviceList = deviceList;
    NSArray *items = [deviceList valueForKeyPath:@"extras.nickname"];
    [self.devicesComboBox removeAllItems];
    [self.devicesComboBox addItemsWithObjectValues:items];
    self.canPush = [_deviceList count] > 0;
}

@synthesize tabControllers = _tabControllers;
- (NSDictionary *)tabControllers
{
    if (!_tabControllers) {
        _tabControllers = @{@"Note"     : self.noteTabController,
                            @"Link"     : self.linkTabController,
                            @"Address"  : self.addressTabController,
                            @"List"     : self.listTabController,
                            @"File"     : self.fileTabController};
    }
    return _tabControllers;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView
{
    [self viewWillLoad];
    [super loadView];
    [self viewDidLoad];
}

- (void)viewWillLoad
{
}

- (void)viewDidLoad {
    self.sidebar.cellSize = NSMakeSize(50, 50);
    
    [[self.sidebar addItemWithImage:[NSImage imageNamed:@"note"]
                     alternateImage:[NSImage imageNamed:@"note_highlight"]
                     target:self
                     action:@selector(noteSelected:)]
     setTintColor:[NSColor noteColor]];
    
    [[self.sidebar addItemWithImage:[NSImage imageNamed:@"link"]
                     alternateImage:[NSImage imageNamed:@"link_highlight"]
                     target:self
                     action:@selector(linkSelected:)]
     setTintColor:[NSColor linkColor]];
    
    [[self.sidebar addItemWithImage:[NSImage imageNamed:@"address"]
                     alternateImage:[NSImage imageNamed:@"address_highlight"]
                     target:self
                     action:@selector(addressSelected:)]
     setTintColor:[NSColor addressColor]];
    
    [[self.sidebar addItemWithImage:[NSImage imageNamed:@"list"]
                     alternateImage:[NSImage imageNamed:@"list_highlight"]
                     target:self
                     action:@selector(listSelected:)]
     setTintColor:[NSColor listColor]];
    
    [[self.sidebar addItemWithImage:[NSImage imageNamed:@"file"]
                     alternateImage:[NSImage imageNamed:@"file_highlight"]
                     target:self
                     action:@selector(fileSelected:)]
     setTintColor:[NSColor fileColor]];
    
    [[self.sidebar addItemWithImage:[NSImage imageNamed:@"settings"]
                     alternateImage:[NSImage imageNamed:@"settings_highlight"]
                             target:self
                             action:@selector(settingsSelected:)]
     setTintColor:[NSColor settingsColor]];

    // Check if the client has an API key
    if (self.client.apiKey) {
        // Refresh devices list if it has one
        [self devicesRefreshButtonAction:self];
    }

    // Show first tab
    [self.sidebar setSelectedIndex:0];

    // Set the block that is run before the popup is hidden
    self.popupItem.beforeHideBlock = ^{
        [self.pushButton setEnabled:YES];
        [self.pushSpinner stopAnimation:self];
        [self.devicesSpinner stopAnimation:self];
        [[self.client operationQueue] cancelAllOperations];
        [[self.tabControllers allValues] makeObjectsPerformSelector:@selector(resetController)];
    };
    
    // Set self as the notification center delegate
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

#pragma mark - IBActions

- (IBAction)devicesRefreshButtonAction:(id)sender {
    [self.devicesSpinner startAnimation:self];
    [self.client getDevicesWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        self.deviceList = [(NSDictionary *)responseObject objectForKey:@"devices"];
        if ([self.devicesComboBox indexOfSelectedItem] < 0 && [self.deviceList count] > 0) {
            [self.devicesComboBox selectItemAtIndex:0]; //If nothing is selected
            self.canPush = YES;
        }
        [self.devicesSpinner stopAnimation:self];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSInteger oldIndex = [self.devicesComboBox indexOfSelectedItem];
        [self.devicesComboBox deselectItemAtIndex:oldIndex];
        self.deviceList = [@[] mutableCopy];
        [self.devicesSpinner stopAnimation:self];
        
        if ([error.domain isEqualToString:AFNetworkingErrorDomain]) {
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            NSString *errorDescription = [self.client prettyErrorForCode:response.statusCode];
            if (response.statusCode == 401) {
                //API key error
                errorDescription =  @"It looks like the API key invalid or missing. "
                                    @"Please provide a valid API key in the Settings. ";
            }
            [self showErrorAlertWithDescription:errorDescription];
        } else {
            //TODO: LOG ERROR
        }
    }];
}

- (IBAction)pushButtonAction:(id)sender {
    [self.pushSpinner startAnimation:self];
    [self.pushButton setEnabled:NO];

    NSString *identifier = [[self.tabView selectedTabViewItem] identifier];
    id<TabController> controller = self.tabControllers[identifier];

    // Check if file tab controller and doesn't have file
    if ([controller respondsToSelector:@selector(fileURL)]) {
        if (![(id)controller fileURL]) {
            [self.pushSpinner stopAnimation:self];
            [self.pushButton setEnabled:YES];

            [self showErrorAlertWithDescription:@"Looks like you didn't provide a file, or the file size exceeds 25MB. "
                                                @"Please select a valid file to push"];
            return;
        }
    }
    
    NSInteger index = [self.devicesComboBox indexOfSelectedItem];
    NSString *IDEN = self.deviceList[index][@"iden"];
    
    [controller pushWithDeviceIDEN:IDEN completionBlock:^(NSError *error) {
        [self.pushSpinner stopAnimation:self];
        [self.pushButton setEnabled:YES];

        if (error) {
            if ([error.domain isEqualToString:AFNetworkingErrorDomain]) {
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSString *errorDescription = [self.client prettyErrorForCode:response.statusCode];
                if (response.statusCode == 401) {
                    //API key error
                    errorDescription =  @"It looks like the API key invalid or missing. "
                                        @"Please provide a valid API key in the Settings. ";
                }
                [self showErrorAlertWithDescription:errorDescription];
            } else {
                //TODO: LOG ERROR
            }
        } else {
            [self closePopup:self];
            [self postNotificationWithDescription:[controller notificationDescription]];
        }
    }];
}

- (void)postNotificationWithDescription:(NSString *)description
{
    AppDelegate *appDelegate = [NSApp delegate];
    if ([[appDelegate appSettings] allowNotifications]) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"Pushed Successfully!";
        notification.informativeText = description;
        notification.soundName = NSUserNotificationDefaultSoundName;

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

- (void)showErrorAlertWithDescription:(NSString *)description
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Oops! Something went wrong."];
    [alert setInformativeText:description];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert runModal];
}

#pragma mark - Popup Item Actions

- (IBAction)closePopup:(id)sender {
    [self.popupItem hidePopover];
}

#pragma mark - Sidebar Selection Actions

- (IBAction)noteSelected:(id)sender {
    [self changeTabWithIdentifier:@"Note" color:[NSColor noteColor]];
}

- (IBAction)linkSelected:(id)sender {
    [self changeTabWithIdentifier:@"Link" color:[NSColor linkColor]];
}

- (IBAction)fileSelected:(id)sender {
    [self changeTabWithIdentifier:@"File" color:[NSColor fileColor]];
}

- (IBAction)listSelected:(id)sender {
    [self changeTabWithIdentifier:@"List" color:[NSColor listColor]];
}

- (IBAction)addressSelected:(id)sender {
    [self changeTabWithIdentifier:@"Address" color:[NSColor addressColor]];
}

- (IBAction)settingsSelected:(id)sender {
    [self changeTabWithIdentifier:@"Settings" color:[NSColor settingsColor]];
}

- (void)changeTabWithIdentifier:(NSString *)identifier color:(NSColor *)color
{
    BOOL hidden = [identifier isEqualToString:@"Settings"];
    [self.devicesRefreshButton setHidden:hidden];
    [self.devicesComboBox setHidden:hidden];
    [self.pushButton setHidden:hidden];

    [self.tabView selectTabViewItemWithIdentifier:identifier];
}

#pragma mark - NSUserNotificationCenterDelegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
