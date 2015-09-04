//
//  RightNavButton.m
//  JiXiangCai
//
//  Created by jay on 14-10-14.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "RightNavButton.h"

@implementation RightNavButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (RightNavButton *)rightNavButtonWithTarget:(id)target action:(SEL)action
{
    UIView *rootView = [[[NSBundle mainBundle] loadNibNamed:@"RightNavButton" owner:self options:nil] objectAtIndex:0];
    RightNavButton *rightNavButton = (RightNavButton *)rootView;
    [rightNavButton.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return rightNavButton;
}

- (void)setTarget:(id)target action:(SEL)action
{
    [self.rightButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPoint:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}
@end
