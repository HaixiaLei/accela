//
//  AppRequest.m
//  XingCai
//
//  Created by jay on 14-4-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AppRequest.h"

@implementation AppRequest

- (id)init
{
    if (self = [super init]) {
        self.method = APIMethodNone;
    }
    return self;
}

- (NSString *)methodName
{
    return [self stringFromAPIMethod:self.method];
}

- (NSString *)stringFromAPIMethod:(APIMethod)method {
    NSString *result = @"";
    switch(method) {
        case APIMethodLogin:
            result = @"2.1.1.登录";
            break;
        case APIMethodLogout:
            result = @"2.1.2.退出";
            break;
        case APIMethodHistoryOfTheWinningNumbers:
            result = @"2.1.3.历史中奖号码";
            break;
        case APIMethodBalance:
            result = @"2.1.4.获取账号余额";
            break;
        case APIMethodMessageList:
            result = @"2.1.5.站内信列表";
            break;
        case APIMethodMessageDetail:
            result = @"2.1.6.站内信内容接口";
            break;
        case APIMethodNoticeList:
            result = @"2.1.7.公告列表";
            break;
        case APIMethodNoticeDetail:
            result = @"2.1.8.公告内容接口";
            break;
        case APIMethodLotteryNumberList:
            result = @"2.1.9.开奖号码";
            break;
        case APIMethodTraceRecordList:
            result = @"2.1.10.追号记录";
            break;
        case APIMethodBetRecordList:
            result = @"2.1.11.投注记录";
            break;
        case APIMethodCancelBet:
            result = @"2.1.12.投注记录撤单";
            break;
        case APIMethodCancelTrace:
            result = @"2.1.13.追号记录撤单";
            break;
        case APIMethodBet:
            result = @"2.1.14.投注接口";
            break;
        case APIMethodTrace:
            result = @"2.1.15.投注追号接口";
            break;
        case APIMethodFindPassword:
            result = @"2.1.17.忘记密码后修改密码";
            break;
        case APIMethodActivity:
            result = @"2.1.18.活动宣传图接口";
            break;
        case APIMethodMessageAmount:
            result = @"2.1.19.站内信数量";
            break;
        case APIMethodBetDetail:
            result = @"2.1.20.投注详情页";
            break;
        case APIMethodTraceDetail:
            result = @"2.1.21.追号详情单";
            break;
        case APIMethodFeedback:
            result = @"2.1.22.意见反馈";
            break;
        case APIMethodChangePassword:
            result = @"2.1.23.修改登陆密码";
            break;
        case APIMethodPlayRules:
            result = @"2.1.24.玩法接口";
            break;
        case APIMethodCurrentIssue:
            result = @"2.1.25.当前奖期接口";
            break;
        case APIMethodTraceIssue:
            result = @"2.1.26.可追奖期接口";
            break;
        case APIMethodVersion:
            result = @"2.1.28.版本检测接口";
            break;
        case APIMethodUpdateMessage:
            result = @"2.1.29.更新未读站内信";
            break;
        default:
            break;
    }
    
    return result;
}

@end
