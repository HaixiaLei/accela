//
//  MoneyPasswordViewController.m
//  HengCai
//
//  Created by jay on 14-8-14.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MoneyPasswordViewController.h"
#import "WithdrawViewController.h"
#import "WithdrawObject.h"
#import "BankCardObject.h"
@interface MoneyPasswordViewController ()

@end

@implementation MoneyPasswordViewController

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
    
    [self adjustView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0) {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.passwordTF) {
        self.passwordbg.highlighted = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.passwordbg.highlighted = NO;
    [self.passwordTF resignFirstResponder];
    [self submitAction:self.submitButton];
    return YES;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordTF resignFirstResponder];
    self.passwordbg.highlighted = NO;
}


- (IBAction)submitAction:(id)sender
{
    if ([self.passwordTF.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"提款密码不能为空！"];
        return;
    }
    [self.view endEditing:YES];
    self.submitButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:self.passwordTF.text Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             NSString *check = [JSON objectForKey:@"check"];
             [[AppHttpManager sharedManager] tiKuangKeYongYinHangKaXinXiWithPassword:check Block:^(id JSON, NSError *error)
              {
                  self.submitButton.enabled = YES;
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  if (!error)
                  {
                      WithdrawObject *withdrawObject = [[WithdrawObject alloc] initWithDictionary:JSON];
                      NSArray *banks = [JSON objectForKey:@"banks"];
                      for (int i = 0; i < banks.count; ++i) {
                          NSDictionary *dict = [banks objectAtIndex:i];
                          NSString *theID = [dict objectForKey:@"id"];
                          
                          BankCardObject *bankCardObject = [withdrawObject.banks objectAtIndex:i];
                          bankCardObject.bankInfo = [NSString stringWithFormat:@"%@#%@",theID,bankCardObject.bank_id];
                      }
                      
                      WithdrawViewController *withdrawViewController = [[WithdrawViewController alloc] init];
                      withdrawViewController.hidesBottomBarWhenPushed = YES;
                      withdrawViewController.withdrawObject = withdrawObject;
                      withdrawViewController.check = check;
                      [self.navigationController pushViewController:withdrawViewController animated:YES];
                  }
                  else
                  {
                      DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                  }
              }];
         }
         else
         {
             self.submitButton.enabled = YES;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
@end
