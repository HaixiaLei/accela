//
//  KindOfLottery.h
//  XingCai
//
//  Created by Bevis on 14-1-16.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KindOfLottery : NSObject

@property (nonatomic,copy) NSString *cnname;         //彩种中文名
@property (nonatomic,copy) NSString *curmid;         //开奖号码
@property (nonatomic,copy) NSString *nav;        //奖期
@property (nonatomic,copy) NSString *pid;   //

@property (nonatomic,copy)NSString *lotteryName;  //彩种名，ssc,rbssc
@property (nonatomic,copy)NSString *version;  //玩法版本
@property (nonatomic,copy)NSString *lotteryId;  //彩种id

@property (copy, nonatomic) NSString *currentJiangQi;
//@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) NSTimeInterval timeOffset;//服务器时间和本地时间偏差量   本地时间+timeOffset=服务器时间

@property (strong, nonatomic) NSTimer *countDownTimer;

@property (copy, nonatomic) NSString *timeString;

//可追号奖期
@property (strong, nonatomic) NSMutableArray *keZhuiHaoJiangQis;

@property (assign, nonatomic)BOOL latestJiangQi;  //是否为最新奖期
@property (assign, nonatomic)BOOL latestKeZhuiHaoJiangQi;  //是否为最新可追号奖期

@end
