//
//  SetPwdSuccessViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-23.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "SetPwdSuccessViewController.h"
#import "BindBankCardViewController.h"
#import "BuyViewController.h"

@interface SetPwdSuccessViewController ()

@end

@implementation SetPwdSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)returnBtnClk:(UIButton *)sender
{
    BuyViewController *buyVC=[[BuyViewController alloc]initWithNibName:@"BuyViewController" bundle:nil];
    [self.navigationController pushViewController:buyVC animated:NO];
}
-(IBAction)goToBindBankCardClk:(UIButton *)sender
{
    BindBankCardViewController *bbcSVC=[[BindBankCardViewController alloc]initWithNibName:@"BindBankCardViewController" bundle:nil];
    [self.navigationController pushViewController:bbcSVC animated:NO];
}

@end
