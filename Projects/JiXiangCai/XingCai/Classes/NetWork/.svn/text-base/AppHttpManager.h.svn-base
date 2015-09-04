//
//  NewsHttpManager.h
//  News
//
//  Created by jay on 13-7-19.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAppAPIClient.h"

@class KindOfLottery;
@interface AppHttpManager : NSObject

+ (AppHttpManager *)sharedManager;


//2.1.1.	登陆
- (void)login_with_account:(NSString *)account password:(NSString *)password block:(void (^)(id JSON, NSError *error))block;

//2.1.2.	退出
- (void)logout_with_block:(void (^)(id JSON, NSError *error))block;

//2.1.3.	历史中奖号码
- (void)historyOfTheWinningNumbers_with_lotteryId:(NSString *)lotteryId block:(void (^)(id JSON, NSError *error))block;

//2.1.4.	获取账号余额
- (void)getBalance_with_block:(void (^)(id JSON, NSError *error))block;

//2.1.5.	站内信列表
- (void)getNoticeList_with_block:(void (^)(id JSON, NSError *error))block;

/**
 *  修改密码接口
 *
 *  @param account     用户名
 *  @param password    旧密码
 *  @param newPassword 新密码
 *  @param type        类型：1 修改登录密码，2修改资金密码
 *  @param block       block
 */
- (void)changePasswordWithAccount:(NSString *)account password:(NSString *)password newPassword:(NSString *)newPassword type:(ChangePasswordType)type Block:(void (^)(id JSON, NSError *error))block;

/**版本号接口*/
/*
 返回：
 {"msg":"1.0.2"}
 
 返回说明：
 msg：版本号
*/
- (void)getVersionNumberWithBlock:(void (^)(id JSON, NSError *error))block;

/**主页接口*/
/*
 返回说明：
 issueNumbers——开奖号码信息
 issueNumbers:数字－彩种ID
 code开奖号码
 issue奖期
 statuscode=2表示已验证(废弃)。
 
 响应码：
 404未找到开通的彩种信息
*/
- (void)getHomeWithBlock:(void (^)(id JSON, NSError *error))block;

/**开奖信息首页接口*/
/*
 返回说明：
 issueNumbers——开奖号码信息
 issueNumbers:数字－彩种ID
 code开奖号码
 issue奖期
 statuscode=2表示已验证(废弃)。
 
 响应码：
 404未找到开通的彩种信息
 */
- (void)getLotteryInfomationWithBlock:(void (^)(id JSON, NSError *error))block;

/**开奖信息Sub接口*/
/*
 参数说明：
 lotteryId —— 彩种ID
 issueNumber —— 奖期
 
 返回说明：
 issueList —— 开奖号码列表，
 code  开奖号码
 issue  奖期
 statuscode表示已验证(废弃)。
 
 响应码：
 404彩种ID为空
 405该彩种近期开通
 406找不到该彩种的开奖信息
 403找不到该彩种的相关信息
 */
- (void)getLotteryInfomationListWithLotteryID:(NSString *)lotteryId issueNumber:(NSString *)issueNumber Block:(void (^)(id JSON, NSError *error))block;

/**彩种信息列表接口*/
/*
 返回说明：
 cnname —— 彩种中文名
 nav  彩种代码
 curmid  菜单ID（兼容原平台）
 pid 父菜单ID（兼容原平台）
 
 响应码：
 998 用户未登陆
 */
- (void)lotteryListWithBlock:(void (^)(id JSON, NSError *error))block;

/**二三级菜单以及玩法接口*/
/*
 响应码：
 998 用户未登陆
 802 操作错误
 803 数据错误lotteryid
 804 该彩种近期开通,敬请期
 805 没有权限001
 806 未到销售时间
 807 时时乐官方彩种调整，敬请留意公告！
 808 您未开通！请联系您的上级
 809 数据错误1:没有可用玩法组
 810 没有权限003
 811 奖期不足
 */
- (void)menuAndRuleMethodWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block;

