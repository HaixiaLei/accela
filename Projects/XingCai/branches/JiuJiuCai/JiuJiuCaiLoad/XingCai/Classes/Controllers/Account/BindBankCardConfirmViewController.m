//
//  BindBankCardConfirmViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindBankCardConfirmViewController.h"
#import "BindBankCardSuccessfulViewController.h"
#import "MyProfile.h"
#import "UIUtil.h"

@interface BindBankCardConfirmViewController ()
@end

@implementation BindBankCardConfirmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MyProfile *myprofile = [[MyProfile alloc] init];
    self.userNameLab.text = [myprofile getUserName];
    self.bankNameLab.text = u_bank;
    self.provinceLab.text = u_province;
    self.cityLab.text = u_city;
    self.branchLab.text = u_branch;
    self.accountNameLab.text = u_account_name;
    self.accountNoLab.text = u_account;
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
//绑定银行卡-成功
-(IBAction)bindBankCardSuccessfulVC:(id)sender
{
    [[AppHttpManager sharedManager] comfirmCardWithBankName:u_bank bankId:u_bank_id province:u_province provinceId:u_province_id city:u_city cityId:u_city_id bankBranch:u_branch account:u_account accountName:u_account_name addBankCode:u_add_bank_code block:^(id JSON, NSError *error)
    {
        if (!error)
        {
            BindBankCardSuccessfulViewController *bbcsVC = [[BindBankCardSuccessfulViewController alloc] initWithNibName:@"BindBankCardSuccessfulViewController" bundle:nil];
            [self.navigationController pushViewController:bbcsVC animated:YES];
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        }
    }];
}

@end
