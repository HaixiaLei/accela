//
//  BuyViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiangQiManager.h"

#define NotificationNameUpdateLotteryList @"NotificationNameUpdateLotteryList"

@interface BuyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
{
    //奖期倒数计时计时器
    NSTimer *countdownTimer;
    //当前奖期开始时间
    NSDate *currentDate;
    //当前奖期结束时间
    NSDate *endDate;

    //彩种信息
    NSArray *kindOfLotteries;
    //开奖信息
    NSMutableArray *openLotteries;
    UIScrollView *bannerScrollView;
    
     UILabel * daoJiShiLabel;
     UILabel * jiangQiLabel;
}

@property (strong, nonatomic) UITableViewCell *bannerCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
