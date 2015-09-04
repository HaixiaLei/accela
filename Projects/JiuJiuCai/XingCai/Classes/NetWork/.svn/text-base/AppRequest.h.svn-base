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
    APIMethodUpdateAvatar,              //更新头像
    APIMethodGetAvatar,                 //获取头像
    APIMethodMessageContent,
    APIMethodDeleteMessageContent,
    APIMethodNoticeList,
    APIMethodNoticeContent,
    APIMethodGouCaiChaXun,
    APIMethodZhuiHaoMingXiChaXun,       //追号明细查询
    APIMethodZhongZhiZhuiHao,           //终止追号
    APIMethodTouZhuXiangQing,           //投注详情
    APIMethodCheDan,                    //撤单
    APIMethodZhuiHaoChaXun,
    APIMethodChongTiChaXun,
    APIMethodZiJinMiMaYanZheng,
    APIMethodTiKuangKeYongYinHangKaXinXi,
    APIMethodQueRenTiKuangXinXi,
    APIMethodZuiZhongTiKuangXinXi,
    APIMethodLogout,
    APIMethodGetAd,                     //获取广告
    APIMethodGetAdDetail,               //获取广告详情
};

@interface AppRequest : NSMutableURLRequest
@property (nonatomic,assign)APIMethod method;
@end
