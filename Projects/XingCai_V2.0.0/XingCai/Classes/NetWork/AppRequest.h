//
//  AppRequest.h
//  XingCai
//
//  Created by jay on 14-4-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,APIMethod){
    APIMethodNone,
    APIMethodChangePassword,
    APIMethodVersionNumber,
    APIMethodLogin,
    APIMethodHome,
    APIMethodLotteryInfomationList,
    APIMethodLotteryInfomationDetail,
    APIMethodLotteryList,
    APIMethodMenuAndRule,
    APIMethodJiangQi,
    APIMethodKeZhuiHaoJiangQi,
    APIMethodTouZhu,
    APIMethodTouZhuZhuiHao,
    APIMethodPlayInfomation,
    APIMethodHowToSaving,
    APIMethodAnswer,
    APIMethodBalance,
    APIMethodMessageList,
    APIMethodMessageContent,
    APIMethodDeleteMessageContent,
    APIMethodNoticeList,
    APIMethodNoticeContent,
    APIMethodGouCaiChaXun,
    APIMethodZhuiHaoChaXun,
    APIMethodChongTiChaXun,
    APIMethodZiJinMiMaYanZheng,
    APIMethodTiKuangKeYongYinHangKaXinXi,
    APIMethodQueRenTiKuangXinXi,
    APIMethodZuiZhongTiKuangXinXi,
    APIMethodLogout,
};

@interface AppRequest : NSMutableURLRequest
@property (nonatomic,assign)APIMethod method;
@end
