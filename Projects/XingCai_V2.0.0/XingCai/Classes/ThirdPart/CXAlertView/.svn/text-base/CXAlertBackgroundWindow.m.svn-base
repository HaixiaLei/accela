//
//  CXAlertBackgroundWindow.m
//  CXAlertViewDemo
//
//  Created by ChrisXu on 13/9/12.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXAlertBackgroundWindow.h"

const UIWindowLevel UIWindowLevelCXAlert = 1999.0;
const UIWindowLevel UIWindowLevelCXAlertBackground = 1998.0;

@implementation CXAlertBackgroundWindow

+ (CXAlertBackgroundWindow *)shared{
    static CXAlertBackgroundWindow *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CXAlertBackgroundWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    [_sharedClient makeKeyAndVisible];
    return _sharedClient;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelAlert - 1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    CGContextFillRect(context, self.bounds);
}

@end
