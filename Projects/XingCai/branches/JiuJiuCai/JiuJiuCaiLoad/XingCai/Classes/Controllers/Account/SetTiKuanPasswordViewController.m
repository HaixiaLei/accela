//
//  SetTiKuanPasswordViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-23.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "SetTiKuanPasswordViewController.h"
#import "SetPwdSuccessViewController.h"

@interface SetTiKuanPasswordViewController ()
@end

@implementation SetTiKuanPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pwdTxt.delegate = self;
    self.pwdConfirmTxt.delegate = self;
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.pwdTxt)
    {
        [self.pwdConfirmTxt becomeFirstResponder];
    }
    if (textField == self.pwdConfirmTxt)
    {
        [self.pwdConfirmTxt resignFirstResponder];
        [self setPwdClk:nil];
    }
    return true;
}

-(IBAction)setPwdClk:(UIButton *)sender
{
    if ([self.pwdTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"提款密码不能为空!"];
        return;
    }
    if ([self.pwdConfirmTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"确认提款密码不能为空!"];
        return;
    }
    if (![self.pwdTxt.text isEqualToString:self.pwdConfirmTxt.text])
    {
        [Utility showErrorWithMessage:@"两次密码不一致,请重新输入!"];
        return;
    }
    //36-设置资金密码接口
    [[AppHttpManager sharedManager] setWithdrawPwdWithNewPassword:self.pwdTxt.text block:^(id JSON, NSError *error)
    {
        if (!error)
        {
            SetPwdSuccessViewController *setPwdSVC=[[SetPwdSuccessViewController alloc]initWithNibName:@"SetPwdSuccessViewController" bundle:nil];
            [self.navigationController pushViewController:setPwdSVC animated:NO];
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        }
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pwdTxt resignFirstResponder];
    [self.pwdConfirmTxt resignFirstResponder];
}
@end
