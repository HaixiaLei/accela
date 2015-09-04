//
//  AFNewsAPIClient.h
//  News
//
//  Created by jay on 13-7-19.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "AFNetworking.h"
#import "KindOfLottery.h"

//#define OnLine   //是否是online环境开关

#ifndef OnLine
//static NSString * const kAFAppAPIBaseURLString = @"http://luffydev.jxc666.org/mobileindex.php"; //临时环境，密码用rsa加密，用户名sywine 密码321qwe,资金密码qwe123
//static NSString * const kAFAppAPIBaseURLString = @"http://m.jxc666.org/mobileindex.php";  //开发环境
//static NSString * const kAFAppAPIBaseURLString = @"http://mobile.jxc666.org/mobileindex.php";   //v
static NSString * const kAFAppAPIBaseURLString = @"http://www.tq3k.com/mobileindex.php";    //灰度，pre
#endif

#define USER_STORE_SESSIONID            @"AppSessionId"
#define TimeoutInterval                 30

#define NotificationNameShouldLoginAgain        @"NotificationNameShouldLoginAgain"
#define NotificationNameShowLoginVC             @"NotificationNameShowLoginVC"

#define AppServerErrorDomain            @"AppServerErrorDomain"

typedef NS_ENUM(NSInteger,AppServerError)
{
    /**ok，请求顺利*/
    AppServerErrorNone              = 0,
    
    /**POST数据出错*/
    AppServerErrorPOSTWrong         = -999,
    
    /**由于您长时间未操作，请重新登录*/
    AppServerErrorLongTime          = -601,
    
    /**被后面登陆的用户挤下线*/
    AppServerErrorKick              = -602,
    
    /**频道已关闭或没有激活*/
    AppServerErrorUnActive          = -603,
    
    /**没有操作权限-4*/
    AppServerErrorNoPermission4     = -604,
    
    /**你所要访问的页面没有找到或者已删除*/
    AppServerErrorPageNotFound      = -605,
    
    /**个人信息错误或者连接超时，请重新登陆*/
    AppServerErrorPrivateWrong      = -606,
    
    /**用户组被禁用或者不存在，请与管理员联系*/
    AppServerErrorNoPermission      = -607,
    
    /**没有操作权限-9*/
    AppServerErrorNoPermission9     = -608,
    
    /**没有操作权限-8*/
    AppServerErrorNoPermission8     = -609,
    
    /**超过奖金限额*/
    AppServerErrorBlocked           = -1141,
    
    /**未设定提款密码*/
    AppServerErrorMoneyPasswordUnset= -860,
    
    /**没有彩种id，客户端没给参数*/
    AppServerErrorIssueEmpty1       = -820,
    
    /**未到销售时间，奖期为空*/
    AppServerErrorIssueEmpty2       = -821,
    
    /**奖期不足*/
    AppServerErrorIssueNotEnough    = -811,
    
    /**您未开通！请联系您的上级*/
    AppServerErrorUnOpen            = -808,
    
    /**服务器内部错误*/
    AppServerErrorServerInternal    = -500,
};

typedef NS_ENUM(NSInteger,AlertViewType){
    AlertViewTypeDefault,
    AlertViewTypeSuccess,
    AlertViewTypeBackButton,
    AlertViewTypeConfirm,
    AlertViewTypeChaseConfirm,
    AlertViewTypeErrorBlocked,
    AlertViewTypeErrorModeUnsame,
    AlertViewTypeErrorIssueEmpty,
    AlertViewTypeErrorIssueNotEnough,
    AlertViewTypeRemoveAll,
    AlertViewTypeBetNumberExist,        //相同投注号码
    AlertViewTypeMenuAndRuleError,
    AlertViewTypeVersionError,          //版本检查接口出错
    AlertViewTypeWithdraw,                //提现确认
    AlertViewTypeWithdrawSuccess,         //提现成功
    AlertViewTypeLogout,
   
    
    AlertViewTypeNewVersion,    //提示新版本
};

typedef NS_ENUM(NSInteger,ChangePasswordType){
    ChangePasswordTypeLogin     = 1,            //修改登录密码
    ChangePasswordTypeMoney     = 2,            //修改资金密码
    ChangePasswordTypeFind      = 3,            //找回登录密码
};

typedef NS_ENUM(NSInteger,ScreenType){
    ScreenType3p5         = 1,            //3.5inch
    ScreenType4p0         = 2,            //4inch
};

@interface AFAppAPIClient : NSObject

@property (nonatomic,strong) NSOperationQueue *requestQueue;

+ (AFAppAPIClient *)sharedClient;

//2.1.1.	登陆
- (void)login_with_account:(NSString *)account password:(NSString *)password logintype:(NSString *)logintype block:(void (^)(id JSON, NSError *error))block;

