//
//  TabController.h
//  SilverBullet
//
//  Created by Roman on 04.05.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXStatusItemPopup.h"

@protocol TabController <NSObject>
- (void)pushWithDeviceIDEN:(NSString *)IDEN completionBlock:(void (^)(NSError *error))completionBlock;
- (void)resetController;

- (NSString *)notificationDescription;

@optional
@property (weak, nonatomic) AXStatusItemPopup *statusBarItem;
@end

@interface TabController : NSObject

@end
