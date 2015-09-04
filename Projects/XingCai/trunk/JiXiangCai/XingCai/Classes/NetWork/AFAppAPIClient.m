//
//  AFNewsAPIClient.m
//  News
//
//  Created by jay on 13-7-19.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "AFAppAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "MyMD5.h"
#import "KeZhuiHaoJiangQiObject.h"
#import "AppRequest.h"
#import "ServerAddressManager.h"
#import "TraceIssueObject.h"
#import "RSAEncrypt.h"

@implementation AFAppAPIClient
{
    NSString *sessionID;
}

#pragma mark - Init

+ (AFAppAPIClient *)sharedClient {
    static AFAppAPIClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AFAppAPIClient alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init{
    if (self = [super init]) {
        self.requestQueue = [[NSOperationQueue alloc] init];
        [self.requestQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }    
    return self;
}

#pragma mark - Tool Methods
- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

- (AppRequest *)getRequestWithPath:(NSDictionary *)pathParameters Parameters:(NSDictionary *)parameters
{
#ifdef OnLine
    NSURL *url = [self generateURL:[ServerAddressManager sharedManager].appAPIBaseURLString params:pathParameters];
#else
    NSURL *url = [self generateURL:kAFAppAPIBaseURLString params:pathParameters];
#endif
    
	AppRequest *request = [[AppRequest alloc] initWithURL:url];
    request.parameters = parameters;
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *defaultHeaders = [NSMutableDictionary dictionary];
    
    // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
    NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
    [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float q = 1.0f - (idx * 0.1f);
        [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
        *stop = q <= 0.5f;
    }];
    [defaultHeaders setObject:[acceptLanguagesComponents componentsJoinedByString:@", "] forKey:@"Accept-Language"];
    [defaultHeaders setObject:@"ios" forKey:@"User-Agent"];
    [defaultHeaders setObject:@"R3F6G8H2A1B6J5" forKey:@"ClientDES"];
    [defaultHeaders setObject:@"4T6U8I9L1S1V4N" forKey:@"CSecretKey"];
    
    [request setAllHTTPHeaderFields:defaultHeaders];
    
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(stringEncoding));
    NSError *error = nil;
    
    if (parameters) {
        [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
#pragma clang diagnostic pop
    }

    if (error) {
        DDLogError(@"%@ %@: %@", [self class], NSStringFromSelector(_cmd), error);
    }
    
    return request;
}

#pragma mark - Result Process
//获取JSON成功
- (void)requestFinished:(NSURLRequest *)request json:(id)JSON
{
    AppRequest *appRequest = (AppRequest *)request;
    DDLogInfo(@"requestFinished:\nmethod = %@;\nURL = %@;\nparameters = %@\nresponseJSON = \n%@",appRequest.methodName, [appRequest.URL absoluteString], appRequest.parameters, JSON);

    long long status = [[JSON objectForKey:@"status"] longLongValue];
    
    //转换msg的unicode字符为中文
    if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"]) {
        DDLogInfo(@"msg = %@", [JSON objectForKey:@"msg"]);
        
        if (appRequest.method == APIMethodTraceIssue || appRequest.method == APIMethodCurrentIssue || appRequest.method == APIMethodPlayRules || appRequest.method == APIMethodVersion || appRequest.method == APIMethodBalance) {
            ;
        }
        else if (status != AppServerErrorNone) {
            //去掉服务器msg提示不友好的情况，比如AppServerErrorIssueEmpty1，msg为"empty",用户不知道是啥
            if (!(status == AppServerErrorIssueEmpty1 || status == AppServerErrorIssueEmpty2 || status == AppServerErrorLongTime || status == AppServerErrorKick || status == AppServerErrorBlocked)) {
                [Utility showErrorWithMessage:[JSON objectForKey:@"msg"]];
                DDLogDebug(@"Utility showErrorMessage:%@",[JSON objectForKey:@"msg"]);
            }
        }
    }
}

//获取JSON失败
- (void)requestFailed:(NSURLRequest *)request error:(NSError *)error
{
    AppRequest *appRequest = (AppRequest *)request;
    DDLogInfo(@"requestFinished:\nmethod = %@;\nURL = %@;\nparameters = %@\nerror = %@\ndomain = %@\ncode = %ld",appRequest.methodName, [appRequest.URL absoluteString], appRequest.parameters, [error localizedDescription], error.domain, (long)error.code);
    
    if (error.domain == NSCocoaErrorDomain && error.code == 3840) {
        DDLogError(@"JSON解析失败");
        return;
    }
    
    //目前只列出了部分，具体的参考：https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/Reference/reference.html
    
    if (appRequest.method == APIMethodVersionNumber) {
        ;
    }
    else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1009) {
        [Utility showMessage:@"网络不可用"];
    }
    else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1004) {
        [Utility showMessage:@"无法连接到网络"];
    }
    else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1003) {
        [Utility showMessage:@"无法连接到指定服务器"];
    }
    else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1001) {
        [Utility showMessage:@"您的网络不给力..."];
    }
    else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1005) {
        [Utility showMessage:@"网络连接丢失"];
    }
    else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1020) {
        [Utility showMessage:@"系统因来电等原因暂时不允许数据通信"];
    }
    else {
        [Utility showMessage:@"未知错误"];
    }
}

