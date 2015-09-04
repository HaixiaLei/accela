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
#import "BuyViewController.h"
#import "AvatarSetViewController.h"
#import "AvatarView.h"
#import "MyMsgViewController.h"
#import "ReloadViewController.h"
#import "BindBankCardViewController.h"
#import "BindBankCardViewController.h"
#import "SetTiKuanPasswordViewController.h"

@interface AccountViewController ()
@end

@implementation AccountViewController
@synthesize balanceLab;
@synthesize lockV;
@synthesize pwdLab;
@synthesize alertV;
@synthesize userNameLab;
@synthesize scrollView;
@synthesize backImageView;
@synthesize bgIV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
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
             if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"] && ![UserInfomation sharedInfomation].shouldLoginAgain)
             {
                 [Utility showErrorWithMessage:[JSON objectForKey:@"msg"]];
                 DDLogDebug(@"Utility showErrorMessage:%@",[JSON objectForKey:@"msg"]);
             }
         }
     }];
}

- (void)getAvatar
{
    [[AppHttpManager sharedManager] getAvatarWithBlock:^(id JSON, NSError *error)
     {
         [self.refreshButton stop];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *dictionary = (NSDictionary *)JSON;
                 if ([dictionary.allKeys containsObject:@"head_portrait"]) {
                     NSString *avatarId = [dictionary objectForKey:@"head_portrait"];
                     [self setAvatarImageWithIndex:[avatarId integerValue]];
                 }
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}

- (void)setAvatarImageWithIndex:(NSInteger)avatarId
{
    NSString *imageName = [AvatarView avatarImageNameFromIndex:avatarId];
  
    self.avatarImageView.image = [UIImage imageNamed:imageName];
    [[NSUserDefaults standardUserDefaults]setObject:imageName forKey:@"myPhoto"];
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
        userNameLab.text = [@"你好: " stringByAppendingString:[UserInfomation sharedInfomation].nickName];
    }
    else
    {
        userNameLab.text = [@"你好: " stringByAppendingString:[NSUserDefaultsManager getUsername]];
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
    self.scrollView.contentSize = CGSizeMake(320, 630);
    bgIV.size = CGSizeMake(320, 800);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanBalance) name:NotificationNameCleanBalance object:nil];
    
    self.backImageView.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"tag_back01"],[UIImage imageNamed:@"tag_back02"],[UIImage imageNamed:@"tag_back03"], nil];
    [self.backImageView setAnimationDuration:1.2];
    [self.backImageView setAnimationRepeatCount:0];
    [self.backImageView startAnimating];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarSetAction:)];
    singleTap.numberOfTapsRequired = 1;
    [self.avatarImageView addGestureRecognizer:singleTap];
    [self getAvatar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [pwdLab resignFirstResponder];
    [self confirmAction:nil];
    return true;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pwdLab resignFirstResponder];
}

- (IBAction)ReloadACtion:(id)sender {
    
    ReloadViewController *reloadVC = [[ReloadViewController alloc] init];
    
    [self.navigationController pushViewController:reloadVC animated:YES];



    //msgVC.hidesBottomBarWhenPushed = YES;

    
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
        [Utility showErrorWithMessage:@"提款密码不能为空!"];
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
                      DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                  }
              }];
         }
         else
         {
             self.sureButton.enabled = YES;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
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

- (IBAction)gotoBuyViewcontroller:(id)sender {
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.6;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    transition.type = kCATransitionReveal; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //将动画添加在视图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
  

    [self.navigationController popViewControllerAnimated:NO];
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

- (IBAction)avatarSetAction:(id)sender
{
    AvatarSetViewController *avatarVC = [[AvatarSetViewController alloc] init];
    [self.navigationController pushViewController:avatarVC animated:YES];
}

- (IBAction)logout:(UIButton *)sender
{
    sender.enabled = NO;
    [Utility showErrorWithMessage:@"您是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeLogout duplicationPrevent:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertViewTypeLogout)
    {
        if (buttonIndex==1)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[AppHttpManager sharedManager] logoutWithBlock:^(id JSON, NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                self.logoutButton.enabled = YES;
                if (!error)
                {
                    [UserInfomation sharedInfomation].shouldLoginAgain = YES;
                    DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLogout object:nil];
                }
                else
                {
                    DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                }
            }];
        }
        else
        {
            self.logoutButton.enabled = YES;
        }
    }
}
- (IBAction)myMsgAction:(id)sender
{
    MyMsgViewController *msgVC = [[MyMsgViewController alloc] init];
    //msgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (IBAction)refreshAction:(id)sender
{
    [self.refreshButton begin];
    [self getBalance];
    [self getAvatar];
}

//绑定银行卡-35
-(IBAction)bindBankCardVC:(id)sender
{
    [[AppHttpManager sharedManager] hasWithdrawPwdWithBlock:^(id JSON, NSError *error)
     {
         if (!error)
         {
             //id--->NSString-begin
             NSString *hasSetStr;
             id hasSet = [JSON objectForKey:@"has_set"];
             if ([hasSet isKindOfClass:[NSNumber class]])
             {
                 NSNumber *number = (NSNumber *) hasSet;
                 hasSetStr = number.stringValue;
             }
             else if ([hasSet isKindOfClass:[NSString class]])
             {
                 hasSetStr = [JSON objectForKey:@"has_set"];
             }
             //id--->NSString-end
             
             if ([hasSetStr isEqualToString:@"1"])
             {
                 BindBankCardViewController *bbcVC = [[BindBankCardViewController alloc] initWithNibName:@"BindBankCardViewController" bundle:nil];
                 [self.navigationController pushViewController:bbcVC animated:YES];
             }
             else
             {
                 SetTiKuanPasswordViewController *setPwdVC = [[SetTiKuanPasswordViewController alloc] initWithNibName:@"SetTiKuanPasswordViewController" bundle:nil];
                 [self.navigationController pushViewController:setPwdVC animated:YES];
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
@end
