//
//  BindCardInsertInfoViewController.m
//  XingCai
//
//  Created by Air.Zhao on 15-5-12.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindCardInsertInfoViewController.h"
#import "UIViewController+CustomNavigationBar.h"

@interface BindCardInsertInfoViewController ()
@end

@implementation BindCardInsertInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNavigationBarTitle:@"绑定银行卡" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