//检查服务端是否出错
- (BOOL)hasErrorAtServer:(NSInteger)statusCode
{
    return (statusCode == AppServerErrorNone ? NO : YES);
}

- (NSError *)errorAtServer:(id)JSON
{
    NSInteger statusCode = [[JSON objectForKey:@"status"] integerValue];
    NSDictionary *userInfo;
    if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"]) {
        userInfo = [NSDictionary dictionaryWithObject:[JSON objectForKey:@"msg"] forKey:NSLocalizedFailureReasonErrorKey];
    }
    else
    {
        userInfo = [NSDictionary dictionaryWithObject:@"Error from server" forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    NSError *error = [[NSError alloc] initWithDomain:AppServerErrorDomain code:statusCode userInfo:userInfo];
    
//    NSString *message = [NSString stringWithFormat:@"statusCode:%d",statusCode];
//    [Utility showMessage:message];
    
    if (statusCode == AppServerErrorLongTime || statusCode == AppServerErrorKick || statusCode == AppServerErrorUnActive || statusCode == AppServerErrorPrivateWrong) {
        DDLogWarn(@"需要重新登录");
        [UserInfomation sharedInfomation].shouldLoginAgain = YES;
        DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameShouldLoginAgain object:[NSNumber numberWithInteger:statusCode]];
    }
    else if(statusCode == AppServerErrorServerInternal)
    {
        [Utility showErrorWithMessage:@"服务器内部错误"];
    }
    else
    {
        
    }
    
    return error;
}

//结果处理
- (void)request:(AppRequest *)request sucessBlock:(void (^)(id JSON))sucessBlock failBlock:(void (^)())failBlock finishBlock:(void (^)())finishBlock
{
    [request setTimeoutInterval:TimeoutInterval];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSInteger status = [[JSON objectForKey:@"status"] integerValue];
       
        [self requestFinished:request json:JSON];
        
        if ([self hasErrorAtServer:status]) {
            if (finishBlock) {
                finishBlock(JSON,[self errorAtServer:JSON]);
            }
        }
        else
        {
            if (sucessBlock) {
                sucessBlock(JSON);
            }
            
            if (finishBlock) {
                finishBlock(JSON, nil);
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self requestFailed:request error:error];
        
        if (failBlock) {
            failBlock();
        }
        
        if (finishBlock) {
            finishBlock(JSON, error);
        }
    }];
    operation.JSONReadingOptions = NSJSONReadingAllowFragments;
    
    //jiangqi接口需要立即执行（对时间要求比较高）
    if (request.method == APIMethodJiangQi) {
        [operation start];
    }
    else
    {
        [self.requestQueue addOperation:operation];
    }
}

#pragma mark - Http Operate

