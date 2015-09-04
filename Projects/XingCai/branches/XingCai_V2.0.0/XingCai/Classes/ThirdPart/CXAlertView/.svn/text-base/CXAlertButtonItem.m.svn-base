//
//  CXAlertItem.m
//  CXAlertViewDemo
//
//  Created by ChrisXu on 13/9/12.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXAlertButtonItem.h"

@implementation CXAlertButtonItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_defaultRightLineVisible) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.000].CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, CGRectGetWidth(self.frame),0);
        CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        CGContextStrokePath(context);
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
    }
}
@end
