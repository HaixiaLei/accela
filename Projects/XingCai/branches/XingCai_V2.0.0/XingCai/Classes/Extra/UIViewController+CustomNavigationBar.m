//
//  UIViewController+CustomNavigationBar.m
//  XingCai
//
//  Created by Villiam on 10/27/14.
//  Copyright (c) 2014 weststar. All rights reserved.
//

#import "UIViewController+CustomNavigationBar.h"

@implementation UIViewController (CustomNavigationBar)
-(void)setupNavigationBarTitle:(NSString *)title tintColor:(UIColor *)color navigationBarHidden:(BOOL)isHidden navigationBarTranslucent:(BOOL)isTranslucent 
{
    //setup navigationBar
    self.title=title;
    [self customTitleView];
    self.navigationController.navigationBar.tintColor=color;
    self.navigationController.navigationBarHidden = isHidden;
    self.navigationController.navigationBar.translucent=isTranslucent;
    //
}

-(void)setupNavigationBarTitle:(NSString *)title tintColor:(UIColor *)color navigationBarHidden:(BOOL)isHidden navigationBarTranslucent:(BOOL)isTranslucent withBackButtonItem:(BackActionType)btnItem
{
    //setup navigationBar
    [self setupNavigationBarTitle:title tintColor:color navigationBarHidden:isHidden navigationBarTranslucent:isTranslucent];
    [self setupBackNavigationItemInViewController:btnItem];
    //
}
@end