/**奖期接口*/
/*
 参数：
 GET参数：参考：4.彩种玩法接口
 nav=ssc
 sess={session id}
 
 POST参数：
 {
 "lotteryid":1,
 "flag":"read"
 }
 参数说明：
 Lotteryid 彩种id
 Flag 固定标志
 返回：
 {
 "issue":"20140210-060",
 "nowtime":"2014-02-10 15:52:03",
 "saleend":"2014-02-10 15:59:05"
 }
 返回说明：
 issue—— 当前奖期
 nowtime当前时间
 saleend 销售截止时间
 
 响应码：
 820 empty
 821 empty
 */
- (void)jiangQiWithNav:(NSString *)nav lotteryId:(NSString *)lotteryId Block:(void (^)(id JSON, NSError *error))block;

/**可追号奖期接口*/
/*
 参数：
 GET参数：参考：4.彩种玩法接口
 nav=ssc
 sess={session id}
 task=issue 固定标志 表示读取可追号的奖期
 
 POST参数：
 无
 参数说明：
 task=issue 固定标志 表示读取可追号的奖期
 
 返回说明：
 二天内可追的奖期、及奖期截止销售时间
 
 响应码：
 无
 */
- (void)keZhuiHaoJiangQiWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block;

/**投注接口*/
/*

 */

- (void)touZhuWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums Block:(void (^)(id JSON, NSError *error))block;

/**投注追号接口*/
/*
 参数的意思
 "lt_trace_count_input":追号总期数
 "lt_trace_diff":隔期数,
 "lt_trace_if":是否发起追号（重要）,yes or null
 "lt_trace_issues":追号期数数组,
 "lt_trace_margin":最低收益率(百分数0-100)
 "lt_trace_money":追号总金额,
 "lt_trace_stop":中奖后是否停止追号 yes or null
 "lt_trace_times_{奖期}":倍率,
 "lt_trace_times_diff":追号翻倍倍率,
 "lt_trace_times_margin":起始倍数(利润率追号)
 "lt_trace_times_same":起始倍数(同倍追号)
 */
- (void)touZhuZhuiHaoWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums lt_trace_count_input:(NSString *)lt_trace_count_input lt_trace_diff:(NSString *)lt_trace_diff lt_trace_if:(NSString *)lt_trace_if lt_trace_margin:(NSString *)lt_trace_margin lt_trace_money:(NSString *)lt_trace_money lt_trace_stop:(NSString *)lt_trace_stop lt_trace_times_diff:(NSString *)lt_trace_times_diff lt_trace_times_margin:(NSString *)lt_trace_times_margin lt_trace_times_same:(NSString *)lt_trace_times_same keZhuiHaoJiangQis:(NSArray *)keZhuiHaoJiangQis Block:(void (^)(id JSON, NSError *error))block;

/**玩法介绍接口*/
/*
 
 */
- (void)getPlayInfomationWithBlock:(void (^)(id JSON, NSError *error))block;

/**如何存款帮助接口*/
/*
 
 */
- (void)getHowToSavingWithBlock:(void (^)(id JSON, NSError *error))block;

/**常见问题帮助接口*/
/*
 
 */
- (void)getAnswerWithBlock:(void (^)(id JSON, NSError *error))block;

/**可用余额接口*/
/*
 参数：
 GET参数：
 Sess session id
 
 POST参数：
 {
 “flag”:”getmoney”
 }
 
 参数说明：
 Flag 固定标志
 
 返回：
 
 返回说明：
 可用余额字符串
 
 响应码：
 830操作失败
 831读取失败
 */
- (void)getBalanceWithBlock:(void (^)(id JSON, NSError *error))block;

/**消息列表接口*/
/*
 参数：
 GET参数：
 Sess session id
 P 页数 无默认读取第一页
 
 返回说明：
 Result 消息数组
 Entry 消息id
 Subject 主题
 Title   目前无用
 Isview  是否已读 0未读 1已读
 Sendtime 消息发送时间
 
 Pageinfo 分页信息
 CurrentPage 当前页
 TotalCounts 总页数
 */
- (void)getMessageListWithPage:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

//13.1、更新头像接口
/*
 请求地址: feed/index.php? controller=user&action=headportrait&sess={session id}& flag_head_portrait={flag}& mark_head_portrait={mark}
 参数：
 GET参数
 Sess sessionid
 flag_head_portrait  当他为update的时候，则是更新操作，其他则是读取
 mark_head_portrait  头像标识ID ，则flag_head_portrait为update的时候，则把这个值更新上去
 
 POST参数（无）
 返回说明
 {
 "user":"1",
 "user_head_portrait":"xxxxxxx",
 }
 
 返回说明
 userid 用户ID
 user_head_portrait 头像标识
 */
