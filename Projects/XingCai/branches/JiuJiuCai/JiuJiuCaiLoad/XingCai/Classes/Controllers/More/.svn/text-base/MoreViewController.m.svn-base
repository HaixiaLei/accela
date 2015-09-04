//
//  MoreViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "MoreViewController.h"
#import "MyMsgViewController.h"
#import "AnnouncementViewController.h"
#import "FeedbackViewController.h"
#import "KeZhuiHaoJiangQiObject.h"
#import "InfoOfPlayMethodViewController.h"
@interface MoreViewController ()
@end

@implementation MoreViewController
@synthesize msgIV;
@synthesize noticeIV;
@synthesize playIV;

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
    msgIV.hidden = NO;
    noticeIV.hidden = NO;
    playIV.hidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myMsgTouchDown:(id)sender
{
    msgIV.hidden = YES;
}
- (IBAction)myMsgTouchExit:(id)sender
{
    msgIV.hidden = NO;
}
- (IBAction)myMsgAction:(id)sender
{
    UIViewController *bcVC = [[MyMsgViewController alloc] init];
    bcVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bcVC animated:YES];
}

- (IBAction)announcementTouchDown:(id)sender
{
    noticeIV.hidden = YES;
}
- (IBAction)announcementTouchExit:(id)sender
{
    noticeIV.hidden = NO;
}
- (IBAction)announcementAction:(id)sender
{
    UIViewController *aVC = [[AnnouncementViewController alloc] init];
    aVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aVC animated:YES];
}

- (IBAction)feedbackAction:(id)sender
{
    UIViewController *feedbackVC = [[FeedbackViewController alloc] init];
    feedbackVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

- (IBAction)play:(id)sender
{
//    InfoOfPlayMethodViewController *infoViewController= [[InfoOfPlayMethodViewController alloc] initWithNibName:@"InfoOfPlayMethodViewController" bundle:nil];
//    infoViewController.hidesBottomBarWhenPushed = YES;
//    infoViewController.infoType = InfoTypeHowToSaving;
//    infoViewController.tagName = @"工行充值";
//    [self.navigationController pushViewController:infoViewController animated:YES];
    InfoOfPlayMethodViewController *infoViewController= [[InfoOfPlayMethodViewController alloc] initWithNibName:@"InfoOfPlayMethodViewController" bundle:nil];
    infoViewController.infoType = InfoTypePlayMethod;
    infoViewController.tagName = @"时时彩";
    infoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoViewController animated:YES];
}

- (IBAction)playTouchDown:(id)sender
{
    playIV.hidden = YES;
}
- (IBAction)playTouchExit:(id)sender
{
    playIV.hidden = NO;
}
- (IBAction)answer:(id)sender
{
    InfoOfPlayMethodViewController *infoViewController= [[InfoOfPlayMethodViewController alloc] initWithNibName:@"InfoOfPlayMethodViewController" bundle:nil];
    infoViewController.hidesBottomBarWhenPushed = YES;
    infoViewController.infoType = InfoTypeAnswer;
    [self.navigationController pushViewController:infoViewController animated:YES];
}

