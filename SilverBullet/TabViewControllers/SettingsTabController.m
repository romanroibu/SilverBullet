//
//  SettingsController.m
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "SettingsTabController.h"
#import "PBAPIClient.h"

@interface SettingsTabController () <NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *apiKeyTextField;

@property (strong, nonatomic) PBAPIClient *client;
@end

@implementation SettingsTabController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.client = [PBAPIClient sharedClient];
    }
    return self;
}

@end
