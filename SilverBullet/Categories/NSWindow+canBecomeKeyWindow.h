//
//  NSWindow+canBecomeKeyWindow.h
//  SilverBullet
//
//  Created by Roman on 03.23.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.

//
//  WARNING! THIS IS A HACK!
//  This Category is used to fix a bug with 10.7 where an NSPopover with a text field
//  cannot be edited if its parent window won't become key.
//  It allows any text field in the popover be editable, so is essential to the project.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (canBecomeKeyWindow)

@end
