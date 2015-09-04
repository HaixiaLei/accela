//
//  JiangQiManager.h
//  XingCai
//
//  Created by jay on 14-3-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiangQiObject.h"

#define NotificationUpdateTime          @"NotificationUpdateTime"  //通知名_更新奖期时间
#define NotificationUpdateJiangQi       @"NotificationUpdateJiangQi"  //通知名_更新奖期

#define NotificationJiangQiUpdateFinished @"NotificationJiangQiUpdateFinished"  //通知名_奖期刷新完成

@interface JiangQiManager : NSObject

@property (assign,nonatomic) BOOL shouldShowNextJiangQiAlert;
@property (nonatomic, strong) KindOfLottery *kindOfLottery; //当前用户看到的界面彩种

+ (JiangQiManager *)sharedManager;

//- (JiangQiObject *)getJiangQiObjectWithLotteryId:(NSString *)lotteryId;
//- (NSString *)getCurrentJiangQiWithLotteryId:(NSString *)lotteryId;
//- (NSArray *)getKeZhuiHaoJiangQisWithLotteryId:(NSString *)lotteryId;
//- (NSString *)getTimeStringWithLotteryId:(NSString *)lotteryId;

/**
 *  刷新所有奖期
 */
- (void)updateAllJiangQi;

/**
 *  停止所有奖期倒计时
 */
- (void)stopAllCountDownTimer;

/**
 *  更新某个彩种的奖期
 *
 *  @param kindOfLottery 彩种
 */
- (void)updateJiangQiWithKindOfLottery:(KindOfLottery *)kindOfLottery;

@end