- (void)updateAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block;

//13.1、获取头像接口
/*
 说明同更新头像接口
 */
- (void)getAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block;

/**消息内容接口*/
/*
 参数：
 GET参数：
 Sess session id
 tag=viewdetail固定标志
 msgid消息id 参见13消息列表接口中的Entry参数
 
 返回说明：
 Entry    消息id
 Subject  主题
 Content  消息内容
 Title     消息主题（目前无用）
 Sendtime 消息发送时间
 */
- (void)getMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block;

/**删除消息接口*/
/*
 参数：
 GET参数：
 Sess session id
 tag=deleteone固定标志
 msgid消息id 参见13消息列表接口中的Entry参数
 */
- (void)deleteMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block;

/**网站公告列表接口*/
/*
返回说明：
Id 公告id
Subject 公告主题
Sendday 发布时间
 */
- (void)getNoticeListWithBlock:(void (^)(id JSON, NSError *error))block;

/**网站公告内容接口*/
/*
 GET参数：
 Sess session id
 Nid 公告id
 */
- (void)getNoticeContentWithNoticeId:(NSString *)noticeId Block:(void (^)(id JSON, NSError *error))block;

/**购彩查询接口*/
/*
 参数说明：
 "starttime":开始时间(精确到秒)
 "endtime":结束时间(精确到秒)
 "page":查询的页数
 其它参数采用上例中的默认值
 
 返回说明：
 Lottery 彩种信息，用于与aProject中的lotteryid对应以显示中文
 aProject购彩信息
 projectid 记录id
 writetime 投注时间
 username 用户
 lotteryid 彩种id
 issue    投注期号
 code    投注内容
 totalprice 投注金额
 bonus    奖金
 nocode   开奖号码
 iscancel  订单状态 0受理  1本人撤单  2平台撤单  3错开撤单
 isgetprize 是否开奖 0未开奖  2未中奖
 prizestatus 中奖后的状态 0未派奖 其它表已派奖
 
 pageinfo 分页信息
 CurrentPage当前面
 TotalCounts 总记录数
 TotalPages  总页数
 
 
 其它参数暂忽略
 
 响应码：
 无
 */
- (void)gouCaiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

