//
//  TabController.h
//  SilverBullet
//
//  Created by Roman on 04.05.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TabController <NSObject>
- (void)pushWithDeviceIDEN:(NSString *)IDEN completionBlock:(void (^)(NSError *error))completionBlock;
- (void)resetController;

- (NSString *)notificationDescription;
@end

@interface TabController : NSObject

@end
