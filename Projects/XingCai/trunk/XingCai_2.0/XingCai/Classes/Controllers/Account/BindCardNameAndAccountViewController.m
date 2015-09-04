//
//  BindCardNameAndAccountViewController.m
//  XingCai
//
//  Created by Air.Zhao on 15-5-7.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindCardNameAndAccountViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "BindCardInsertInfoViewController.h"

@interface BindCardNameAndAccountViewController ()
@end

@implementation BindCardNameAndAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNavigationBarTitle:@"绑定银行卡" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bindCardInsertInfoAction:(id)sender
{
    UIViewController *bindCardIiVC = [[BindCardInsertInfoViewController alloc] init];
    bindCardIiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bindCardIiVC animated:YES];
}

@end
