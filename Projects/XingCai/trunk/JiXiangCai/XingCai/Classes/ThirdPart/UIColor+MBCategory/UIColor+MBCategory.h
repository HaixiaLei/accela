//
//  UIColor+MBCategory.h
//  WanFuJiaZheng
//
//  Created by jay on 14-5-13.
//  Copyright (c) 2014年 itnoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MBCategory)

+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

+ (UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue;
@end
