//
//  UIColor+MBCategory.m
//  WanFuJiaZheng
//
//  Created by jay on 14-5-13.
//  Copyright (c) 2014年 itnoc. All rights reserved.
//

#import "UIColor+MBCategory.h"

@implementation UIColor (MBCategory)

// takes @"#123456"
+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:(UInt32)x];
}

// takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue
{
    return [UIColor colorWithRed:(float)red/255.0f green:(float)green/255.0f blue:(float)blue/255.0f alpha:1];
}
@end
