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
    APIMethodLogin, //2.1.1.    登录
    APIMethodLogout, //2.1.2.	退出
    APIMethodHistoryOfTheWinningNumbers, //2.1.3.	历史中奖号码
    APIMethodBalance, //2.1.4.	获取账号余额
    APIMethodMessageList, //2.1.5.	站内信列表
    APIMethodMessageDetail, //2.1.6.	站内信内容接口
    APIMethodNoticeList, //2.1.7.	公告列表
    APIMethodNoticeDetail, //2.1.8.	公告内容接口
    APIMethodLotteryNumberList, //2.1.9.	开奖号码
    APIMethodTraceRecordList, //2.1.10.	追号记录
    APIMethodBetRecordList, //2.1.11.	投注记录
    APIMethodCancelBet, //2.1.12.	投注记录撤单
    APIMethodCancelTrace, //2.1.13.	追号记录撤单
    APIMethodBet, //2.1.14.	投注接口
    APIMethodTrace, //2.1.15.	投注追号接口
    APIMethodFindPassword, //2.1.17.	忘记密码后修改密码
    APIMethodActivity, //2.1.18.	活动宣传图接口
    APIMethodMessageAmount, //2.1.19.	站内信数量
    APIMethodBetDetail, //2.1.20.	投注详情页
    APIMethodTraceDetail, //2.1.21.	追号详情单
    APIMethodFeedback, //2.1.22.	意见反馈
    APIMethodChangePassword, //2.1.23.	修改登陆密码
    APIMethodPlayRules, //2.1.24.	玩法接口
    APIMethodCurrentIssue, //2.1.25.	当前奖期接口
    APIMethodTraceIssue, //2.1.26.	可追奖期接口
    APIMethodVersion, //2.1.28.	版本检测接口
    APIMethodUpdateMessage,//2.1.29.	更新未读站内信
    
    APIMethodVersionNumber,
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
    APIMethodDeleteMessageContent,
    
    
    APIMethodGouCaiChaXun,
    APIMethodZhuiHaoChaXun,
    APIMethodChongTiChaXun,
    APIMethodZiJinMiMaYanZheng,
    APIMethodTiKuangKeYongYinHangKaXinXi,
    APIMethodQueRenTiKuangXinXi,
    APIMethodZuiZhongTiKuangXinXi,
    
    APIMethodMyLottery,                     //我的彩票列表
};

@interface AppRequest : NSMutableURLRequest
@property (nonatomic,assign)APIMethod method;
@property (nonatomic,strong)NSDictionary *parameters;

- (NSString *)methodName;
@end
