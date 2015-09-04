//
//  BindBankCardViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BindBankCardViewController.h"
#import "BindBankCardCheckViewController.h"
#import "BindBankCardInsertInfoViewController.h"
#import "UIUtil.h"

@interface BindBankCardViewController ()
@end

@implementation BindBankCardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tixianPin.text=@"";
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tixianPin.delegate = self;
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

//绑定银行卡-34
-(IBAction)bindBankCardCheckVC:(id)sender
{
    if ([self.tixianPin.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"提款密码不能为空!"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:self.tixianPin.text Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             NSString *check = [JSON objectForKey:@"check"];
             u_Check = check;
             
             [[AppHttpManager sharedManager] hasBindWithBlock:^(id JSON, NSError *error)//34
              {
                  if (!error)
                  {
                      if ([[JSON objectForKey:@"isBind"] integerValue] == 1)//需要验证
                      {
                          [self.tixianPin resignFirstResponder];
                          BindBankCardCheckViewController *bbccVC = [[BindBankCardCheckViewController alloc] initWithNibName:@"BindBankCardCheckViewController" bundle:nil];
                          [self.navigationController pushViewController:bbccVC animated:YES];
                      }
                      else//不需要验证，直接进入输入银行卡信息的页面
                      {
                          [self.tixianPin resignFirstResponder];
                          BindBankCardInsertInfoViewController *bbciiVC = [[BindBankCardInsertInfoViewController alloc] initWithNibName:@"BindBankCardInsertInfoViewController" bundle:nil];
                          [self.navigationController pushViewController:bbciiVC animated:YES];
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                  }
              }];
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.tixianPin resignFirstResponder];
    [self bindBankCardCheckVC:nil];
    return true;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tixianPin resignFirstResponder];
}

@end
