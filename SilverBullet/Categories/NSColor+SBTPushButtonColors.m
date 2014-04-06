//
//  NSColor+SBTPushButtonColors.m
//
//  Created by Roman on 03.22.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "NSColor+SBTPushButtonColors.h"

@implementation NSColor (SBTPushButtonColors)

+ (NSColor *)noteColor
{
    return [NSColor colorWithSRGBRed:228.0f/255.0f green:124.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
}

+ (NSColor *)linkColor
{
    return [NSColor colorWithRed:62.0f/255.0f green:152.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
}

+ (NSColor *)listColor
{
    return [NSColor colorWithRed:156.0f/255.0f green:86.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
}

+ (NSColor *)fileColor
{
    return [NSColor colorWithRed:229.0f/255.0f green:71.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
}

+ (NSColor *)pushItColor
{
    return [NSColor colorWithRed:38.0f/255.0f green:175.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
}

+ (NSColor *)addressColor
{
//    return [NSColor colorWithRed:0.937f green:0.984f blue:0.0f alpha:1.0f]; //yellow
    return [NSColor colorWithRed:38.0f/255.0f green:176.0f/255.0f blue:101.0f/255.0f alpha:1.0f]; // green
}

+ (NSColor *)settingsColor
{
    return [NSColor colorWithRed:214.0f/255.0f green:214.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
}

+ (NSColor *)noHighlightColor
{
    //rgb_pcnt|{"r":0.47450980392157,"g":0.47450980392157,"b":0.47450980392157,"a":1}
    return [NSColor colorWithRed:0.47450980392157f green:0.47450980392157f blue:0.47450980392157f alpha:1.0f];
}


@end
