//
//  NewsHttpManager.m
//  News
//
//  Created by jay on 13-7-19.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "AppHttpManager.h"
@interface AppHttpManager()
{
    AFAppAPIClient *client;
}
@end

@implementation AppHttpManager

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        client = [[AFAppAPIClient alloc] init];
    }
    return self;
}

+ (AppHttpManager *)sharedManager {
    static AppHttpManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[AppHttpManager alloc] init];
    });
    
    return _sharedManager;
}

//2.1.1.	登陆
- (void)login_with_account:(NSString *)account password:(NSString *)password block:(void (^)(id JSON, NSError *error))block
{
//    [client login_with_account:account password:password block:block];
}

//2.1.2.	退出
- (void)logout_with_block:(void (^)(id JSON, NSError *error))block
{
    [client logout_with_block:block];
}

//2.1.3.	历史中奖号码
- (void)historyOfTheWinningNumbers_with_lotteryId:(NSString *)lotteryId block:(void (^)(id JSON, NSError *error))block
{
//    [client historyOfTheWinningNumbers_with_lotteryId:@"1" block:block];
}

//2.1.4.	获取账号余额
- (void)getBalance_with_block:(void (^)(id JSON, NSError *error))block
{
    [client getBalance_with_block:block];
}

//2.1.5.	站内信列表
- (void)getNoticeList_with_block:(void (^)(id JSON, NSError *error))block
{
    [client getNoticeList_with_block:block];
}

//修改密码接口
- (void)changePasswordWithAccount:(NSString *)account password:(NSString *)password newPassword:(NSString *)newPassword type:(ChangePasswordType)type Block:(void (^)(id JSON, NSError *error))block
{
    [client changePasswordWithAccount:account password:password newPassword:newPassword type:type Block:block];
}

//版本号接口
- (void)getVersionNumberWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getVersionNumberWithBlock:block];
}

//主页
- (void)getHomeWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getHomeWithBlock:block];
}

//开奖信息首页接口
- (void)getLotteryInfomationWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getLotteryInfomationWithBlock:block];
}

//开奖信息Sub接口
- (void)getLotteryInfomationListWithLotteryID:(NSString *)lotteryId issueNumber:(NSString *)issueNumber Block:(void (^)(id JSON, NSError *error))block
{
    [client getLotteryInfomationListWithLotteryID:lotteryId issueNumber:issueNumber Block:block];
}

//彩种信息列表接口
- (void)lotteryListWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client lotteryListWithBlock:block];
}

//二三级菜单以及玩法接口
- (void)menuAndRuleMethodWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block
{
    [client menuAndRuleMethodWithKind:kind Block:block];
}

//奖期接口
- (void)jiangQiWithNav:(NSString *)nav lotteryId:(NSString *)lotteryId Block:(void (^)(id JSON, NSError *error))block
{
    [client jiangQiWithNav:nav lotteryId:lotteryId Block:block];
}

//可追号奖期接口
- (void)keZhuiHaoJiangQiWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block
{
    [client keZhuiHaoJiangQiWithKind:kind Block:block];
}

//投注接口
- (void)touZhuWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums Block:(void (^)(id JSON, NSError *error))block
{
    [client touZhuWithKind:kind lotteryid:lotteryid lt_issue_start:lt_issue_start bettingInformations:bettingInformations lt_project_modes:lt_project_modes lt_total_money:lt_total_money lt_total_nums:lt_total_nums Block:block];
}

//投注追号接口
- (void)touZhuZhuiHaoWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums lt_trace_count_input:(NSString *)lt_trace_count_input lt_trace_diff:(NSString *)lt_trace_diff lt_trace_if:(NSString *)lt_trace_if lt_trace_margin:(NSString *)lt_trace_margin lt_trace_money:(NSString *)lt_trace_money lt_trace_stop:(NSString *)lt_trace_stop lt_trace_times_diff:(NSString *)lt_trace_times_diff lt_trace_times_margin:(NSString *)lt_trace_times_margin lt_trace_times_same:(NSString *)lt_trace_times_same keZhuiHaoJiangQis:(NSArray *)keZhuiHaoJiangQis Block:(void (^)(id JSON, NSError *error))block
{
    [client touZhuZhuiHaoWithKind:kind lotteryid:lotteryid lt_issue_start:lt_issue_start bettingInformations:bettingInformations lt_project_modes:lt_project_modes lt_total_money:lt_total_money lt_total_nums:lt_total_nums lt_trace_count_input:lt_trace_count_input lt_trace_diff:lt_trace_diff lt_trace_if:lt_trace_if lt_trace_margin:lt_trace_margin lt_trace_money:lt_trace_money lt_trace_stop:lt_trace_stop lt_trace_times_diff:lt_trace_times_diff lt_trace_times_margin:lt_trace_times_margin lt_trace_times_same:lt_trace_times_same keZhuiHaoJiangQis:keZhuiHaoJiangQis Block:block];
}

