//
//  BindBankCardSuccessfulViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindBankCardSuccessfulViewController.h"
#import "AccountViewController.h"
#import "ReloadViewController.h"

@interface BindBankCardSuccessfulViewController ()
@end

@implementation BindBankCardSuccessfulViewController

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
-(IBAction)returnBtnClk:(UIButton *)sender
{
    AccountViewController *accountVC=[[AccountViewController alloc]initWithNibName:@"AccountViewController" bundle:nil];
    [self.navigationController pushViewController:accountVC animated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)gotoLoad:(UIButton *)sender
{
    ReloadViewController *rVC=[[ReloadViewController alloc]initWithNibName:@"ReloadViewController" bundle:nil];
    [self.navigationController pushViewController:rVC animated:NO];
}

@end
