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
#import "AppCacheManager.h"
#import "AppRequest.h"
#import "ServerAddressManager.h"
@implementation AFAppAPIClient
{
    NSInteger currentStatusCode;
}

#pragma mark - Init

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
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

- (AppRequest *)getRequestWithPath:(NSDictionary *)pathParameters Parameters:(NSDictionary *)parameters
{
    DDLogDebug(@"pathParameters:%@\nparameters:%@",pathParameters,parameters);
    
#ifdef OnLine
    NSURL *url = [self generateURL:[ServerAddressManager sharedManager].appAPIBaseURLString params:pathParameters];
#else
    NSURL *url = [self generateURL:kAFAppAPIBaseURLString params:pathParameters];
#endif
    
	AppRequest *request = [[AppRequest alloc] initWithURL:url];
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
    [defaultHeaders setObject:[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)] forKey:@"User-Agent"];
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

//获取sessionId
- (NSString *)getSessionID
{
    if (!_sessionID) {
        NSString *sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_SESSIONID];
        if (!sessionID) {
            DDLogWarn(@"无法获取sessionID，这里需要跳转到登陆页面");
        }
        else
        {
            _sessionID = sessionID;
        }
    }
    
    return _sessionID;
}

#pragma mark - Result Process
//获取JSON成功
- (void)requestFinished:(NSURLRequest *)request json:(id)JSON
{
    AppRequest *appRequest = (AppRequest *)request;
    DDLogInfo(@"requestFinished: %@", JSON);
    
    //转换msg的unicode字符为中文
    if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"]) {
        DDLogInfo(@"msg = %@", [JSON objectForKey:@"msg"]);
        
        if (appRequest.method == APIMethodKeZhuiHaoJiangQi || appRequest.method == APIMethodJiangQi || appRequest.method == APIMethodMenuAndRule || appRequest.method == APIMethodVersionNumber || appRequest.method == APIMethodBalance) {
            ;
        }
        else if (currentStatusCode != AppServerErrorNone) {
            //去掉服务器msg提示不友好的情况，比如AppServerErrorIssueEmpty1，msg为"empty",用户不知道是啥
            if (!(currentStatusCode == AppServerErrorIssueEmpty1 || currentStatusCode == AppServerErrorIssueEmpty2 || currentStatusCode == AppServerErrorLongTime || currentStatusCode == AppServerErrorKick)) {
                [Utility showErrorWithMessage:[JSON objectForKey:@"msg"]];
                DDLogDebug(@"Utility showErrorMessage:%@",[JSON objectForKey:@"msg"]);
            }
        }
    }
}

