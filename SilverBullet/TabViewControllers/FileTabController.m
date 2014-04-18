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

@interface FileTabController () {
    NSString *_notificationDescription;
}

@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSTextField *filenameTextField;
@property (weak) IBOutlet NSProgressIndicator *spinner;
- (IBAction)browseButtonAction:(id)sender;

@end

@implementation FileTabController

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

@end