//18.1、投注详情接口
/*
 请求地址:feed/index.php?controller=gameinfo&action=task&sess={session id}&id={projectid}
 参数：
 GET参数
 sess session id
 id projected 方案ID
 POST参数
 无
 
 返回值
 {
 "projectid":" ",
 "userid":"1",
 "packageid":"35939985",
 "taskid":"0",
 "lotteryid":"14",
 "methodid":"2370",
 "issue":"20140306-237",
 "bonus":"0.0000",
 "code":"56789,01234,56789",
 "codetype":"digital",
 "singleprice":"250.0000",
 "multiple":"1",
 "totalprice":"250.0000",
 "lvtopid":"1",
 "lvtoppoint":"0.075",
 "lvproxyid":"0",
 "writetime":"2014-03-06 19:41:09",
 "updatetime":"2014-03-07 11:27:55",
 "deducttime":"2014-03-07 11:27:55",
 "bonustime":"0000-00-00 00:00:00",
 "canceltime":"0000-00-00 00:00:00",
 "isdeduct":"1",
 "iscancel":"0",
 "isgetprize":"2",
 "prizestatus":"0",
 "userip":"8.8.8.8",
 "cdnip":"192.168.10.113",
 "modes":"\u5143",
 "sqlnum":"1",
 "hashvar":"14fb6b60d4c5e8d2c9a1baa8dd85e959",
 "omodel":"2",
 "isalert":"0",
 "cnname":"\u5370\u5c3c\u4e94\u5206\u5f69",
 "lotterytype":"0",
 "methodname":"\u540e\u4e09\u76f4\u9009",
 "functionname":"ssc_h3zhixuan",
 "nocount":"a:3:{i:1;a:3:{s:5:\"count\";s:1:\"1\";s:4:\"name\";s:91:\"\u4e00\u7b49\u5956:\u6240\u9009\u53f7\u7801\u4e0e\u5f00\u5956\u53f7\u7801\u7684\u767e\u3001\u5341\u3001\u4e2a\u4f4d\u6570\u5b57\u5168\u90e8\u76f8\u540c\u4e14\u987a\u5e8f\u4e00\u81f4\";s:3:\"use\";i:1;}s:4:\"type\";i:0;s:6:\"isdesc\";i:0;}","
 username":"sunlee",
 "nocode":"",
 "canneldeadline":null,
 "statuscode":null
 }
 返回说明
 projected 方案ID
 userid 用户ID
 packageid 订单ID
 tasked 追号ID
 lotteryid 彩种ID
 methodid 玩法ID
 issue 奖期
 bonus 奖金
 code 号码
 codetype 投注方式
 singleprice 单倍价格
 multiple 倍数
 totalprice 总价
 lvtopid 总代ID
 lvtoppoint 总代返点
 lvproxyid 一代ID
 writetime 写入时间
 updatetime 更新时间
 deducttime 真实扣款时间
 bonustime 中奖时间
 canceltime 取消时间
 isdeduct  是否真实扣款(0:未真实扣款的;1:真实扣款)
 iscancel 收否撤单(未撤单;1:;2:)
 isgetprize 中奖判断(0:未判断;1:中奖;2:未知)
 prizestatus 派奖状态(0:未派奖;1:已派奖)
 userip 用户真实IP
 cdnip 服务器IP
 modes 模式
 sqlnum 一个方案执行封锁表相关的SQL数目
 hashvar":"14fb6b60d4c5e8d2c9a1baa8dd85e959",
 omodel":"2",
 isalert":"0",
 cnname 彩种名称
 methodname 玩法名称
 functionname 中奖函数
 username 用户名
 */
- (void)betDetail_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block;

//18.2、撤单接口
/*
 请求地址: feed/index.php?controller=gameinfo&action=cancelgame&sess={session id}&id=projected
 参数：
 GET参数
 sess sessionid
 id projected 方案ID
 POST 参数
 无
 返回：
 {
 "msg": "操作成功"
 }
 */
- (void)cancelOrder_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block;

/**追号查询接口*/
/*
 Taskid  追号id
 Username 用户名
 Begintime 追号时间
 Cnname 彩种
 Beginissue 开始期数
 Codes 追号内容
 Taskprice 追号总金额
 Finishprice 完成金额
 Cancelprice 取消金额
 Stoponwin 中奖后终止 1是  其它否
 Status 追号状态 0进行中  1已取消  2已完成
 
 pageinfo 分页信息
 CurrentPage当前面
 TotalCounts 总记录数
 TotalPages  总页数
 
 
 其它参数暂忽略
 
 响应码：
 无
 */
- (void)zhuiHaoChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

