//
//  AccountViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "AccountViewController.h"
#import "WithdrawViewController.h"
#import "WithdrawRecordViewController.h"
#import "NSUserDefaultsManager.h"
#import "MyMsgViewController.h"
#import "AnnouncementViewController.h"
#import "MoneyPasswordViewController.h"
#import "ChangePasswordViewController.h"

@interface AccountViewController ()
@end

@implementation AccountViewController
@synthesize containerView;
@synthesize balanceLab;
@synthesize userNameLab;
@synthesize noticeImg;
@synthesize noticeLab;
@synthesize cashImg;
@synthesize cashLab;
@synthesize atmImg;
@synthesize atmLab;
@synthesize changePwdImg;
@synthesize changePwdLab;
@synthesize exitImg;
@synthesize exitLab;
@synthesize exitBtn;

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
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
             if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"] && ![UserInfomation sharedInfomation].shouldLoginAgain)
             {
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
        userNameLab.text = [[UserInfomation sharedInfomation] nickName];
    }
    else
    {
        userNameLab.text = [NSUserDefaultsManager getUsername];
    }
    [self getBalance];
}
- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0)
    {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanBalance) name:NotificationNameCleanBalance object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)msgAction:(id)sender
{
    UIViewController *msgVC = [[MyMsgViewController alloc] init];
    msgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (IBAction)touchDownNoticeAction:(id)sender
{
    noticeImg.image = [UIImage imageNamed:@"tag_notice_click"];
    noticeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(15/255.0) blue:(27/255.0) alpha:1];
}
- (IBAction)noticeAction:(id)sender
{
    noticeImg.image = [UIImage imageNamed:@"tag_notice_normal"];
    noticeLab.textColor = [UIColor colorWithRed:(215/255.0) green:(209/255.0) blue:(196/255.0) alpha:1];
    AnnouncementViewController *avc = [[AnnouncementViewController alloc] initWithNibName:@"AnnouncementViewController" bundle:nil];
    avc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:avc animated:YES];
}

- (IBAction)touchDownCashAction:(id)sender
{
    cashImg.image = [UIImage imageNamed:@"tag_withdraw_click"];
    cashLab.textColor = [UIColor colorWithRed:(255/255.0) green:(15/255.0) blue:(27/255.0) alpha:1];
}
- (IBAction)cashAction:(id)sender
{
    cashImg.image = [UIImage imageNamed:@"tag_withdraw_normal"];
    cashLab.textColor = [UIColor colorWithRed:(215/255.0) green:(209/255.0) blue:(196/255.0) alpha:1];
    MoneyPasswordViewController *moneyPasswordViewController = [[MoneyPasswordViewController alloc] initWithNibName:@"MoneyPasswordViewController" bundle:nil];
    moneyPasswordViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moneyPasswordViewController animated:YES];
}

- (IBAction)touchDownATMAction:(id)sender
{
    atmImg.image = [UIImage imageNamed:@"tag_recharge_click"];
    atmLab.textColor = [UIColor colorWithRed:(255/255.0) green:(15/255.0) blue:(27/255.0) alpha:1];
}
- (IBAction)atmAction:(id)sender
{
    atmImg.image = [UIImage imageNamed:@"tag_recharge_normal"];
    atmLab.textColor = [UIColor colorWithRed:(215/255.0) green:(209/255.0) blue:(196/255.0) alpha:1];
    UIViewController *atmVC = [[WithdrawRecordViewController alloc] init];
    atmVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:atmVC animated:YES];
}

- (IBAction)touchDownChangePwdBtn:(id)sender
{
    changePwdImg.image = [UIImage imageNamed:@"tag_modificate_password_click"];
    changePwdLab.textColor = [UIColor colorWithRed:(255/255.0) green:(15/255.0) blue:(27/255.0) alpha:1];
}
- (IBAction)touchCancelChangePwdBtn:(id)sender
{
    changePwdImg.image = [UIImage imageNamed:@"tag_modificate_password_normal"];
    changePwdLab.textColor = [UIColor colorWithRed:(215/255.0) green:(209/255.0) blue:(196/255.0) alpha:1];
    
    ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchDownExitBtn:(id)sender
{
    exitImg.image = [UIImage imageNamed:@"tag_changename_click"];
    exitLab.textColor = [UIColor colorWithRed:(255/255.0) green:(15/255.0) blue:(27/255.0) alpha:1];
}
- (IBAction)touchCancelExitBtn:(UIButton *)sender
{
    exitImg.image = [UIImage imageNamed:@"tag_changename_normal"];
    exitLab.textColor = [UIColor colorWithRed:(215/255.0) green:(209/255.0) blue:(196/255.0) alpha:1];
    sender.enabled = NO;
    [Utility showErrorWithMessage:@"您是否退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeLogout duplicationPrevent:YES];
}

-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertViewTypeLogout)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [[AppHttpManager sharedManager] logoutWithBlock:^(id JSON, NSError *error)
            {
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                
                self.exitBtn.enabled = YES;
                if (!error)
                {
                    [UserInfomation sharedInfomation].shouldLoginAgain = YES;
                    DLog(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
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
            self.exitBtn.enabled = YES;
        }
    }
}
@end
