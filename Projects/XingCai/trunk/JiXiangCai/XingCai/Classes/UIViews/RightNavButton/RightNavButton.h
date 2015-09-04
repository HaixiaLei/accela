//
//  RightNavButton.h
//  JiXiangCai
//
//  Created by jay on 14-10-14.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightNavButton : UIView

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *dotImgView;

+ (RightNavButton *)rightNavButtonWithTarget:(id)target action:(SEL)action;

- (void)setTarget:(id)target action:(SEL)action;

- (void)setPoint:(CGPoint)point;

@end
