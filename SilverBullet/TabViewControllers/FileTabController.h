//
//  FileTabController.h
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabController.h"

@interface FileTabController : TabController <TabController>
@property (strong, nonatomic) NSURL *fileURL;
@end
