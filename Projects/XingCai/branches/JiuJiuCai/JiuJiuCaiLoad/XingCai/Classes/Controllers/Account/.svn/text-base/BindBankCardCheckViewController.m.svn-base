//
//  BindBankCardCheckViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindBankCardCheckViewController.h"
#import "BindBankCardInsertInfoViewController.h"
#import "UIUtil.h"

@interface BindBankCardCheckViewController ()
@end

@implementation BindBankCardCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.accountNameTxt.delegate = self;
    self.accountNoTxt.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)returnBtnClk:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountNameTxt)
    {
        [self.accountNoTxt becomeFirstResponder];
    }
    if (textField == self.accountNoTxt)
    {
        [self.accountNoTxt resignFirstResponder];
        [self bindBankCardInsertInfoVC:nil];
    }
    return true;
}
//绑定银行卡-输入用户名&银行账号---33
-(IBAction)bindBankCardInsertInfoVC:(id)sender
{
    if ([self.accountNameTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"开户人姓名不能为空!"];
        return;
    }
    if ([self.accountNoTxt.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"银行账号不能为空!"];
        return;
    }
    
    [[AppHttpManager sharedManager] hasBindWithBlock:^(id JSON, NSError *error)
    {
        if (!error)
        {
            if ([[JSON objectForKey:@"isBind"] integerValue] == 1)
            {
                //susan21-6225888877774444-张发财
                [[AppHttpManager sharedManager] checkCardWithAccount:self.accountNoTxt.text accountName:self.accountNameTxt.text block:^(id JSON, NSError *error)
                {
                    if (!error)
                    {
                        if ([[JSON objectForKey:@"check_bank"] integerValue] >= 1000)
                        {
                            NSString *checkBank = [JSON objectForKey:@"check_bank"];
                            u_CheckBank = checkBank;
                            BindBankCardInsertInfoViewController *bbciiVC = [[BindBankCardInsertInfoViewController alloc] initWithNibName:@"BindBankCardInsertInfoViewController" bundle:nil];
                            [self.navigationController pushViewController:bbciiVC animated:YES];
                        }
                        else
                        {
                            [Utility showErrorWithMessage:[JSON objectForKey:@"msg"]];
                        }
                    }
                    else
                    {
                        DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                    }
                }];
            }
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountNameTxt resignFirstResponder];
    [self.accountNoTxt resignFirstResponder];
}

@end
