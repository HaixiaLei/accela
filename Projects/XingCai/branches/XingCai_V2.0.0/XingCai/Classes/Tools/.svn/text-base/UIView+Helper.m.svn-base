//
//  UIView+Helper.m
//  News
//
//  Created by jay on 13-7-26.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)hide
{
    self.hidden = YES;
}
- (void)show
{
    self.hidden = NO;
}
- (void)setPoint:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}
- (CGPoint)point
{
    return self.frame.origin;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}
@end

@implementation UIButton (Helper)

- (void)select
{
    self.selected = YES;
}
- (void)unSelect
{
    self.selected = NO;
}
@end