#pragma mark - 2.1.1.	登陆
- (void)login_with_account:(NSString *)account password:(NSString *)password logintype:(NSString *)logintype block:(void (^)(id JSON, NSError *error))block
{
//    //密码md5
//    NSString *md5password = [MyMD5 md5:password];
    
    //接口修改：对密码改用RSA加密方式传输
    RSAEncrypt *rsa = [[RSAEncrypt alloc]init];
    NSString *rsaPassword = [rsa encryptToString:password];
    
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"default",                                @"controller",
                                       @"login",                                  @"action",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   account,                                     @"username",
                                   rsaPassword,                                 @"loginpass",
                                   @"mobile",                                   @"apitype",
                                   logintype,                                   @"logintype",
                                   nil];
    
    //接口修改：当为资金密码登录时，params增加属性“forgot”,固定值1
    if ([logintype isEqualToString:@"security"]) {
        [params setObject:@"1" forKey:@"forgot"];
    }
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodLogin;
    void (^successBlock)(id JSON) = ^(id JSON){
        sessionID = [JSON objectForKey:@"sess"];
    };
    
    [self request:request sucessBlock:successBlock failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.2.	退出
- (void)logout_with_block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"default",                                  @"controller",
                                       @"logout",                                   @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodLogout;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - type1为2.1.3.	历史中奖号码，type2为2.1.9.	开奖号码
- (void)historyOfTheWinningNumbers_with_lotteryId:(NSString *)lotteryId type:(NSString *)type block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"game",                                     @"controller",
                                       @"issueindex",                               @"action",
                                       lotteryId,                                   @"lotteryid",
                                       type,                                        @"type",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodHistoryOfTheWinningNumbers;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.4.	获取账号余额
- (void)getBalance_with_block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobileapi",                                @"controller",
                                       @"mobilegetmoney",                           @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodBalance;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.5.	站内信列表
- (void)getMessageList_with_maxid:(NSString *)maxid count:(NSString *)count block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"messages",                                 @"action",
                                       maxid,                                       @"maxid",
                                       count,                                       @"count",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodMessageList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//取消此接口，站内信内容数据在2.1.5.	站内信列表接口一起返回
//#pragma mark - 2.1.6.	站内信内容接口
//- (void)getMessageDetail_with_noticeId:(NSString *)noticeId block:(void (^)(id JSON, NSError *error))block
//{
//    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"user",                                     @"controller",
//                                       @"messages",                                 @"action",
//                                       @"viewdetail",                               @"tag",
//                                       noticeId,                                    @"msgid",
//                                       sessionID,                                   @"sess",
//                                       nil];
//    
//    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
//    request.method = APIMethodMessageDetail;
//    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
//}

#pragma mark - 2.1.7.	公告列表
- (void)getNoticeList_with_block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"noticelist",                               @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodNoticeList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.8.	公告内容NSURLRequest
- (NSURLRequest *)noticeDetailRequestWithURLString:(NSString *)urlString
{
    NSString *fullURLString = [urlString stringByAppendingFormat:@"&sess=%@",sessionID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullURLString]];
    return request;
}


#pragma mark - 2.1.9.	开奖号码
//请查看2.1.3.	历史中奖号码

#pragma mark - 2.1.10.	追号记录
- (void)traceRecordList_with_lotteryid:(NSString *)lotteryid startTime:(NSString *)startTime endTime:(NSString *)endTime maxid:(NSString *)maxid count:(NSString *)count block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"task",                                     @"action",
                                       @"1",                                        @"isgetdata",
                                       startTime,                                   @"starttime",
                                       endTime,                                     @"endtime",
                                       lotteryid,                                   @"lotteryid",
                                       maxid,                                       @"maxid",
                                       count,                                       @"count",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodTraceRecordList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.11.	投注记录
- (void)betRecordList_with_lotteryid:(NSString *)lotteryid startTime:(NSString *)startTime endTime:(NSString *)endTime maxid:(NSString *)maxid count:(NSString *)count block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"gamelist",                                 @"action",
                                       startTime,                                   @"starttime",
                                       endTime,                                     @"endtime",
                                       lotteryid,                                   @"lotteryid",
                                       @"1",                                        @"isgetdata",
                                       maxid,                                       @"maxid",
                                       count,                                       @"count",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodBetRecordList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.12.	投注记录撤单
- (void)cancelBet_with_projectId:(NSString *)projectId block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"cancelgame",                               @"action",
                                       projectId,                                   @"id",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodCancelBet;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.13.	追号记录撤单
- (void)cancelTrace_with_taskId:(NSString *)taskId detailId:(NSString *)detailId block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"canceltask",                               @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   taskId,                                      @"id",
                                   detailId,                                    @"taskid",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodCancelTrace;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.14.	投注接口
