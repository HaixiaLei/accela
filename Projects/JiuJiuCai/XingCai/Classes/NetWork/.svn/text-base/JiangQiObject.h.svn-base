//
//  JiangQiObject.h
//  XingCai
//
//  Created by jay on 14-3-18.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiangQiObject : NSObject

@property (strong, nonatomic) KindOfLottery *kindOfLottery;
@property (strong, nonatomic) NSString *lotteryId;

@property (strong, nonatomic) NSString *currentJiangQi;
//@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) NSTimeInterval timeOffset;//服务器时间和本地时间偏差量   本地时间+timeOffset=服务器时间

@property (strong, nonatomic) NSTimer *countDownTimer;

@property (strong, nonatomic) NSString *timeString;

//可追号奖期
@property (strong, nonatomic) NSMutableArray *keZhuiHaoJiangQis;

@property (assign, nonatomic)BOOL latestJiangQi;
@property (assign, nonatomic)BOOL latestKeZhuiHaoJiangQi;

@end
