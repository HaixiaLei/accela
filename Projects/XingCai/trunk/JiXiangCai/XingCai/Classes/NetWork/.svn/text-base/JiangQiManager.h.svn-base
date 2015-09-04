//
//  JiangQiManager.h
//  XingCai
//
//  Created by jay on 14-3-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiangQiObject.h"

#define NotificationUpdateAllJiangQi    @"NotificationUpdateAllJiangQi"  //通知名_更新所有奖期

#define NotificationUpdateTime          @"NotificationUpdateTime"  //通知名_更新奖期时间
#define NotificationUpdateJiangQi       @"NotificationUpdateJiangQi"  //通知名_更新奖期

@interface JiangQiManager : NSObject

@property (assign,nonatomic) BOOL shouldShowNextJiangQiAlert;  //控制只有在选号页和投注页显示已进入下一期弹框

+ (JiangQiManager *)sharedManager;

/**
 *  刷新所有奖期
 */
- (void)updateAllJiangQi;

/**
 *  停止所有奖期倒计时
 */
- (void)stopAllCountDownTimer;
@end
