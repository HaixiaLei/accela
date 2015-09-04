//
//  UIViewController+CustomTitleView.m
//  eCantonFair-Supplier
//
//  Created by LiangZF on 9/18/13.
//  Copyright (c) 2013 eCantonFair. All rights reserved.
//

#import "UIViewController+CustomTitleView.h"

@implementation UIViewController (CustomTitleView)

- (void)customTitleView{

    UILabel *_titleLabel;
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 30)];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont boldSystemFontOfSize:17];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.text= self.title;
//    _titleLabel.textAlignment=UITextAlignmentLeft;
    _titleLabel.textColor=[UIColor whiteColor];
    [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_titleLabel setNumberOfLines:2];
    
    self.navigationItem.titleView=_titleLabel;
}

@end