//19.1、追号明细查询接口
/*
 请求地址: feed/index.php?controller=gameinfo&action=taskdetail&sess={session id}&id={taskId}
 
 GET参数：
 sess={session id}
 id={taskid} 追号流水号
 
 POST参数：
 无
 
 返回值
 {
 "taskid":"T20140226-028VJBKLMNOPQ",
 "userid":"1",
 "lotteryid":"1",
 "methodid":"5",
 "packageid":"35939771",
 "title":"\u524d\u4e09\u76f4\u9009_\u76f4\u9009 \u8ffd\u53f75\u671f",
 "codes":"7,5,6",
 "codetype":"digital",
 "issuecount":"5",
 "finishedcount":"1",
 "cancelcount":"0",
 "singleprice":"2.0000",
 "taskprice":"10.0000",
 "finishprice":"2.0000",
 "cancelprice":"0.0000",
 "begintime":"2014-02-26 10:29:51",
 "beginissue":"20140226-028",
 "wincount":"0",
 "updatetime":"2014-02-26 10:29:51",
 "prize":"a:1:{s:4:\"base\";a:1:{i:0;a:5:{s:9:\"projectid\";i:0;s:5:\"level\";i:1;s:9:\"codetimes\";i:1;s:5:\"prize\";i:1950;s:10:\"expandcode\";s:5:\"7|5|6\";}}}",
 "userdiffpoints":"a:1:{s:4:\"base\";a:0:{}}",
 "lvtopid":"1",
 "lvtoppoint":"0.075",
 "lvproxyid":"0",
 "status":"0",
 "stoponwin":"1",
 "userip":"8.8.8.8",
 "cdnip":"192.168.80.20",
 "modes":"\u5143",
 "omodel":"2",
 "cnname":"\u91cd\u5e86\u65f6\u65f6\u5f69",
 "methodname":"\u540e\u4e09\u76f4\u9009",
 "username":"sunlee"
 }
 
 返回说明
 
 tasked 追号ID
 userid 用户ID
 lotteryid 彩种ID
 methodid 玩法ID
 packageid 订单ID
 title 追号任务标题
 codes 购买号码
 codetype 投注方式
 issuecount 追号总期数
 finishedcount 已完成期数
 cancelcount 取消期数
 singleprice 每期单倍价格
 taskprice 追号总金额
 finishprice 完成总金额
 cancelprice 取消总金额
 begintime 开始时间
 beginissue 开始期数
 wincount 赢的期数
 updatetime 更新时间
 prize 下单时候的奖金记录(单倍奖金)序列化[号码扩展表数据]
 userdiffpoints 用户返点(序列化)[返点差表数据]
 lvtopid 总代ID
 lvtoppoint 总代返点
 lvproxyid 一代ID
 status 追号状态(0:进行中;1:取消;2:已完成)
 stoponwin 追中即停(1:追中即停)
 userip 用户IP
 cdnip 服务器IP
 modes 模式
 omodel 无返点奖金模式
 cnname 彩种名称
 methodname 玩法名称
 username 用户名
 */
- (void)traceDetail_WithTaskId:(NSString *)taskId Block:(void (^)(id JSON, NSError *error))block;


//19.2、终止追号接口
/*
 请求地址：feed/index.php? controller=report&action= canceltask&sess={session id}&id={taskid}
 参数：
 GET参数：
 sess sessionid 会话ID
 id 追号ID
 POST参数
 无
 
 返回：
 {
 "msg": "操作成功"
 }
 返回说明：
 无
 */
- (void)cancelTrace_WithTaskId:(NSString *)taskId detailId:(NSString *)detailId Block:(void (^)(id JSON, NSError *error))block;

/**充提查询接口*/
/*
 参数：
 GET参数：
 Sess session id
 
 POST参数
 {
 "ordertype":0,
 "ordertime_min":"2014-03-07 02:20:00",
 "ordertime_max":"2014-03-08 02:20:00",
 "username":null,
 "page":1
 }
 
 参数说明：
 " ordertime_min ":开始时间(精确到秒)
 " ordertime_max ":结束时间(精确到秒)
 "page":查询的页数
 其它参数采用上例中的默认值
 
 返回说明：
 orderno   帐变编号
 username  用户名
 times  时间
 cntitle  类型
 operations  收入
 operations  支出
 availablebalance  余额
 transferstatus  状态 1失败  3失败  其它成功
 allowdec  备注
 
 pageinfo 分页信息
 CurrentPage当前面
 TotalCounts 总记录数
 TotalPages  总页数
 
 
 其它参数暂忽略
 
 响应码：
 无
 */
- (void)chongTiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block;

/**资金密码验证接口*/
/*
 返回：
 {"check":883}
 返回说明：
 Check  验证码
 
 响应码：
 860,"您还未设定提款密码"
 861,"请输入资金密码"
 862,"资金密码错误"
 */
- (void)ziJinMiMaYanZhengWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block;


/**22.提款可用银行卡信息接口*/
/*
 参数说明：
 " check ":验证码，参见21资金密码验证接口
 
 返回说明：
 Times每天限制提款次数
 Count已成功提款次数
 Wraptime  提款时间
 Starttime  开始时间
 Endtime   结束时间
 Banks 提款可用银行卡信息
 User 用户名
 Availablebalance 可提款金额
 min_money 最小提款金额
 max_money 最大提款金额
 
 响应码：
 870,"找不到此活动的相关记录"
 871,"您有进行中的活动未处理，请领奖或取消后才能进行提现操作！"
 872,"缺少安全码"
 873, "抱歉，您还未达到最低投注金额
 874,"操作失败，请与客户联系，错误代码：59811"
 875, "操作失败，请与客户联系，错误代码：59812"
 876, "操作失败"
 877, "您尚未绑定银行卡，请先进行卡号绑定！"
 878, "没有权限"
 879, "您的资金帐户因为其他操作被锁定，请稍后重试"
 880, "您今天已没有可用提款次数"
 */