//玩法介绍接口
- (void)getPlayInfomationWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getPlayInfomationWithBlock:block];
}

//如何存款帮助接口
- (void)getHowToSavingWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getHowToSavingWithBlock:block];
}

//常见问题帮助接口
- (void)getAnswerWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getAnswerWithBlock:block];
}

//可用余额接口
- (void)getBalanceWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getBalanceWithBlock:block];
}

//消息列表接口
- (void)getMessageListWithPage:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    [client getMessageListWithPage:page Block:block];
}

//消息内容接口
- (void)getMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block
{
    [client getMessageContentWithMessageId:messageId Block:block];
}

//13.1、更新头像接口
- (void)updateAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block
{
    [client updateAvatarWithId:avatarId Block:block];
}

//13.1、获取头像接口
- (void)getAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block
{
    [client getAvatarWithId:avatarId Block:block];
}

//删除消息接口
- (void)deleteMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block
{
    [client deleteMessageContentWithMessageId:messageId Block:block];
}

//系统公告列表接口
- (void)getNoticeListWithBlock:(void (^)(id JSON, NSError *error))block
{
//    [client getNoticeListWithBlock:block];
    [client getNoticeList_with_block:block];
}

//系统公告内容接口
- (void)getNoticeContentWithNoticeId:(NSString *)noticeId Block:(void (^)(id JSON, NSError *error))block
{
    [client getNoticeContentWithNoticeId:noticeId Block:block];
}

//购彩查询接口
- (void)gouCaiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    [client gouCaiChaXunWithStartTime:startTime endTime:endTime Page:page Block:block];
}

//18.1、投注详情接口
- (void)betDetail_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block
{
    [client betDetail_WithProjectid:projectid Block:block];
}

//18.2、撤单接口
- (void)cancelOrder_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block
{
    [client cancelOrder_WithProjectid:projectid Block:block];
}

//19 追号查询接口
- (void)zhuiHaoChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    [client zhuiHaoChaXunWithStartTime:startTime endTime:endTime Page:page Block:block];
}

//19.1、追号明细查询接口
- (void)traceDetail_WithTaskId:(NSString *)taskId Block:(void (^)(id JSON, NSError *error))block
{
    [client traceDetail_WithTaskId:taskId Block:block];
}

//19.2、终止追号接口
- (void)cancelTrace_WithTaskId:(NSString *)taskId detailId:(NSString *)detailId Block:(void (^)(id JSON, NSError *error))block
{
    [client cancelTrace_WithTaskId:taskId detailId:detailId Block:block];
}

//充提查询接口
- (void)chongTiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    [client chongTiChaXunWithStartTime:startTime endTime:endTime Page:page Block:block];
}

//资金密码验证接口
- (void)ziJinMiMaYanZhengWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block
{
    [client ziJinMiMaYanZhengWithPassword:password Block:block];
}

//提款可用银行卡信息接口
- (void)tiKuangKeYongYinHangKaXinXiWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block
{
    [client tiKuangKeYongYinHangKaXinXiWithPassword:password Block:block];
}

//确认提款信息接口
- (void)queRenTiKuangXinXiWithCheck:(NSString *)check bankInfo:(NSString *)bankInfo money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block
{
    [client queRenTiKuangXinXiWithCheck:check bankInfo:bankInfo money:money Block:block];
}

//最终提款接口
- (void)zuiZhongTiKuangXinXiWithCheck:(NSString *)check cardId:(NSString *)cardId money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block
{
    [client zuiZhongTiKuangXinXiWithCheck:check cardId:cardId money:money Block:block];
}

//退出登录接口
- (void)logoutWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client logoutWithBlock:block];
}

//26.获取广告接口
- (void)getAdWithBlock:(void (^)(id JSON, NSError *error))block
{
    [client getAdWithBlock:block];
}

//22.查询购买记录接口(type  0-已购彩票  1-未开奖彩票 2-中奖彩票 (不传递为0))
- (void)getMyLotteryList_with_type:(NSString *)type projectId:(NSString *)projectId projectNumber:(NSString *)number block:(void (^)(id JSON, NSError *error))block
{
    [client getMyLotteryList_with_type:type projectId:projectId projectNumber:number block:block];
}
@end