//获取JSON失败
- (void)requestFailed:(NSURLRequest *)request error:(NSError *)error
{
    if (error.domain == NSCocoaErrorDomain && error.code == 3840) {
        DDLogError(@"JSON解析失败");
        return;
    }
    
    DDLogError(@"requestFailed: %@,domain:%@,code:%ld", [error localizedDescription], error.domain, error.code);
    //目前只列出了部分，具体的参考：https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/Reference/reference.html
    
    AppRequest *appRequest = (AppRequest *)request;
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

- (NSError *)errorAtServer:(NSInteger)statusCode
{
    NSString *errorString = @"Error from server";
    if (statusCode == AppServerErrorAgentCanNotBuy) {
        errorString = @"总代暂无法投注";
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedFailureReasonErrorKey];
    NSError *error = [[NSError alloc] initWithDomain:AppServerErrorDomain code:statusCode userInfo:userInfo];
    
//    NSString *message = [NSString stringWithFormat:@"statusCode:%d",statusCode];
//    [Utility showMessage:message];
    
    if (statusCode == AppServerErrorLongTime || statusCode == AppServerErrorKick || statusCode == AppServerErrorUnActive || statusCode == AppServerErrorPrivateWrong) {
        DDLogWarn(@"需要重新登录");
        [UserInfomation sharedInfomation].shouldLoginAgain = YES;
        DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameShowLogin object:[NSNumber numberWithInteger:statusCode]];
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
        
        currentStatusCode = response.statusCode;
        
        [self requestFinished:request json:JSON];
        
        if ([self hasErrorAtServer:response.statusCode]) {
            if (finishBlock) {
                finishBlock(JSON,[self errorAtServer:response.statusCode]);
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

//修改密码接口
- (void)changePasswordWithAccount:(NSString *)account password:(NSString *)password newPassword:(NSString *)newPassword Block:(void (^)(id JSON, NSError *error))block
{
    //密码加密
//    NSString *randnum = @"";
//    NSString *submitvc = [MyMD5 md5:randnum];
//    submitvc = [NSString stringWithFormat:@"%@%@",submitvc,[MyMD5 md5:password]];
//    NSString *submitpw = [MyMD5 md5:submitvc];
//    
//    NSString *newSubmitvc = [MyMD5 md5:randnum];
//    newSubmitvc = [NSString stringWithFormat:@"%@%@",newSubmitvc,[MyMD5 md5:newPassword]];
//    NSString *newSubmitpw = [MyMD5 md5:newSubmitvc];
    
    NSString *submitpw = [MyMD5 md5:password];
    NSString *newSubmitpw = [MyMD5 md5:newPassword];
    
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"changeloginpass",                          @"action",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   account,                                     @"username",
                                   submitpw,                                    @"securitypass",
                                   newSubmitpw,                                 @"newloginpass",
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
                                       @"version",                                  @"action",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodVersionNumber;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//登陆
- (void)loginWithAccount:(NSString *)account password:(NSString *)password Block:(void (^)(id JSON, NSError *error))block
{
    //密码加密
    NSString *randnum = @"";
    NSString *submitvc = [MyMD5 md5:randnum];
    submitvc = [NSString stringWithFormat:@"%@%@",submitvc,[MyMD5 md5:password]];
    NSString *submitpw = [MyMD5 md5:submitvc];
    
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"default",                                @"controller",
                                       @"login",                                  @"action",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   account,                                   @"username",
                                   submitpw,                                  @"loginpass",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodLogin;
    void (^successBlock)(id JSON) = ^(id JSON){
        _sessionID = [JSON objectForKey:@"sess"];
        //本地存储sessionID
        [[NSUserDefaults standardUserDefaults] setObject:_sessionID forKey:USER_STORE_SESSIONID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    
    [self request:request sucessBlock:successBlock failBlock:nil finishBlock:block];
}

//主页
- (void)getHomeWithBlock:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       sessionID,                                 @"sess",
                                       nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"1",                                 @"V",
                                   nil];
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodLotteryList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//二三级菜单以及玩法接口
- (void)menuAndRuleMethodWithKind:(KindOfLottery *)kind Block:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"noticelist",                               @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodNoticeList;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//17.网站公告内容接口
- (void)getNoticeContentWithNoticeId:(NSString *)noticeId Block:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"notice",                                   @"action",
                                       noticeId,                                    @"nid",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodNoticeContent;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//18.购彩查询接口
- (void)gouCaiChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime lotteryid:(NSString *)lotteryid Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"gamelist",                                 @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   startTime,                                   @"starttime",
                                   endTime,                                     @"endtime",
                                   lotteryid,                                   @"lotteryid",
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
- (void)zhuiHaoChaXunWithStartTime:(NSString *)startTime endTime:(NSString *)endTime lotteryid:(NSString *)lotteryid Page:(NSString *)page Block:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"task",                                     @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"1",                                        @"isgetdata",
                                   startTime,                                   @"starttime",
                                   endTime,                                     @"endtime",
                                   lotteryid,                                   @"lotteryid",
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
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"gameinfo",                                 @"controller",
                                       @"taskdetail",                               @"action",
                                       taskId,                                      @"id",
                                       sessionID,                                   @"sess",
                                       nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"1",                                        @"V",
                                   nil];

    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodGouCaiChaXun;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//19.2、终止追号接口
- (void)cancelTrace_WithTaskId:(NSString *)taskId detailId:(NSString *)detailId Block:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"security",                                 @"controller",
                                       @"platwithdraw",                             @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   password,                                    @"check",
                                   @"1",                                        @"V",
                                   nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:params];
    request.method = APIMethodTiKuangKeYongYinHangKaXinXi;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

//23.确认提款信息接口
- (void)queRenTiKuangXinXiWithCheck:(NSString *)check bankInfo:(NSString *)bankInfo money:(NSString *)money Block:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
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
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"help",                                     @"controller",
                                       @"adpic",                                    @"action",
                                       sessionID,                                   @"sess",
                                       nil];
    
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodLogout;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}
//27.未读消息接口
- (void)getUnreadMessages:(void (^)(id JSON, NSError *error))block
{
    NSString *sessionID = [self getSessionID];
    NSMutableDictionary *pathParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"user",                                     @"controller",
                                       @"messages",                                    @"action",
                                       @"unreadmsg",                                   @"tag",
                                       sessionID,                                   @"sess",
                                       nil];
  
    AppRequest *request = [self getRequestWithPath:pathParams Parameters:nil];
    request.method = APIMethodLogout;
    [self request:request sucessBlock:nil failBlock:nil finishBlock:block];
}

@end
