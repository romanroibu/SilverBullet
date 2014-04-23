//
//  FileTabController.h
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabController.h"

@class AXStatusItemPopup;

@interface FileTabController : TabController <TabController>
@property (strong, nonatomic) NSURL *fileURL;

@property (weak, nonatomic) IBOutlet NSView *view;

@property AXStatusItemPopup *popupItem;
@end
