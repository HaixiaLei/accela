//
//  BindCardViewController.m
//  XingCai
//
//  Created by Air.Zhao on 15-5-6.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindCardViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "BindCardNameAndAccountViewController.h"

@interface BindCardViewController ()
@end

@implementation BindCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBarTitle:@"绑定银行卡" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bindCardNameAndAccountAction:(id)sender
{
    UIViewController *bindCardNAVC = [[BindCardNameAndAccountViewController alloc] init];
    bindCardNAVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bindCardNAVC animated:YES];
}

@end