- (void)bet_with_kind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"game",                                     @"controller",
                                       @"play",                                     @"action",
                                       kind.lotteryName,                                    @"nav",
                        
                                       sessionID,                                   @"sess",
                                       nil];
    
    [pathParams setObject:@"50" forKey:@"curmid"];
//    if (kind.curmid.length > 0) {
//        [pathParams setObject:kind.curmid forKey:@"curmid"];
//    }
//    if (kind.pid.length > 0) {
//        [pathParams setObject:kind.pid forKey:@"pid"];
//    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"save",                                         @"flag",
                                   lotteryid,                                       @"lotteryid",
                                   lt_issue_start,                                  @"lt_issue_start",
                                   bettingInformations,                             @"lt_project",
                                   lt_project_modes,                                @"lt_project_modes",
                                   lt_total_money,                                  @"lt_total_money",
                                   lt_total_nums,                                   @"lt_total_nums",
//                                   @"2",                                            @"play_source",
                                   nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSLog(@"json:%@",jsonString);
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodBet;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.15.	投注追号接口
- (void)trace_with_kind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums lt_trace_count_input:(NSString *)lt_trace_count_input lt_trace_diff:(NSString *)lt_trace_diff lt_trace_if:(NSString *)lt_trace_if lt_trace_margin:(NSString *)lt_trace_margin lt_trace_money:(NSString *)lt_trace_money lt_trace_stop:(NSString *)lt_trace_stop lt_trace_times_diff:(NSString *)lt_trace_times_diff lt_trace_times_margin:(NSString *)lt_trace_times_margin lt_trace_times_same:(NSString *)lt_trace_times_same keZhuiHaoJiangQis:(NSArray *)keZhuiHaoJiangQis Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"game",                                     @"controller",
                                       @"play",                                     @"action",
                                       kind.nav,                                    @"nav",
                                       sessionID,                                   @"sess",
                                       nil];
     [pathParams setObject:@"50" forKey:@"curmid"];