- (IBAction)logout:(UIButton *)sender
{
    sender.enabled = NO;
    [Utility showErrorWithMessage:@"您是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeLogout duplicationPrevent:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertViewTypeLogout) {
        if (buttonIndex==1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[AppHttpManager sharedManager] logoutWithBlock:^(id JSON, NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                self.logoutButton.enabled = YES;
                if (!error) {
                    [UserInfomation sharedInfomation].shouldLoginAgain = YES;
                    DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLogout object:nil];
                }
                else
                {
                    DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                }
            }];
        }
        else
        {
            self.logoutButton.enabled = YES;
        }
    }
}
- (IBAction)test:(id)sender
{
    //开奖信息首页接口
    [[AppHttpManager sharedManager] getLotteryInfomationWithBlock:^(id JSON, NSError *error)
     {
         if (!error)
         {

         }
     }];

//    //奖期
//    [[AppHttpManager sharedManager] jiangQiWithKind:@"ssc" lotteryId:@"1" Block:^(id JSON, NSError *error)
//    {
//        if (!error)
//        {
//            NSLog(@"1--------------%@",[JSON objectForKey:@"issue"]);
//            NSLog(@"2--------------%@",[JSON objectForKey:@"nowtime"]);
//            NSLog(@"3--------------%@",[JSON objectForKey:@"saleend"]);
//        }
//    }];
    
    //可追号奖期
//    [[AppHttpManager sharedManager] keZhuiHaoJiangQiWithKind:@"ssc" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             NSArray *todayArr = [JSON objectForKey:@"today"];
//             NSMutableArray *zhuiHaoJQArr = [[NSMutableArray alloc] init];
//             for (int i = 0; i < todayArr.count; ++i)
//             {
//                 id oneObject = [todayArr objectAtIndex:i];
//                 if ([oneObject isKindOfClass:[NSDictionary class]])
//                 {
//                     NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
//                     KeZhuiHaoJiangQiObject *zhjqObj = [[KeZhuiHaoJiangQiObject alloc] initWithAttribute:oneObjectDict];
//                     [zhuiHaoJQArr addObject:zhjqObj];
//                 }
//                 else
//                 {
//                     NSLog(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
//                 }
//             }
//         }
//     }];
    
//    //投注接口
//    KindOfLottery *kindOfLottery = [[KindOfLottery alloc] init];
//    kindOfLottery.nav = @"ssc";
////    kindOfLottery.curmid = @"50";
//    
//    NSMutableArray *bettingInformations = [NSMutableArray array];
//    BettingInformation *bettingInformation = [[BettingInformation alloc] init];
//    bettingInformation.type = @"digital";
//    bettingInformation.methodid = @"24";
//    bettingInformation.codes = @"3|2";
//    bettingInformation.nums = @"1";
//    bettingInformation.omodel = @"2";
//    bettingInformation.times = @"9";
//    bettingInformation.money = @"0.18";
//    bettingInformation.mode = @"3";
//    bettingInformation.desc = @"[二码_后二直选(复式)] -,-,-,3,2";
//    [bettingInformations addObject:[Utility getProperties:bettingInformation]];
//    
//    bettingInformation = [[BettingInformation alloc] init];
//    bettingInformation.type = @"digital";
//    bettingInformation.methodid = @"24";
//    bettingInformation.codes = @"5|4";
//    bettingInformation.nums = @"1";
//    bettingInformation.omodel = @"2";
//    bettingInformation.times = @"9";
//    bettingInformation.money = @"0.18";
//    bettingInformation.mode = @"3";
//    bettingInformation.desc = @"[二码_后二直选(复式)] -,-,-,5,4";
//    [bettingInformations addObject:[Utility getProperties:bettingInformation]];
//    
//    
//    DLog(@"%@\n%@",bettingInformations,[Utility jsonStringFromJSONObject:bettingInformations]);
//    
//    [[AppHttpManager sharedManager] touZhuWithKind:kindOfLottery lotteryid:@"1" lt_issue_start:@"20140224-070" bettingInformations:bettingInformations lt_project_modes:@"3" lt_total_money:@"0.36" lt_total_nums:@"2" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];

//    //投注追号接口
//    KindOfLottery *kindOfLottery = [[KindOfLottery alloc] init];
//    kindOfLottery.nav = @"ssc";
//    
//    NSMutableArray *bettingInformations = [NSMutableArray array];
//    BettingInformation *bettingInformation = [[BettingInformation alloc] init];
//    bettingInformation.type = @"digital";
//    bettingInformation.methodid = @"24";
//    bettingInformation.codes = @"3&6|4&5&7";
//    bettingInformation.nums = @"6";
//    bettingInformation.omodel = @"2";
//    bettingInformation.times = @"1";
//    bettingInformation.money = @"12";
//    bettingInformation.mode = @"1";
//    bettingInformation.desc = @"[二码_后二直选(复式)] -,-,-,36,457";
//    [bettingInformations addObject:[Utility getProperties:bettingInformation]];
//    
//    DLog(@"%@",[Utility jsonStringFromJSONObject:bettingInformations]);
//    
//    [[AppHttpManager sharedManager] touZhuZhuiHaoWithKind:kindOfLottery lotteryid:@"1" lt_issue_start:@"20140224-080" bettingInformations:bettingInformations lt_project_modes:@"3" lt_total_money:@"0.36" lt_total_nums:@"2" lt_trace_count_input:@"10" lt_trace_diff:@"1" lt_trace_if:@"yes" lt_trace_margin:@"50" lt_trace_money:@"120" lt_trace_stop:@"yes" lt_trace_times_diff:@"2" lt_trace_times_margin:@"1" lt_trace_times_same:@"1" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];
    
    
    //可用余额--------------------------------------------------------------------------------------------------------------------------ok
//    [[AppHttpManager sharedManager] getBalanceWithBlock:^(id JSON, NSError *error)
//     {
//         if (!error){}
//     }];
    
//    //消息列表接口---------------------------------------------------------------------------------------------------------------------ok
//    [[AppHttpManager sharedManager] getMessageListWithPage:@"1" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];
    
//    //消息内容接口-----------------------------------------现在没图，只把数据取了出来------------------------------------------------------ok
//    [[AppHttpManager sharedManager] getMessageContentWithMessageId:@"1264075" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];

//    //删除消息接口
//    [[AppHttpManager sharedManager] deleteMessageContentWithMessageId:@"1264075" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];
    
    //网站公告接口-----------------------------------------------------------------------------------------------------------------------ok
//    [[AppHttpManager sharedManager] getNoticeListWithBlock:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];
    
//    //网站公告内容接口-----------------------------------------现在没图，只把数据取了出来------------------------------------------------------ok
//    [[AppHttpManager sharedManager] getNoticeContentWithNoticeId:@"13" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {      
//             
//         }
//     }];
    
//    //购彩查询接口-----------------------------------------现在没图，只把数据取了出来------------------------------------------------------ok
//    [[AppHttpManager sharedManager] gouCaiChaXunWithStartTime:@"2011-03-07 02:20:00" endTime:@"2014-03-08 02:20:00" Page:@"1" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];

//    //追号查询-----------------------------------------现在没图，只把数据取了出来------------------------------------------------------ok
//    [[AppHttpManager sharedManager] zhuiHaoChaXunWithStartTime:@"2011-01-07 02:20:00" endTime:@"2014-03-10 02:20:00" Page:@"1" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];

//    //充提查询接口-----------------------------------------现在没图，只把数据取了出来------------------------------------------------------ok
//    [[AppHttpManager sharedManager] chongTiChaXunWithStartTime:@"2014-01-07 02:20:00" endTime:@"2014-03-10 02:20:00" Page:@"1" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             
//         }
//     }];
//    //资金密码验证接口----------------------------------------------------------------------------------------------------------这个接口先不调，在银行卡的接口里被调了，提现的信息，从银行卡的那个接口读数据
//    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:@"qwe123" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             DLog(@"晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕晕");
//         }
//     }];

//    //提款可用银行卡信息接口------------------------------------------------------------------------------------------------------------ok
//    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:@"qwe123" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             [[AppHttpManager sharedManager] tiKuangKeYongYinHangKaXinXiWithPassword:[JSON objectForKey:@"check"] Block:^(id JSON, NSError *error)
//              {
//                  if (!error)
//                  {
//                      ;
//                  }
//              }];
//         }
//     }];
    
//    //确认提款信息接口-----------------------------------------------------------------------------------------------------------------ok
//    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:@"qwe123" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             [[AppHttpManager sharedManager] queRenTiKuangXinXiWithCheck:[JSON objectForKey:@"check"] bankInfo:@"45020#10" money:@"100" Block:^(id JSON, NSError *error)
//              {
//                  if (!error)
//                  {
//                      ;
//                  }
//              }];
//         }
//     }];
    
    //最终提款接口
//    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:@"qwe123" Block:^(id JSON, NSError *error)
//     {
//         if (!error)
//         {
//             NSString *check = [JSON objectForKey:@"check"];
//             [[AppHttpManager sharedManager] queRenTiKuangXinXiWithCheck:check bankInfo:@"45020#10" money:@"100" Block:^(id JSON, NSError *error)
//              {
//                  if (!error)
//                  {
//                      NSString *cardId = [JSON objectForKey:@"cardid"];
//                      NSString *money = [JSON objectForKey:@"money"];
//                      [[AppHttpManager sharedManager] zuiZhongTiKuangXinXiWithCheck:check cardId:cardId money:money Block:^(id JSON, NSError *errcor)
//                       {
//                           if (!error)
//                           {
//                               ;
//                           }
//                       }];
//                  }
//              }];
//         }
//     }];
}
@end
