//
//  AppCacheManager.h
//  XingCai
//
//  Created by jay on 14-1-17.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayRulesObject.h"

#define AppCacheErrorLotteryListDomain            @"AppCacheErrorLotteryListDomain"
#define AppCacheErrorMenuAndRuleDomain            @"AppCacheErrorMenuAndRuleDomain"

@interface AppCacheManager : NSObject

+ (AppCacheManager *)sharedManager;

//- (BOOL)lotteryListExist;

//刷新彩种列表以及玩法菜单
- (void)updateLotteryListWithBlock:(void (^)())complete;

//获取彩种列表
- (NSArray *)getLotteryList;

/**根据彩种获取菜单和玩法*/
- (NSArray *)getMenuAndRuleWithKindOfLottery:(KindOfLottery *)kindOfLottery;

//获取玩法失败提示
- (NSString *)menuAndRuleErrorMsgWithKindOfLottery:(KindOfLottery *)kindOfLottery;

- (void)removeAllMenuAndRuleErrorMsg;

/**
 *  更新玩法数据
 *
 *  @param versionList     最新玩法版本
 *  @param completionBlock 完成回调块
 */
- (void)updatePlayRulesWithVersionList:(NSArray *)versionList completionBlock:(void (^)(NSError *error))completionBlock;

/**
 *  更新玩法数据，使用当前的version，必须在updatePlayRulesWithVersionList调用过后使用
 *
 *  @param completionBlock 完成回调块
 */
- (void)updatePlayRulesWithCompletionBlock:(void (^)(NSError *error))completionBlock;

/**
 *  获取玩法数据对象
 *
 *  @param kindOfLottery 彩种
 *
 *  @return 玩法数据对象
 */
- (PlayRulesObject *)getPlayRulesObjectWithKindOfLottery:(KindOfLottery *)kindOfLottery;
@end
