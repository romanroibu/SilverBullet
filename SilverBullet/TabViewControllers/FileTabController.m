//
//  FileTabController.m
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "FileTabController.h"
#import "PBAPIClient.h"

#import "NSImage+QuickLook.h"

#import "AXStatusItemPopup.h"

@interface FileTabController () <AXStatusItemPopupDelegate> {
    NSString *_notificationDescription;
}

@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSTextField *filenameTextField;
@property (weak) IBOutlet NSProgressIndicator *spinner;
- (IBAction)browseButtonAction:(id)sender;

@end

@implementation FileTabController

@synthesize statusBarItem = _statusBarItem;

- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = fileURL;
    
    if (!fileURL) {
        self.filenameTextField.stringValue = @"No file selected";
        self.iconImageView.image = [NSImage imageNamed:@"nofile"];
        return;
    }

    self.filenameTextField.stringValue = [[fileURL path] lastPathComponent];

    [self.spinner startAnimation:nil];
    dispatch_queue_t otherQ = dispatch_queue_create("File Set Preview Queue", NULL);
    dispatch_async(otherQ, ^{
        NSImage *filePreview = [NSImage imageWithPreviewOfFileAtPath:[fileURL path]
                                                              ofSize:self.iconImageView.bounds.size
                                                              asIcon:YES];
        self.iconImageView.image = filePreview;
    });
}

- (IBAction)browseButtonAction:(id)sender {

    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowsMultipleSelection = NO;
    panel.canChooseDirectories = NO;

    // Save the current popover window level
    NSWindow *popoverWindow = self.view.window;
    NSInteger popoverLevel = [popoverWindow level];
    
    // Set the level to the panel's level
    // To ensure proper window ordering
    [popoverWindow setLevel:[panel level]];

    // Save the current popover behavior and popupItem delegate
    NSPopoverBehavior popoverBehavior = self.popupItem.popover.behavior;
    id <AXStatusItemPopupDelegate> popupItemDelegate = self.popupItem.delegate;

    // Set the popover behavior to application defined and delegate to self
    self.popupItem.popover.behavior = NSPopoverBehaviorApplicationDefined;
    self.popupItem.delegate = self;

    NSInteger result = [panel runModal];

    if (result == NSFileHandlingPanelOKButton) {
        NSURL *fileURL = panel.URL;
        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path]
                                                                                        error:nil]
                                       fileSize];

        if (fileSize < 26214400) {
            // File Size < 25MB - VALID!
            self.fileURL = fileURL;
        } else {
            // File Size > 25MB - INVALID!
            self.fileURL = nil;
            self.filenameTextField.stringValue = @"Files must be smaller than 25 MB";
        }
    } else {
        //CANCELED
    }

    // Set the level to initial value
    [popoverWindow setLevel:popoverLevel];
    
    // Set the popover behaviour and delegate to previous values
    self.popupItem.popover.behavior = popoverBehavior;
    self.popupItem.delegate = popupItemDelegate;
}

#pragma mark - TabController Protocol

- (void)pushWithDeviceIDEN:(NSString *)IDEN completionBlock:(void (^)(NSError *))completionBlock
{
    if (!self.fileURL) return;

    PBAPIClient *client = [PBAPIClient sharedClient];

    [client pushFileWithDeviceIDEN:IDEN
                              path:[self.fileURL path]
    success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(nil);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(error);
    }];
    
    // Build the notification description
    _notificationDescription = [NSString stringWithFormat:@"File named \"%@\"", [[self.fileURL path] lastPathComponent]];

}

- (void)resetController
{
    self.fileURL = nil;
}

- (NSString *)notificationDescription
{
    return _notificationDescription;
}

- (BOOL)shouldPopupClose
{
    return NO;
}

@end