//2.1.2.	退出
- (void)logout_with_block:(void (^)(id JSON, NSError *error))block;

//2.1.3.	历史中奖号码
- (void)historyOfTheWinningNumbers_with_lotteryId:(NSString *)lotteryId type:(NSString *)type block:(void (^)(id JSON, NSError *error))block;

//2.1.4.	获取账号余额
- (void)getBalance_with_block:(void (^)(id JSON, NSError *error))block;

//2.1.5.	站内信列表
- (void)getMessageList_with_maxid:(NSString *)maxid count:(NSString *)count block:(void (^)(id JSON, NSError *error))block;

////2.1.6.	站内信内容接口
//- (void)getMessageDetail_with_noticeId:(NSString *)noticeId block:(void (^)(id JSON, NSError *error))block;

//2.1.7.	公告列表
- (void)getNoticeList_with_block:(void (^)(id JSON, NSError *error))block;

#pragma mark - 2.1.8.	公告内容NSURLRequest
- (NSURLRequest *)noticeDetailRequestWithURLString:(NSString *)urlString;

//2.1.9.	开奖号码
//- (void)getLotteryNumberList_with_block:(void (^)(id JSON, NSError *error))block;

//2.1.10.	追号记录
- (void)traceRecordList_with_lotteryid:(NSString *)lotteryid startTime:(NSString *)startTime endTime:(NSString *)endTime maxid:(NSString *)maxid count:(NSString *)count block:(void (^)(id JSON, NSError *error))block;

//2.1.11.	投注记录
- (void)betRecordList_with_lotteryid:(NSString *)lotteryid startTime:(NSString *)startTime endTime:(NSString *)endTime maxid:(NSString *)maxid count:(NSString *)count block:(void (^)(id JSON, NSError *error))block;

//2.1.12.	投注记录撤单
- (void)cancelBet_with_projectId:(NSString *)projectId block:(void (^)(id JSON, NSError *error))block;

//2.1.13.	追号记录撤单
- (void)cancelTrace_with_taskId:(NSString *)taskId detailId:(NSString *)detailId block:(void (^)(id JSON, NSError *error))block;

//2.1.14.	投注接口
- (void)bet_with_kind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums block:(void (^)(id JSON, NSError *error))block;

//2.1.15.	投注追号接口
- (void)trace_with_kind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums lt_trace_count_input:(NSString *)lt_trace_count_input lt_trace_diff:(NSString *)lt_trace_diff lt_trace_if:(NSString *)lt_trace_if lt_trace_margin:(NSString *)lt_trace_margin lt_trace_money:(NSString *)lt_trace_money lt_trace_stop:(NSString *)lt_trace_stop lt_trace_times_diff:(NSString *)lt_trace_times_diff lt_trace_times_margin:(NSString *)lt_trace_times_margin lt_trace_times_same:(NSString *)lt_trace_times_same keZhuiHaoJiangQis:(NSArray *)keZhuiHaoJiangQis Block:(void (^)(id JSON, NSError *error))block;

//2.1.17.	忘记密码后修改密码
- (void)findPassword_with_newPassword:(NSString *)newPassword block:(void (^)(id JSON, NSError *error))block;

//2.1.18.	活动宣传图接口
- (void)getActivityList_with_screenType:(ScreenType)screenType block:(void (^)(id JSON, NSError *error))block;

//2.1.19.	站内信数量
- (void)getMessageAmount_with_block:(void (^)(id JSON, NSError *error))block;

//2.1.20.	投注详情页
- (void)betDetail_with_projectid:(NSString *)projectid block:(void (^)(id JSON, NSError *error))block;

//2.1.21.	追号详情页
- (void)traceDetail_with_taskId:(NSString *)taskId block:(void (^)(id JSON, NSError *error))block;

//2.1.22.	意见反馈
- (void)feedback_with_content:(NSString *)content block:(void (^)(id JSON, NSError *error))block;

//2.1.23.	修改登陆密码
- (void)changePassword_with_oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword block:(void (^)(id JSON, NSError *error))block;

//2.1.24.	玩法接口
- (void)playRules_with_type:(NSString *)type block:(void (^)(id JSON, NSError *error))block;

//2.1.25.	当前奖期接口
- (void)currentIssue_with_nav:(NSString *)nav lotteryid:(NSString *)lotteryid block:(void (^)(id JSON, NSError *error))block;

//2.1.26.	可追奖期接口
- (void)traceIssue_with_nav:(NSString *)nav block:(void (^)(id JSON, NSError *error))block;

//2.1.27.	新手帮助接口
- (NSURLRequest *)userHelpRequest;

//2.1.28.	版本检测接口
- (void)version_with_block:(void (^)(id JSON, NSError *error))block;

//2.1.29.	更新未读站内信
- (void)updateMessage_with_msgid:(NSString *)msgid block:(void (^)(id JSON, NSError *error))block;

