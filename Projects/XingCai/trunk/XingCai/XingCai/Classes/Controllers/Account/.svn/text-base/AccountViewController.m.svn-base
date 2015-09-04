//
//  AccountViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "AccountViewController.h"
#import "CashViewController.h"
#import "ATMViewController.h"
#import "BetSearchViewController.h"
#import "ZhuiHaoViewController.h"
#import "NSUserDefaultsManager.h"

@interface AccountViewController ()
@end

@implementation AccountViewController
@synthesize balanceLab;
@synthesize lockV;
@synthesize pwdLab;
@synthesize alertV;
@synthesize userNameLab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(void) getBalance
{
    [[AppHttpManager sharedManager] getBalanceWithBlock:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSString class]])
             {
                 balanceLab.text = JSON;
             }
             else
             {
                 DDLogWarn(@"JSON should be NSString,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
             if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"] && ![UserInfomation sharedInfomation].shouldLoginAgain) {
                 [Utility showErrorWithMessage:[JSON objectForKey:@"msg"]];
                 DDLogDebug(@"Utility showErrorMessage:%@",[JSON objectForKey:@"msg"]);
             }
         }
     }];
}
- (void)cleanBalance
{
    //balanceLab.text = @"0.0000";
    balanceLab.text = @"读取中...";
}
-(void) viewWillAppear:(BOOL)animated
{
    if (![[UserInfomation sharedInfomation].nickName isEqualToString:@""])
    {
        userNameLab.text = [@"你好！" stringByAppendingString:[UserInfomation sharedInfomation].nickName];
    }
    else
    {
        userNameLab.text = [@"你好！" stringByAppendingString:[NSUserDefaultsManager getUsername]];
    }
    lockV.hidden = YES;
    alertV.hidden  = YES;
    pwdLab.text = @"";
    pwdLab.delegate = self;
    [self getBalance];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanBalance) name:NotificationNameCleanBalance object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [pwdLab resignFirstResponder];
    return true;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pwdLab resignFirstResponder];
}
- (IBAction)cashAction:(id)sender
{
    lockV.hidden = NO;
    alertV.hidden  = NO;
}
- (IBAction)confirmAction:(id)sender
{
    [self.pwdLab resignFirstResponder];
    if ([pwdLab.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"提款密码不能为空！"];
        return;
    }
    
    self.sureButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:pwdLab.text Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             NSString *check = [JSON objectForKey:@"check"];
             [[AppHttpManager sharedManager] tiKuangKeYongYinHangKaXinXiWithPassword:check Block:^(id JSON, NSError *error)
              {
                  self.sureButton.enabled = YES;
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  if (!error)
                  {
                      CashViewController *cashVC = [[CashViewController alloc] init];
                      cashVC.hidesBottomBarWhenPushed = YES;
                      cashVC.JSON = JSON;
                      cashVC.check = check;
                      [self.navigationController pushViewController:cashVC animated:YES];
                  }
                  else
                  {
                      DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                  }
              }];
         }
         else
         {
             self.sureButton.enabled = YES;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];

}
- (IBAction)cancelAction:(id)sender
{
    [self.pwdLab resignFirstResponder];
    pwdLab.text = @"";
    lockV.hidden = YES;
    alertV.hidden  = YES;
}
- (IBAction)atmAction:(id)sender
{
    UIViewController *atmVC = [[ATMViewController alloc] init];
    atmVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:atmVC animated:YES];
}
- (IBAction)betAction:(id)sender
{
    UIViewController *betVC = [[BetSearchViewController alloc] init];
    betVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:betVC animated:YES];
}
- (IBAction)zhAction:(id)sender
{
    UIViewController *zhVC = [[ZhuiHaoViewController alloc] init];
    zhVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhVC animated:YES];
}
@end