//    if (kind.curmid.length > 0) {
//        [pathParams setObject:kind.curmid forKey:@"curmid"];
//    }
//    if (kind.pid.length > 0) {
//        [pathParams setObject:kind.pid forKey:@"pid"];
//    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"save",                                         @"flag",
                                   lotteryid,                                       @"lotteryid",
                                   lt_issue_start,                                  @"lt_issue_start",
                                   bettingInformations,                             @"lt_project",
                                   lt_project_modes,                                @"lt_project_modes",
                                   lt_total_money,                                  @"lt_total_money",
                                   lt_total_nums,                                   @"lt_total_nums",
                                   lt_trace_count_input,                            @"lt_trace_count_input",
                                   lt_trace_diff,                                   @"lt_trace_diff",
                                   lt_trace_margin,                                 @"lt_trace_margin",
                                   lt_trace_money,                                  @"lt_trace_money",
                                   lt_trace_times_diff,                             @"lt_trace_times_diff",
                                   lt_trace_times_margin,                           @"lt_trace_times_margin",
                                   lt_trace_times_same,                             @"lt_trace_times_same",
                                   lt_trace_stop,                                             @"lt_trace_stop",
                                   nil];
    NSMutableArray *lt_trace_issues = [NSMutableArray array];
    for (int i = 0; i < [lt_trace_count_input integerValue]; ++i) {
        KeZhuiHaoJiangQiObject *keZhuiHaoJiangQiObject = [keZhuiHaoJiangQis objectAtIndex:i];
        TraceIssueObject *traceIssueObject = [[TraceIssueObject alloc] init];
        traceIssueObject.issue = keZhuiHaoJiangQiObject.issue;
        traceIssueObject.times = lt_trace_times_same;
        [lt_trace_issues addObject:[traceIssueObject objectDictionary]];
    }
    [params setObject:lt_trace_issues forKey:@"lt_trace_issues"];
    [params setObject:lt_trace_if forKey:@"lt_trace_if"];
 
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodTrace;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.17.	忘记密码后修改密码
- (void)findPassword_with_newPassword:(NSString *)newPassword block:(void (^)(id JSON, NSError *error))block
{
//    //密码md5
//    NSString *md5pass = [MyMD5 md5:newPassword];
    
    //接口修改：对密码改用RSA加密方式传输
    RSAEncrypt *rsa = [[RSAEncrypt alloc]init];
    NSString *rsaPassword = [rsa encryptToString:newPassword];
    
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobileapi",                                @"controller",
                                       @"changeloginpass",                          @"action",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   rsaPassword,                                     @"newpass",
                                   rsaPassword,                                     @"confirm_newpass",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodChangePassword;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.18.	活动宣传图接口
- (void)getActivityList_with_screenType:(ScreenType)screenType block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobileapi",                                @"controller",
                                       @"activitypic",                              @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @(screenType),                                     @"iostype",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodActivity;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.19.	站内信数量
- (void)getMessageAmount_with_block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobileapi",                                @"controller",
                                       @"countmessage",                             @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodMessageAmount;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.20.	投注详情页
- (void)betDetail_with_projectid:(NSString *)projectid block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"gamedetail",                               @"action",
                                       projectid,                                   @"id",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodBetDetail;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.21.	追号详情页
- (void)traceDetail_with_taskId:(NSString *)taskId block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"taskdetail",                               @"action",
                                       taskId,                                      @"id",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodTraceDetail;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.22.	意见反馈
- (void)feedback_with_content:(NSString *)content block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobileapi",                                 @"controller",
                                       @"mobilesendemail",                           @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   content,                                     @"content",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodFeedback;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.23.	修改登陆密码
- (void)changePassword_with_oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword block:(void (^)(id JSON, NSError *error))block
{
//    //密码md5
//    NSString *md5OldPass = [MyMD5 md5:oldPassword];
//    NSString *md5NewPass = [MyMD5 md5:newPassword];
    
    //接口修改，用RSA对密码进行加密
    RSAEncrypt *rsa = [[RSAEncrypt alloc]init];
    NSString *rsaOldPass = [rsa encryptToString:oldPassword];
    NSString *rsaNewPass = [rsa encryptToString:newPassword];
    
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"changeloginpass",                          @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   rsaOldPass,                                  @"oldpass",
                                   rsaNewPass,                                  @"newpass",
                                   rsaNewPass,                                  @"confirm_newpass",
                                   @"loginpass",                                @"changetype",
                                   @"changepass",                               @"flag",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodChangePassword;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.24.	玩法接口
- (void)playRules_with_type:(NSString *)type block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type,                                        @"nav",
                                       sessionID,                                   @"sess",
                                       nil];
   
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodPlayRules;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.25.	当前奖期接口
- (void)currentIssue_with_nav:(NSString *)nav lotteryid:(NSString *)lotteryid block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       nav,                                        @"nav",
                                       sessionID,                                  @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"read",                                     @"flag",
                                   lotteryid,                                   @"lotteryid",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodCurrentIssue;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.26.	可追奖期接口
- (void)traceIssue_with_nav:(NSString *)nav block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       nav,                                        @"nav",
                                       @"issue",                                   @"task",
                                       sessionID,                                  @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodTraceIssue;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.27.	新手帮助接口
- (NSURLRequest *)userHelpRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.jxc666.org/wanfa.htm"]];
    return request;
}

#pragma mark - 2.1.28.	版本检测接口
- (void)version_with_block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobileapi",                               @"controller",
                                       @"versionupdate",                           @"action",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodVersion;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

#pragma mark - 2.1.29.	更新未读站内信
- (void)updateMessage_with_msgid:(NSString *)msgid block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"messages",                                 @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   msgid,                                       @"msgid",
                                   @"updatestatus",                             @"flag",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodUpdateMessage;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//修改密码接口
