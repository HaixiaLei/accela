//
//  UIViewController+CustomNavigationLeftButtonItem.m
//  e-Cantonfair
//
//  Created by LiangZF on 1/16/14.
//  Copyright (c) 2014 ecantonfair. All rights reserved.
//

#import "UIViewController+CustomNavigationLeftButtonItem.h"

@implementation UIViewController (CustomNavigationLeftButtonItem)
-(void)setupBackNavigationItemInViewController:(BackActionType)actionType
{
    // 导航栏的返回键
     UIBarButtonItem *barBtnGoBack;
    UIImage *backImgHL = [UIImage imageNamed:@"btn_return_normal.png"];
    UIButton *backImgBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImgHL.size.width, backImgHL.size.height)];
    [backImgBtn setImage:backImgHL forState:UIControlStateNormal];

    if (actionType == BackActionPop) {
        [backImgBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
    
        [backImgBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    barBtnGoBack = [[UIBarButtonItem alloc] initWithCustomView:backImgBtn];
    
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:Nil action:nil];
    spaceItem.width=-10;
    if (IOS_VERSION>=7.0) {
        [self.navigationItem setLeftBarButtonItems:@[spaceItem,barBtnGoBack]];
//        self.navigationItem.leftBarButtonItem = barBtnGoBack;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        
    }
    else{
        [self.navigationItem setLeftBarButtonItems:@[barBtnGoBack]];
    }
    
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector{

    if (!image) {
        return nil;
    }
    
    UIBarButtonItem *barButton;
    
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, image.size.width, image.size.height)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barButton;
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image disableImage:(UIImage *)disableImage target:(id)target selector:(SEL)selector{

    if (!image) {
        return nil;
    }
    
    UIBarButtonItem *barButton;
    
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, image.size.width, image.size.height)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:disableImage forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barButton;
}

@end
