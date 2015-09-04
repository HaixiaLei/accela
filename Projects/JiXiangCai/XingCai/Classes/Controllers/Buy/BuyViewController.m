//
//  BuyViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "BuyViewController.h"
#import "BuyChooseViewController.h"
#import "KindOfLottery.h"
#import "RightNavButton.h"
#import "EventsViewController.h"
#import "PlayRulesObject.h"
#import "SelectedNumber.h"
#import "BuyFinishViewController.h"
#import "DerivedViewController.h"
@implementation BuyViewController
{
    EventsViewController *eventsViewController; //热门活动
    NSInteger jumpIndex;
}

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //登陆后刷新所有奖期
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryToGetJiangqi) name:NotificationUpdateAllJiangQi object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self setMyLotteryButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *bgImgName = IS_IPHONE4 ? @"lotterylist_bg_3p5" : @"lotterylist_bg_4p0";
    self.bgImgView.image = [UIImage imageNamed:bgImgName];
    
    CGRect frame = self.eventButton.frame;
    frame.origin.y = SystemVersion >= 7.0 ? 28 : 8;
    self.eventButton.frame = frame;
    
    frame = self.betButtonLayer.frame;
    if(IS_IPHONE4)
    {
        frame.origin.y = SystemVersion >= 7.0 ? 188 : 178;
    }
    else
    {
        frame.origin.y = SystemVersion >= 7.0 ? 250 : 240;
    }
    self.betButtonLayer.frame = frame;
    
    [[MessageManager sharedManager] updateMessages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
//显示热门活动按钮
- (void)showEventButton
{
    self.eventButton.hidden = NO;
}

- (void)setMyLotteryButton
{
    RightNavButton *rightNavButton = [[MessageManager sharedManager] rightNavButtonLotteryListWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [rightNavButton setPoint:CGPointMake(self.view.frame.size.width - rightNavButton.frame.size.width - 5, SystemVersion >= 7.0 ? 20 : 0)];
    [self.view insertSubview:rightNavButton aboveSubview:self.bgImgView];
}

#pragma mark - Action
//显示我的彩票右侧菜单
- (void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

//显示热门活动
- (IBAction)eventAction:(id)sender {
    self.eventButton.hidden = YES;
    if (!eventsViewController) {
        eventsViewController = [[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil];
        eventsViewController.view.frame = self.view.frame;
        [self.view addSubview:eventsViewController.view];
        eventsViewController.view.center = self.view.center;
        [self addChildViewController:eventsViewController];
    }
    else
    {
        [eventsViewController updateEvents];
    }
    eventsViewController.view.hidden = NO;
}

//立即投注
- (IBAction)betNowAction:(UIButton *)sender {
    
    
    jumpIndex = sender.tag;
    NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
    self.kindOfLottery = [lotteryList objectAtIndex:jumpIndex];

   
    NSString *string  =[[NSUserDefaults standardUserDefaults]objectForKey:@"judge"];
    NSString *titleSring;
    if ([string isEqualToString:@"ssc"]) {
        titleSring =[NSString stringWithFormat:@"您在重庆时时彩还有未结算的投注\n您是否需要清空记录?"];
    }else if ([string isEqualToString:@"rbssc"]){
        titleSring =[NSString stringWithFormat:@"您在日本时时彩还有未结算的投注\n您是否需要清空记录?"];
    }
  
    
    if (![self.kindOfLottery.lotteryName isEqualToString:string]&&[SelectedNumber getInstance].infoArray.count>0) {
        [Utility showErrorWithMessage:titleSring delegate:self cancelButtonTitle:@"清空" otherButtonTitles:@"去结算" tag:AlertViewTypeConfirm duplicationPrevent:YES];
        
    }else
    {
//        NSInteger index = sender.tag;
//        
//        NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
//        KindOfLottery *kindOfLottery = [lotteryList objectAtIndex:index];
        
        PlayRulesObject *playRulesObject = [[AppCacheManager sharedManager] getPlayRulesObjectWithKindOfLottery:self.kindOfLottery];
        if (playRulesObject) {
            if (!self.kindOfLottery.latestJiangQi || !self.kindOfLottery.latestKeZhuiHaoJiangQi) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //刷新某个奖期
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jiangQiUpdateFinished:) name:NotificationJiangQiUpdateFinished object:nil];
                [[JiangQiManager sharedManager] updateJiangQiWithKindOfLottery:self.kindOfLottery];
            }
            else
            {
                [self jumpToBuyChooseViewAtIndex:jumpIndex];
            }
        }
        else
        {
            [Utility showErrorWithMessage:[[AppCacheManager sharedManager] menuAndRuleErrorMsgWithKindOfLottery:self.kindOfLottery] delegate:self tag:AlertViewTypeMenuAndRuleError];
        }
    }
}

//跳转到选号页
-(void)jumpToBuyChooseViewAtIndex:(NSInteger)index
{
    NSString *buyFinsh=[[NSUserDefaults standardUserDefaults]objectForKey:@"BuyFinsh"];

    if (![buyFinsh isEqualToString:@""]&&[SelectedNumber getInstance].infoArray.count>0)
    {
        BuyFinishViewController *buyFinVC = [[BuyFinishViewController alloc] initWithNibName:@"BuyFinishViewController" bundle:nil];
       
        [self.navigationController pushViewController:buyFinVC animated:YES];
    }
    else
    {
        NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
        BuyChooseViewController *bcVC = [[BuyChooseViewController alloc] initWithNibName:@"BuyChooseViewController" bundle:nil];
        bcVC.kindOfLottery = [lotteryList objectAtIndex:index];
        [self.navigationController pushViewController:bcVC animated:YES];
    }
}

#pragma mark - 获取数据
//获取奖期
- (void)tryToGetJiangqi
{
    [[JiangQiManager sharedManager] updateAllJiangQi];
}

- (void)jiangQiUpdateFinished:(NSNotification *)notification
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationJiangQiUpdateFinished object:nil];
    
    id object = notification.object;
    if ([object isKindOfClass:[KindOfLottery class]]) {
        KindOfLottery *kindOfLottery = (KindOfLottery *)object;
        NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
        KindOfLottery *updatedKindOfLottery = [lotteryList objectAtIndex:jumpIndex];
        
        if (kindOfLottery == updatedKindOfLottery) {
            [self jumpToBuyChooseViewAtIndex:jumpIndex];
        }
    }
    else if ([object isKindOfClass:[NSError class]]) {
        NSError *error = (NSError *)object;
        [Utility showErrorWithMessage:error.localizedFailureReason];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSInteger index;
    if (jumpIndex==0) {
        index=1;
    }else if(jumpIndex==1)
    {
        index=0;
    }

    if ([self.kindOfLottery.lotteryName isEqualToString:@"ssc"]) {
        jumpIndex =0;
    }else if ([self.kindOfLottery.lotteryName isEqualToString:@"rbssc"]){
        jumpIndex=1;
    }
    if (alertView.tag == AlertViewTypeMenuAndRuleError) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AppCacheManager sharedManager] updatePlayRulesWithCompletionBlock:^(NSError *error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }else if (alertView.tag == AlertViewTypeConfirm){
       
        switch (buttonIndex) {
            case 0:
                //清空
                [[SelectedNumber getInstance].infoArray removeAllObjects];
                [self jumpToBuyChooseViewAtIndex:jumpIndex];
                break;
            case 1:
                //去结算
                [[NSUserDefaults standardUserDefaults]setObject:@"BuyFinsh" forKey:@"BuyFinsh"];

                [self jumpToBuyChooseViewAtIndex:index];
                break;
            default:
                break;
        }
    }
}

@end
