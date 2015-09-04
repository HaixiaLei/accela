//
//  UIViewController+CustomNavigationBar.h
//  XingCai
//
//  Created by Villiam on 10/27/14.
//  Copyright (c) 2014 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CustomTitleView.h"
#import "UIViewController+CustomNavigationLeftButtonItem.h"

@interface UIViewController (CustomNavigationBar)
-(void)setupNavigationBarTitle:(NSString *)title tintColor:(UIColor *)color navigationBarHidden:(BOOL)isHidden navigationBarTranslucent:(BOOL)isTranslucent;

-(void)setupNavigationBarTitle:(NSString *)title tintColor:(UIColor *)color navigationBarHidden:(BOOL)isHidden navigationBarTranslucent:(BOOL)isTranslucent withBackButtonItem:(BackActionType)btnItem;

@end
