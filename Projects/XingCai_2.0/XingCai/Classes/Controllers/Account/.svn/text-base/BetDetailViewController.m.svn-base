//
//  BetDetailViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-6-29.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetDetailViewController.h"
#import "JiangQiManager.h"
#import "UIViewController+CustomNavigationBar.h"

@interface BetDetailViewController ()
@end

@implementation BetDetailViewController
@synthesize scrollView;
@synthesize projectID;
@synthesize cancelBtn;
@synthesize lotteryIcon;
@synthesize lotteryName;
@synthesize jiangqiLab;
@synthesize userLab;
@synthesize timeLab;
@synthesize wanfaLab;
@synthesize modesLab;
@synthesize jinELab;
@synthesize multipleLab;
@synthesize bonusLab;
@synthesize statusLab;
@synthesize projectIDLab;
@synthesize codeTV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBarTitle:@"投注详情" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    
    if (!IS_IPHONE5)
    {
        self.scrollView.contentSize = CGSizeMake(320, 524);
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setButtonHidden:) name:Notification_JiangQi_OutTime object:nil];
}
-(void)setButtonHidden:(NSNotification *)notification
{
    cancelBtn.hidden = YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_JiangQi_OutTime object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] betDetail_WithProjectid:projectID Block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *itemDic = JSON;
                 
                 lotteryName.text = [itemDic objectForKey:@"cnname"];
                 jiangqiLab.text = [itemDic objectForKey:@"issue"];
                 userLab.text = [itemDic objectForKey:@"username"];
                 timeLab.text = [itemDic objectForKey:@"writetime"];
                 wanfaLab.text = [itemDic objectForKey:@"methodname"];
                 modesLab.text = [itemDic objectForKey:@"modes"];
                 jinELab.text = [itemDic objectForKey:@"totalprice"];
                 multipleLab.text = [[itemDic objectForKey:@"multiple"] stringByAppendingString:@"倍"];
                 bonusLab.text = [itemDic objectForKey:@"bonus"];
                 if ([[itemDic objectForKey:@"lotteryid"] isEqualToString:@"1"])
                 {
                     [lotteryIcon setImage:[UIImage imageNamed:@"icon_cq"]];
                 }
                 else if([[itemDic objectForKey:@"lotteryid"] isEqualToString:@"14"])
                 {
                     [lotteryIcon setImage:[UIImage imageNamed:@"icon_henei"]];
                 }
                 
                 NSString *currentJiangQi;
                 NSArray *kindOfLotteries = [[AppCacheManager sharedManager] getLotteryList];
                 for (KindOfLottery *kindOfLottery in kindOfLotteries) {
                     if([kindOfLottery.lotteryId isEqualToString:[itemDic objectForKey:@"lotteryid"]])
                     {
                         currentJiangQi = kindOfLottery.currentJiangQi;
                         break;
                     }
                 }

                 NSString *currentNo = [currentJiangQi stringByReplacingOccurrencesOfString:@"-" withString:@""];
                 NSString *betNo = [[itemDic objectForKey:@"issue"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                 //判断当前奖期是否过期
//                 DLog(@"---------------------->%qi", [currentNo longLongValue]);
//                 DLog(@"---------------------->%qi", [betNo longLongValue]);
//                 if ([currentNo longLongValue] > [betNo longLongValue])
//                 {
//                     cancelBtn.hidden = YES;
//                 }
                 if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"1"])
                 {
                     statusLab.text = @"本人撤单";
                 }
                 else if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"2"])
                 {
                     statusLab.text = @"平台撤单";
                 }
                 else if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"3"])
                 {
                     statusLab.text = @"错开撤单";
                 }
                 else if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"0"])
                 {
                     if ([[itemDic objectForKey:@"isgetprize"] isEqualToString:@"0"])
                     {
                         statusLab.text = @"未开奖";
                         if ([currentNo longLongValue] > [betNo longLongValue])
                         {
                             cancelBtn.hidden = YES;
                         }
                         else if ([currentNo longLongValue] == [betNo longLongValue])
                         {
                             cancelBtn.hidden = NO;
                         }
                     }
                     else if ([[itemDic objectForKey:@"isgetprize"] isEqualToString:@"2"])
                     {
                         statusLab.text = @"未中奖";
                     }
                     else
                     {
                         if ([[itemDic objectForKey:@"prizestatus"] isEqualToString:@"0"])
                         {
                             statusLab.text = @"未派奖";
                         }
                         else
                         {
                             statusLab.text = @"已派奖";
                         }
                     }
                 }
                 projectIDLab.text = [itemDic objectForKey:@"projectid"];
                 codeTV.text = [itemDic objectForKey:@"code"];
             }
             else
             {
                 DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
-(IBAction)cancelClk:(UIButton *)sender
{
    [Utility showErrorWithMessage:@"您确定要撤单吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:1 duplicationPrevent:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {}
        else
        {
            cancelBtn.enabled = false;
            
            [[AppHttpManager sharedManager] cancelOrder_WithProjectid:projectID Block:^(id JSON, NSError *error)
             {
                 if (!error)
                 {
                     if ([JSON isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *itemDic = JSON;
                         [Utility showErrorWithMessage:[[itemDic objectForKey:@"msg"] stringByAppendingString:@"!"] delegate:self tag:2];
                     }
                     else
                     {
                         DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 else
                 {
                     DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                 }
             }];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
