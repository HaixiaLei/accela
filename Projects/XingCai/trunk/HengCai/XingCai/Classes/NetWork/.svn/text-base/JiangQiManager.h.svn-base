//
//  JiangQiManager.h
//  XingCai
//
//  Created by jay on 14-3-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiangQiObject.h"

#define NotificationUpdateTime          @"NotificationUpdateTime"
#define NotificationUpdateJiangQi       @"NotificationUpdateJiangQi"

@interface JiangQiManager : NSObject

@property (assign,nonatomic) BOOL shouldShowNextJiangQiAlert;

+ (JiangQiManager *)sharedManager;

- (void)stopAllCountDownTimer;

//- (void)getJiangQiWithJiangQiObject:(JiangQiObject *)jiangQiObject lotteryId:(NSString *)lotteryId;

- (JiangQiObject *)getJiangQiObjectWithLotteryId:(NSString *)lotteryId;
- (NSString *)getCurrentJiangQiWithLotteryId:(NSString *)lotteryId;
- (NSArray *)getKeZhuiHaoJiangQisWithLotteryId:(NSString *)lotteryId;
- (NSString *)getTimeStringWithLotteryId:(NSString *)lotteryId;

- (void)updateAllJiangQi;
@end
