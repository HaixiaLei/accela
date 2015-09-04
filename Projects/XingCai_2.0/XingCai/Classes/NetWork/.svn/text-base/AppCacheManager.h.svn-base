//
//  AppCacheManager.h
//  XingCai
//
//  Created by jay on 14-1-17.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppCacheManagerErrorDomain            @"AppCacheManagerErrorDomain"

@interface AppCacheManager : NSObject

+ (AppCacheManager *)sharedManager;

/**
 *  刷新彩种列表以及玩法菜单
 *
 *  @param complete 
 */
- (void)updateLotteryListWithBlock:(void (^)())complete;

/**
 *  获取彩种列表
 *
 *  @return 彩种列表
 */
- (NSArray *)getLotteryList;

/**
 *  根据彩种获取菜单和玩法
 *
 *  @param kindOfLottery 彩种
 *
 *  @return 玩法
 */
- (NSArray *)getMenuAndRuleWithKindOfLottery:(KindOfLottery *)kindOfLottery;

/**
 *  获取玩法失败提示
 *
 *  @param kindOfLottery 彩种
 *
 *  @return 错误信息
 */
- (NSString *)menuAndRuleErrorMsgWithKindOfLottery:(KindOfLottery *)kindOfLottery;

/**
 *  移除所有错误信息
 */
- (void)removeAllMenuAndRuleErrorMsg;

@end
