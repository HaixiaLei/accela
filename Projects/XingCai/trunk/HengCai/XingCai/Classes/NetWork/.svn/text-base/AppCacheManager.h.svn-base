//
//  AppCacheManager.h
//  XingCai
//
//  Created by jay on 14-1-17.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const lotteryListKey = @"lotteryListKey";
static NSString * const menuAndRuleKey = @"menuAndRuleKey";

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
@end
