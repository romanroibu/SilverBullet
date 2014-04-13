//
//  NSWindow+canBecomeKeyWindow.m
//  SilverBullet
//
//  Created by Roman on 03.23.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "NSWindow+canBecomeKeyWindow.h"

@implementation NSWindow (canBecomeKeyWindow)

//The pragma statements disable the corresponding warning for overriding an already-implemented method
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (BOOL)canBecomeKeyWindow
{
    return YES;
}
#pragma clang diagnostic pop

@end