- (void)tiKuangKeYongYinHangKaXinXiWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block;

/**确认提款信息接口*/
/*
 参数说明：
 " check ":验证码，参见21资金密码验证接口
 "flag":"withdraw" 固定标识
 "bankinfo":"84#13" 银行卡信息，由22接口中banks->id和banks->bank_id拼接，中间由#号隔开。
 "money":3345 确认提款金额
 
 返回说明：
 "money": 提款金额,
 "cardid": 提款卡id
 
 
 响应码：
 850,"请填写完整的资料"
 851,"提款金额不能低于最低账户提款金额"
 852,"提款金额不能高于最高账户提款金额"
 853,"提款金额不能高于最大可用余额"
 854,"您提交的银行信息有误，请核对后重新提交！"
 855,"您使用的银行卡绑定时间小于{$h}小时，请更换其他银行卡提现！"
 856,"请填写正确的个人银行帐号"
 857,"您注册的时间不足{$allowhorn}小时，不能发起提款申请！"
 858,"当前时间不允许提款！"
 859,"当前时间不允许提款！"
 */
- (void)queRenTiKuangXinXiWithCheck:(NSString *)check bankInfo:(NSString *)bankInfo money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block;

/**最终提款接口*/
/*
 参数说明：
 " check ":验证码，参见21资金密码验证接口
 "flag":" confirm" 固定标识
 " cardid ":提款卡id
 "money":3345 最终提款金额
 
 响应码：
 810,"非法提交"
 811,"提款金额不能低于最低平台提现金额"
 812,"提款金额不能高于最高平台提现金额"
 813,"提款金额不能高于最大可用余额"
 814,"您提交的银行信息有误，请核对后重新提交！"
 815,"您提交的银行信息有误，请核对后重新提交！"
 816,"请填写正确的个人银行帐号"
 817,"对不起，您的资金帐户被其他操作占用"
 818,"对不起，提款金额超出了可用余额"
 819,"对不起，提现金额超出了可用余额"
 820,"请求超时，请重试"
 821,"其他频道有负余额，请先转帐将其补平"
 822,"账户提款申请失败,您的资金帐户意外被锁，请联系管理员"
 823,"账户提款申请成功,但是资金帐户意外被锁，请联系管理员"
 830,"账户提款申请失败"

 */
- (void)zuiZhongTiKuangXinXiWithCheck:(NSString *)check cardId:(NSString *)cardId money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block;

- (void)logoutWithBlock:(void (^)(id JSON, NSError *error))block;

//26.获取广告接口
/*
 请求地址: feed/index.php?controller=help&action=adpic&sess={session id}
 参数：
 GET参数：
 Sess session会话的id
 参数说明：
 返回：
 {
 "adpicid":"1",
 "adtype":"200",
 "adname":"\u6bcd\u5b50\u5356\u840c\u7167",
 "adurl":"\/images\/adpic\/20140530125833.jpg",
 "adlink":"\/feed\/?controller=help&action=notice&nid=46",
 "orderby":"1",
 "ifdisplay":"1",
 "ifdel":"0"
 }
 返回说明：
 无
 Adpicid 流水号
 Adtype 类型
 Adname 链接名
 Adurl 图片广告链接
 Adlink 广告链接（公告地址）
 Orderby 顺序
 响应码：
 无
 */
- (void)getAdWithBlock:(void (^)(id JSON, NSError *error))block;

//22.查询购买记录接口(type  0-已购彩票  1-未开奖彩票 2-中奖彩票 (不传递为0))
- (void)getMyLotteryList_with_type:(NSString *)type projectId:(NSString *)projectId projectNumber:(NSString *)number block:(void (^)(id JSON, NSError *error))block;
@end