- (void)changePasswordWithAccount:(NSString *)account password:(NSString *)password newPassword:(NSString *)newPassword type:(ChangePasswordType)type Block:(void (^)(id JSON, NSError *error))block
{
//    //密码md5加密
//    NSString *submitpw = [MyMD5 md5:password];
//    NSString *newSubmitpw = [MyMD5 md5:newPassword];
    
    //RSA加密
    RSAEncrypt *rsa = [[RSAEncrypt alloc]init];
    NSString *submitpw = [rsa encryptToString:password];
    NSString *newSubmitpw = [rsa encryptToString:newPassword];
    
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"changeloginpass",                          @"action",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   account,                                     @"username",
                                   submitpw,                                    @"oldpass",
                                   newSubmitpw,                                 @"newpass",
                                   [@(type) stringValue],                       @"type",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodChangePassword;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//版本号接口
- (void)getVersionNumberWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"IosVersion",                               @"action",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodVersionNumber;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//主页
- (void)getHomeWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"default",                                @"controller",
                                       @"index",                                  @"action",
                                       sessionID,                                 @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodHome;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//开奖信息首页接口
- (void)getLotteryInfomationWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"game",                                   @"controller",
                                       @"issueindex",                             @"action",
                                       sessionID,                                 @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodLotteryInfomationList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//开奖信息Sub接口
- (void)getLotteryInfomationListWithLotteryID:(NSString *)lotteryId issueNumber:(NSString *)issueNumber Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"game",                                   @"controller",
                                       @"issuelist",                              @"action",
                                       sessionID,                                 @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   lotteryId,                                  @"lotteryId",
                                   issueNumber,                                @"issueNumber",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodLotteryInfomationDetail;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//彩种信息列表接口
- (void)lotteryListWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       sessionID,                                 @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodLotteryList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//二三级菜单以及玩法接口
- (void)menuAndRuleMethodWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       kind.nav,                                    @"nav",
                                       sessionID,                                   @"sess",
                                       nil];
    if (kind.curmid.length > 0) {
        [pathParams setObject:kind.curmid forKey:@"curmid"];
    }
    if (kind.pid.length > 0) {
        [pathParams setObject:kind.pid forKey:@"pid"];
    }
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    
    request.method = APIMethodMenuAndRule;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//当前销售的奖期接口
- (void)jiangQiWithNav:(NSString *)nav lotteryId:(NSString *)lotteryId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       nav,                                        @"nav",
                                       sessionID,                                  @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   lotteryId,                                       @"lotteryid",
                                   @"read",                                         @"flag",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodJiangQi;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//可追号奖期接口
- (void)keZhuiHaoJiangQiWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       kind.nav,                                    @"nav",
                                       @"issue",                                    @"task",
                                       sessionID,                                   @"sess",
                                       nil];
    if (kind.curmid.length > 0) {
        [pathParams setObject:kind.curmid forKey:@"curmid"];
    }
    if (kind.pid.length > 0) {
        [pathParams setObject:kind.pid forKey:@"pid"];
    }
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodKeZhuiHaoJiangQi;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//投注接口
- (void)touZhuWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"game",                                     @"controller",
                                       @"play",                                     @"action",
                                       kind.nav,                                    @"nav",
                                       sessionID,                                   @"sess",
                                       nil];
    if (kind.curmid.length > 0) {
        [pathParams setObject:kind.curmid forKey:@"curmid"];
    }
    if (kind.pid.length > 0) {
        [pathParams setObject:kind.pid forKey:@"pid"];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"save",                                         @"flag",
                                   lotteryid,                                       @"lotteryid",
                                   lt_issue_start,                                  @"lt_issue_start",
                                   bettingInformations,                             @"lt_project",
                                   lt_project_modes,                                @"lt_project_modes",
                                   lt_total_money,                                  @"lt_total_money",
                                   lt_total_nums,                                   @"lt_total_nums",
                                   @"2",                                            @"play_source",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodTouZhu;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//投注追号接口
- (void)touZhuZhuiHaoWithKind:(KindOfLottery *)kind lotteryid:(NSString *)lotteryid lt_issue_start:(NSString *)lt_issue_start bettingInformations:(NSArray *)bettingInformations lt_project_modes:(NSString *)lt_project_modes lt_total_money:(NSString *)lt_total_money lt_total_nums:(NSString *)lt_total_nums lt_trace_count_input:(NSString *)lt_trace_count_input lt_trace_diff:(NSString *)lt_trace_diff lt_trace_if:(NSString *)lt_trace_if lt_trace_margin:(NSString *)lt_trace_margin lt_trace_money:(NSString *)lt_trace_money lt_trace_stop:(NSString *)lt_trace_stop lt_trace_times_diff:(NSString *)lt_trace_times_diff lt_trace_times_margin:(NSString *)lt_trace_times_margin lt_trace_times_same:(NSString *)lt_trace_times_same keZhuiHaoJiangQis:(NSArray *)keZhuiHaoJiangQis Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"game",                                     @"controller",
                                       @"play",                                     @"action",
                                       kind.nav,                                    @"nav",
                                       sessionID,                                   @"sess",
                                       nil];
    if (kind.curmid.length > 0) {
        [pathParams setObject:kind.curmid forKey:@"curmid"];
    }
    if (kind.pid.length > 0) {
        [pathParams setObject:kind.pid forKey:@"pid"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"save",                                         @"flag",
                                   lotteryid,                                       @"lotteryid",
                                   lt_issue_start,                                  @"lt_issue_start",
                                   bettingInformations,                             @"lt_project",
                                   lt_project_modes,                                @"lt_project_modes",
                                   lt_total_money,                                  @"lt_total_money",
                                   lt_total_nums,                                   @"lt_total_nums",
                                   lt_trace_count_input,                            @"lt_trace_count_input",
                                   lt_trace_diff,                                   @"lt_trace_diff",
                                   lt_trace_margin,                                 @"lt_trace_margin",
                                   lt_trace_money,                                  @"lt_trace_money",
                                   lt_trace_times_diff,                             @"lt_trace_times_diff",
                                   lt_trace_times_margin,                           @"lt_trace_times_margin",
                                   lt_trace_times_same,                             @"lt_trace_times_same",
                                   @"2",                                            @"play_source",
                                   nil];
    if (lt_trace_if) {
        [params setObject:lt_trace_if forKey:@"lt_trace_if"];
    }
    if (lt_trace_stop) {
        [params setObject:lt_trace_stop forKey:@"lt_trace_stop"];
    }
//    NSArray *components = [lt_issue_start componentsSeparatedByString:@"-"];
//    NSString *issue = [components firstObject];
//    NSString *currentNumber = [components lastObject];
    NSMutableArray *lt_trace_issues = [NSMutableArray array];
    for (int i = 0; i < [lt_trace_count_input integerValue]; ++i) {
        KeZhuiHaoJiangQiObject *keZhuiHaoJiangQiObject = [keZhuiHaoJiangQis objectAtIndex:i];
//        NSString *trace_issue = [NSString stringWithFormat:@"%@-%03d",issue,[currentNumber integerValue] + i];
        NSString *trace_issue = keZhuiHaoJiangQiObject.issue;
        [lt_trace_issues addObject:trace_issue];
        
        NSString *trace_issue_time = [NSString stringWithFormat:@"lt_trace_times_%@",trace_issue];
        [params setObject:lt_trace_times_same forKey:trace_issue_time];
    }
    [params setObject:lt_trace_issues forKey:@"lt_trace_issues"];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodTouZhuZhuiHao;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//玩法介绍帮助接口
- (void)getPlayInfomationWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"playinfo",                                 @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodPlayInfomation;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}
//如何存款帮助接口
- (void)getHowToSavingWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"howtosaving",                              @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodHowToSaving;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}
//常见问题帮助接口
- (void)getAnswerWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"answer",                                   @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodAnswer;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}
//12.可用余额接口
- (void)getBalanceWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"default",                                  @"controller",
                                       @"menu",                                     @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"getmoney",                                 @"flag",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodBalance;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//13.消息列表接口
- (void)getMessageListWithPage:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"messages",                                 @"action",
                                       page,                                        @"p",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodMessageList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//13.1、更新头像接口
- (void)updateAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"headportrait",                             @"action",
                                       @"update",                                   @"flag_head_portrait",
                                       avatarId,                                    @"mark_head_portrait",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodMessageList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//13.1、获取头像接口
- (void)getAvatarWithId:(NSString *)avatarId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"headportrait",                             @"action",
                                       @"get",                                      @"flag_head_portrait",
                                       avatarId,                                    @"mark_head_portrait",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodMessageList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//14.消息内容接口
- (void)getMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"messages",                                 @"action",
                                       @"viewdetail",                               @"tag",
                                       messageId,                                   @"msgid",
                                       sessionID,                                   @"sess",
                                       nil];
    
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodMessageList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//15.删除消息接口
- (void)deleteMessageContentWithMessageId:(NSString *)messageId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"messages",                                 @"action",
                                       @"deleteone",                                @"tag",
                                       messageId,                                   @"msgid",
                                       sessionID,                                   @"sess",
                                       nil];
    
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodDeleteMessageContent;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//16.网站公告列表接口
- (void)getNoticeListWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"noticelist",                                @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodNoticeList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//17.网站公告内容接口
- (void)getNoticContentWwitNnoticeId:(NSString *)noticeId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"notice",                                   @"action",
                                       noticeId,                                    @"nid",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodNoticeDetail;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//18.购彩查询接口