//修改密码接口
- (void)changePasswordWithAccount:(NSString *)account password:(NSString *)password newPassword:(NSString *)newPassword type:(ChangePasswordType)type Block:(void (^)(id JSON, NSError *error))block;

//版本号接口
- (void)getVersionNumberWithBlock:(void (^)(id JSON, NSError *error))block;

//主页
- (void)getHomeWithBlock:(void (^)(id JSON, NSError *error))block;

//开奖信息首页接口
- (void)getLotteryInfomationWithBlock:(void (^)(id JSON, NSError *error))block;

//开奖信息Sub接口
- (void)getLotteryInfomationListWithLotteryID:(NSString *)lotteryId issueNumber:(NSString *)issueNumber Block:(void (^)(id JSON, NSError *error))block;

//彩种信息列表接口
- (void)lotteryListWithBlock:(void (^)(id JSON, NSError *error))block;

//二三级菜单以及玩法接口
- (void)menuAndRuleMethodWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block;

//奖期接口
- (void)jiangQiWithNav:(NSString *)nav lotteryId:(NSString *)lotteryId Block:(void (^)(id JSON, NSError *error))block;

//可追号奖期接口
- (void)keZhuiHaoJiangQiWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block;

//投注接口
- (void)touZhuWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums Block:(void (^)(id JSON, NSError *error))block;

//投注追号接口
- (void)touZhuZhuiHaoWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums lt_trace_count_input:(NSString *)lt_trace_count_input lt_trace_diff:(NSString *)lt_trace_diff lt_trace_if:(NSString *)lt_trace_if lt_trace_margin:(NSString *)lt_trace_margin lt_trace_money:(NSString *)lt_trace_money lt_trace_stop:(NSString *)lt_trace_stop lt_trace_times_diff:(NSString *)lt_trace_times_diff lt_trace_times_margin:(NSString *)lt_trace_times_margin lt_trace_times_same:(NSString *)lt_trace_times_same keZhuiHaoJiangQis:(NSArray *)keZhuiHaoJiangQis Block:(void (^)(id JSON, NSError *error))block;

//玩法介绍接口
- (void)getPlayInfomationWithBlock:(void (^)(id JSON, NSError *error))block;

//如何存款帮助接口
- (void)getHowToSavingWithBlock:(void (^)(id JSON, NSError *error))block;

//常见问题帮助接口
- (void)getAnswerWithBlock:(void (^)(id JSON, NSError *error))block;

//可用余额接口
- (void)getBalanceWithBlock:(void (^)(id JSON, NSError *error))block;

//消息列表接口
- (void)getMessageListWithPage:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

//13.1、更新头像接口
- (void)updateAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block;

//13.1、获取头像接口
- (void)getAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block;

//消息内容接口
- (void)getMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block;

//删除消息接口
- (void)deleteMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block;

//网站公告列表接口
- (void)getNoticeListWithBlock:(void (^)(id JSON, NSError *error))block;

//网站公告内容接口
- (void)getNoticeContentWithNoticeId:(NSString *)noticeId Block:(void (^)(id JSON, NSError *error))block;

//购彩查询接口
- (void)gouCaiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

//18.1、投注详情接口
- (void)betDetail_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block;

//18.2、撤单接口
- (void)cancelOrder_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block;

//19 追号查询接口
- (void)zhuiHaoChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

//19.1、追号明细查询接口
- (void)traceDetail_WithTaskId:(NSString *)taskId Block:(void (^)(id JSON, NSError *error))block;

//19.2、终止追号接口
- (void)cancelTrace_WithTaskId:(NSString *)taskId detailId:(NSString *)detailId Block:(void (^)(id JSON, NSError *error))block;

//充提查询接口
- (void)chongTiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

//资金密码验证接口
- (void)ziJinMiMaYanZhengWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block;

//提款可用银行卡信息接口
- (void)tiKuangKeYongYinHangKaXinXiWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block;

//确认提款信息接口
- (void)queRenTiKuangXinXiWithCheck:(NSString *)check bankInfo:(NSString *)bankInfo money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block;

//最终提款接口
- (void)zuiZhongTiKuangXinXiWithCheck:(NSString *)check cardId:(NSString *)cardId money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block;

//退出登录接口
- (void)logoutWithBlock:(void (^)(id JSON, NSError *error))block;

//26.获取广告接口
- (void)getAdWithBlock:(void (^)(id JSON, NSError *error))block;

//22.查询购买记录接口(type  0-已购彩票  1-未开奖彩票 2-中奖彩票 (不传递为0))
- (void)getMyLotteryList_with_type:(NSString *)type projectId:(NSString *)projectId projectNumber:(NSString *)number block:(void (^)(id JSON, NSError *error))block;

@end
