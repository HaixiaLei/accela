//
//  AppAlertViewTestViewController.m
//  HengCai
//
//  Created by jay on 14-8-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AppAlertViewTestViewController.h"

@interface AppAlertViewTestViewController ()

@end

@implementation AppAlertViewTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (IBAction)showErrorWithMessage:(id)sender {
    [Utility showErrorWithMessage:@"失败！"];
}

- (IBAction)showErrorWithMessageAndDelegate:(id)sender{
    [Utility showErrorWithMessage:@"您的账号在别处登录" delegate:self];
}

- (IBAction)showErrorWithMessageAndDelegateAndTag:(id)sender {
    [Utility showErrorWithMessage:@"您的账号在别处登录" delegate:self tag:1];
}
- (IBAction)showErrorWithMessageAndDelegateAndTagAndduplicationPrevent:(id)sender {
    [Utility showErrorWithMessage:@"您的账号在别处登录" delegate:self tag:1 duplicationPrevent:YES];
    [Utility showErrorWithMessage:@"您的账号在别处登录" delegate:self tag:1 duplicationPrevent:NO];
}
- (IBAction)showMessageWithAll:(id)sender {
    [Utility showErrorWithMessage:@"您是否退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeLogout duplicationPrevent:YES];
}
- (IBAction)showMessageWithAllAndTitle:(id)sender {
    [Utility showErrorWithTittle:@"标题" message:@"123" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"sure" tag:1 duplicationPrevent:YES];
}

-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        NSLog(@"cancel");
    }
    else
    {
        NSLog(@"not cancel");
    }
}


@end