- (void)gouCaiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"gamelist",                                 @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   startTime,                                   @"starttime",
                                   endTime,                                     @"endtime",
                                   @"0",                                        @"lotteryid",
                                   @"0",                                        @"methodid",
                                   @"0",                                        @"issue",
//                                   @"null",                                     @"username",
//                                   @"null",                                     @"include",
//                                   @"null",                                     @"modes",
//                                   @"null",                                     @"projectno",
                                   @"1",                                        @"isgetdata",
                                   page,                                        @"page",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodGouCaiChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//18.1、投注详情接口
- (void)betDetail_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"gamedetail",                               @"action",
                                       projectid,                                   @"id",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodGouCaiChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//18.2、撤单接口
- (void)cancelOrder_WithProjectid:(NSString *)projectid Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"cancelgame",                               @"action",
                                       projectid,                                   @"id",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodGouCaiChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}


//19.追号查询接口
- (void)zhuiHaoChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"task",                                     @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"1",                                        @"isgetdata",
                                   startTime,                                   @"starttime",
                                   endTime,                                     @"endtime",
                                   @"0",                                        @"lotteryid",
                                   @"0",                                        @"methodid",
                                   @"0",                                        @"issue",
//                                   @"null",                                     @"username",
                                   page,                                        @"page",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodZhuiHaoChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//19.1、追号明细查询接口
- (void)traceDetail_WithTaskId:(NSString *)taskId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"taskdetail",                               @"action",
                                       taskId,                                      @"id",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodGouCaiChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//19.2、终止追号接口
- (void)cancelTrace_WithTaskId:(NSString *)taskId detailId:(NSString *)detailId Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"canceltask",                               @"action",
                                       taskId,                                      @"id",
                                       detailId,                                    @"detail",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodGouCaiChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//20.充提查询接口
- (void)chongTiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"report",                                   @"controller",
                                       @"bankreport",                               @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"0",                                        @"ordertype",
                                   startTime,                                   @"ordertime_min",
                                   endTime,                                     @"ordertime_max",
                                   //                                   @"null",                                     @"username",
                                   page,                                        @"page",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodChongTiChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//21.资金密码验证接口
- (void)ziJinMiMaYanZhengWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"security",                                 @"controller",
                                       @"checkpass",                                @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"check",                                    @"flag",
                                   password,                                    @"secpass",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodZiJinMiMaYanZheng;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//22.提款可用银行卡信息接口
- (void)tiKuangKeYongYinHangKaXinXiWithPassword:(NSString *)password Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"security",                                 @"controller",
                                       @"platwithdraw",                             @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   password,                                    @"check",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodTiKuangKeYongYinHangKaXinXi;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//23.确认提款信息接口
- (void)queRenTiKuangXinXiWithCheck:(NSString *)check bankInfo:(NSString *)bankInfo money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"security",                                 @"controller",
                                       @"platwithdraw",                             @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"withdraw",                                 @"flag",
                                   check,                                       @"check",
                                   bankInfo,                                    @"bankinfo",
                                   money,                                       @"money",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodQueRenTiKuangXinXi;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//24.最终提款接口
- (void)zuiZhongTiKuangXinXiWithCheck:(NSString *)check cardId:(NSString *)cardId money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"security",                                 @"controller",
                                       @"platwithdraw",                             @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"confirm",                                  @"flag",
                                   check,                                       @"check",
                                   cardId,                                      @"cardid",
                                   money,                                       @"money",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodZuiZhongTiKuangXinXi;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//25.退出登录接口
- (void)logoutWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"default",                                  @"controller",
                                       @"logout",                                   @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodLogout;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//26.获取广告接口
- (void)getAdWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"adpic",                                    @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodActivity;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//22.查询购买记录接口(type  0-已购彩票  1-未开奖彩票 2-中奖彩票 (不传递为0))
- (void)getMyLotteryList_with_type:(NSString *)type projectId:(NSString *)projectId projectNumber:(NSString *)number block:(void (^)(id JSON, NSError *error))block
{
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"buyrecord",                                @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   type,                                        @"type",
                                   number,                                      @"projectnum",
                                   projectId,                                   @"projectid",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodMyLottery;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}
@end
