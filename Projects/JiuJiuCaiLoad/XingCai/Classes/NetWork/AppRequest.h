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
    
    APIMethodBankList,                  //26.系统充值银行信息接口
    APIMethodBankInfo,                  //27.用户充值页面信息接口
    APIMethodLoadConfirm,               //28.充值确认接口
    APIMethodProvinceList,              //29.获取系统可绑定银行卡以及省份信息接口
    APIMethodCityList,                  //30.获取城市信息接口
    
    APIMethodAddBankCard,               //31.添加银行信息接口
    APIMethodComfirmCard,               //32.确认添加银行信息接口
    APIMethodCheckCard,                 //33.验证最近添加的银行卡信息接口
    APIMethodHasBind,                   //34.判断用户是否需要输入最近绑定的卡号接口
    APIMethodHasWithdrawPwd,            //35.判断用户是否设置了提款密码接口
    APIMethodSetWithdrawPwd,            //36.设置资金密码接口
};

@interface AppRequest : NSMutableURLRequest
@property (nonatomic,assign)APIMethod method;
@end
