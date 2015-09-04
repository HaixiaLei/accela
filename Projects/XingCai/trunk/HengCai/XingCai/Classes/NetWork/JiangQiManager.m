//
//  JiangQiManager.m
//  XingCai
//
//  Created by jay on 14-3-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "JiangQiManager.h"
#import "KeZhuiHaoJiangQiObject.h"
#import "SecondMenuObject.h"

#define JiangQiFailTimeMax 3

@implementation JiangQiManager
{
    NSMutableDictionary *allJiangQiDictionary;
    
    BOOL shouldShowNextAlert;
    
    int jiangQiFailTime;
    int keZhuiHaoJiangQiFailTime;
}

+ (JiangQiManager *)sharedManager {
    static JiangQiManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[JiangQiManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        allJiangQiDictionary = [NSMutableDictionary dictionary];
        jiangQiFailTime = 0;
        keZhuiHaoJiangQiFailTime = 0;
    }
    return self;
}

- (void)stopAllCountDownTimer
{
    NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
    
    for (int i = 0; i < lotteryList.count; ++i) {
        KindOfLottery *kindOfLottery = [lotteryList objectAtIndex:i];
        
        NSArray *ruleAndMenuArray = [[AppCacheManager sharedManager] getMenuAndRuleWithKindOfLottery:kindOfLottery];
        
        if (ruleAndMenuArray.count > 0) {
            SecondMenuObject *second = [ruleAndMenuArray objectAtIndex:0];
            
            JiangQiObject *jiangQiObject = [self getJiangQiObjectWithLotteryId:second.lotteryid];
            [jiangQiObject.countDownTimer invalidate];
            jiangQiObject.countDownTimer = nil;
        }
#ifdef Version_1
        i = (int)lotteryList.count;
#endif
    }
    
    //清空奖期和投注截止时间
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateTime object:@"暂无"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateJiangQi object:@"暂无"];
}

- (JiangQiObject *)getJiangQiObjectWithLotteryId:(NSString *)lotteryId
{
    if (!lotteryId) {
        return nil;
    }
    if ([lotteryId respondsToSelector:@selector(stringValue)]) {
        lotteryId = [lotteryId performSelector:@selector(stringValue)];
    }
    JiangQiObject *jiangQiObject = [allJiangQiDictionary objectForKey:lotteryId];
    if (!jiangQiObject) {
        jiangQiObject = [[JiangQiObject alloc] init];
        jiangQiObject.lotteryId = lotteryId;
        [allJiangQiDictionary setObject:jiangQiObject forKey:lotteryId];
    }
    return jiangQiObject;
}
- (void)setJiangQiObject:(JiangQiObject *)jiangQiObject lotteryId:(NSString *)lotteryId
{
    [allJiangQiDictionary setObject:jiangQiObject forKey:lotteryId];
}
- (NSString *)getCurrentJiangQiWithLotteryId:(NSString *)lotteryId
{
    JiangQiObject *jiangQiObject = [allJiangQiDictionary objectForKey:lotteryId];
    if (jiangQiObject) {
        return jiangQiObject.currentJiangQi;
    }
    else
    {
        return nil;
    }
    
}
- (NSString *)getTimeStringWithLotteryId:(NSString *)lotteryId
{
    JiangQiObject *jiangQiObject = [allJiangQiDictionary objectForKey:lotteryId];
    if (jiangQiObject) {
        return jiangQiObject.timeString;
    }
    else
    {
        return nil;
    }
}
- (NSArray *)getKeZhuiHaoJiangQisWithLotteryId:(NSString *)lotteryId
{
    JiangQiObject *jiangQiObject = [allJiangQiDictionary objectForKey:lotteryId];
    if (jiangQiObject) {
        return jiangQiObject.keZhuiHaoJiangQis;
    }
    else
    {
        return nil;
    }
}
- (void)resetFailCount
{
    jiangQiFailTime = 0;
    keZhuiHaoJiangQiFailTime = 0;
}
- (void)updateAllJiangQi
{
    [self resetFailCount];
    
    jiangQiFailTime = 0;
    keZhuiHaoJiangQiFailTime = 0;
    NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
    
    for (int i = 0; i < lotteryList.count; ++i) {
        KindOfLottery *kindOfLottery = [lotteryList objectAtIndex:i];
        
        NSArray *ruleAndMenuArray = [[AppCacheManager sharedManager] getMenuAndRuleWithKindOfLottery:kindOfLottery];
        
        if (ruleAndMenuArray.count > 0) {
            SecondMenuObject *second = [ruleAndMenuArray objectAtIndex:0];
            
            JiangQiObject *jiangQiObject = [self getJiangQiObjectWithLotteryId:second.lotteryid];
            jiangQiObject.kindOfLottery = kindOfLottery;
            
            DDLogDebug(@"trace-#2848 getJiangQiWithJiangQiObject,method:%@,class:%@",NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            [self getJiangQiWithJiangQiObject:jiangQiObject lotteryId:jiangQiObject.lotteryId];
        }
#ifdef Version_1
        i = (int)lotteryList.count;
#endif
    }
}

- (void)getJiangQiWithJiangQiObject:(JiangQiObject *)jiangQiObject lotteryId:(NSString *)lotteryId
{
    jiangQiObject.latestJiangQi = NO;
    
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    DDLogDebug(@"startTime = %f",startTime);
    [[AppHttpManager sharedManager] jiangQiWithNav:jiangQiObject.kindOfLottery.nav lotteryId:lotteryId Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if (shouldShowNextAlert && self.shouldShowNextJiangQiAlert) {
                 [Utility showErrorWithMessage:@"当期销售已截止，请进入下一期购买。"];
                 DDLogDebug(@"trace-#2848 show 当期销售已截止，请进入下一期购买,method:%@,class:%@",NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             }
             shouldShowNextAlert = NO;
             
             [self setJiangQiAndDateWithJSON:JSON lotteryId:lotteryId];
             
             jiangQiObject.latestJiangQi = YES;
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             
             jiangQiFailTime++;
             if (jiangQiFailTime <= JiangQiFailTimeMax) {
                 double delayInSeconds = 4.0;
                 //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
                 dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                 //推迟两纳秒执行
                 dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                 dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                     if (![UserInfomation sharedInfomation].shouldLoginAgain) {
                         DDLogDebug(@"trace-#2848 getJiangQiWithJiangQiObject after delay,method:%@,class:%@",NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                         [self getJiangQiWithJiangQiObject:jiangQiObject lotteryId:lotteryId];
                     }
                 });
             }
         }
     }];
}

- (void)setJiangQiAndDateWithJSON:(id)JSON lotteryId:(NSString *)lotteryId
{
    JiangQiObject *jiangQiObject = [self getJiangQiObjectWithLotteryId:lotteryId];

    /*获取奖期开始和结束时间*/
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSString *nowtime = [JSON objectForKey:@"nowtime"];
    NSString *endtime = [JSON objectForKey:@"saleend"];
    
    //记录当前奖期号
    jiangQiObject.currentJiangQi = [JSON objectForKey:@"issue"];

    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateJiangQi object:jiangQiObject.currentJiangQi];
    
    //当前时间（开始时间）
    NSDateComponents *nowDateC =[[NSDateComponents alloc]init];
    
    NSString *nowYear = [nowtime substringToIndex:4];
    NSString *nowMonth = [nowtime substringWithRange:NSMakeRange(5,2)];
    NSString *nowDay = [nowtime substringWithRange:NSMakeRange(8, 2)];
    
    NSString *nowHour =[nowtime substringWithRange:NSMakeRange(11, 2)];
    NSString *nowMinent = [nowtime substringWithRange:NSMakeRange(14,2)];
    NSString *nowSencond = [nowtime substringFromIndex:17];
    
    [nowDateC setYear:[nowYear integerValue]];
    [nowDateC setMonth:[nowMonth integerValue]];
    [nowDateC setDay:[nowDay integerValue]];
    [nowDateC setHour:[nowHour integerValue]];
    [nowDateC setMinute:[nowMinent integerValue]];
    [nowDateC setSecond:[nowSencond integerValue]];
    
    NSDate *currentDate =[cal dateFromComponents:nowDateC];
    jiangQiObject.timeOffset = currentDate.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970;
    
    //开奖时间（结束时间）
    NSDateComponents *sleendtime = [[NSDateComponents alloc]init];
    
    NSString *endYear= [endtime substringToIndex:4];
    NSString *endMonth = [endtime substringWithRange:NSMakeRange(5,2)];
    NSString *endDay = [endtime substringWithRange:NSMakeRange(8, 2)];
    
    NSString *endHour =[endtime substringWithRange:NSMakeRange(11, 2)];
    NSString *endMinent = [endtime substringWithRange:NSMakeRange(14,2)];
    NSString *endSencond = [endtime substringFromIndex:17];
    
    [sleendtime setYear:[endYear integerValue]];
    [sleendtime setMonth:[endMonth integerValue]];
    [sleendtime setDay:[endDay integerValue]];
    [sleendtime setHour:[endHour integerValue]];
    [sleendtime setMinute:[endMinent integerValue]];
    [sleendtime setSecond:[endSencond integerValue]];
    
    jiangQiObject.endDate = [cal dateFromComponents:sleendtime];
    
    //进入本地倒计时
    [jiangQiObject.countDownTimer invalidate];
    jiangQiObject.countDownTimer = nil;
    
    jiangQiObject.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCountdownTime:) userInfo:jiangQiObject repeats:YES];
    [jiangQiObject.countDownTimer fire];
    
    [self getKeZhuiHaoJiangQiWithJiangQiObject:jiangQiObject];
}

//倒计时
-(void)showCountdownTime:(NSTimer *)timer
{
    JiangQiObject *jiangQiObject = timer.userInfo;

    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
    timeInterval += jiangQiObject.timeOffset;
    NSDate *serverCurrentDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    if ([jiangQiObject.endDate timeIntervalSinceDate:serverCurrentDate] >= 0)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
        NSDateComponents *d =[cal components:unitFlags fromDate:serverCurrentDate toDate:jiangQiObject.endDate options:0];
        
        NSString *timeString = [NSString stringWithFormat:@"%ld时%ld分%ld秒", (long)[d hour], (long)[d minute], (long)[d second]];
        DDLogDebug(@"奖期倒计时:%@",timeString);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateTime object:timeString];
        jiangQiObject.timeString = timeString;
    }
    else if ([jiangQiObject.endDate timeIntervalSinceDate:serverCurrentDate] <= -2) { //服务端在2秒后才返回新的奖期，所以在超出2秒后客户端再刷新，避免刷新的时候客户端频繁请求
        
        shouldShowNextAlert = YES;
        DDLogDebug(@"trace-#2848 shouldShowNextAlert = YES,method:%@,class:%@",NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        [jiangQiObject.countDownTimer invalidate];
        jiangQiObject.countDownTimer = nil;
        [self currentJiangQiTimeoutWithJiangQiObject:jiangQiObject];
    }
}

//本期截止，本方法可以实现奖期刷新等后续操作
- (void)currentJiangQiTimeoutWithJiangQiObject:(JiangQiObject *)jiangQiObject
{
    [self resetFailCount];
    
    //获取下一期奖期
    DDLogDebug(@"trace-#2848 getJiangQiWithJiangQiObject,method:%@,class:%@",NSStringFromSelector(_cmd),NSStringFromClass([self class]));
    [self getJiangQiWithJiangQiObject:jiangQiObject lotteryId:jiangQiObject.lotteryId];
}

//获取可追号奖期
- (void)getKeZhuiHaoJiangQiWithJiangQiObject:(JiangQiObject *)jiangQiObject
{
    jiangQiObject.latestKeZhuiHaoJiangQi = NO;
    [[AppHttpManager sharedManager] keZhuiHaoJiangQiWithKind:jiangQiObject.kindOfLottery Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if (!jiangQiObject.keZhuiHaoJiangQis) {
                 jiangQiObject.keZhuiHaoJiangQis = [NSMutableArray array];
             }
             else
             {
                 [jiangQiObject.keZhuiHaoJiangQis removeAllObjects];
             }
             
             if ([JSON isKindOfClass:[NSDictionary class]] && [((NSDictionary *)JSON).allKeys containsObject:@"today"]) {
                 id jiangQiObjects = [JSON objectForKey:@"today"];
                 [self processKeZhuiHaoJiangQi:jiangQiObjects jiangQiObject:jiangQiObject];
             }
             if ([JSON isKindOfClass:[NSDictionary class]] && [((NSDictionary *)JSON).allKeys containsObject:@"tomorrow"]) {
                 id jiangQiObjects = [JSON objectForKey:@"tomorrow"];
                 [self processKeZhuiHaoJiangQi:jiangQiObjects jiangQiObject:jiangQiObject];
             }
             
             jiangQiObject.latestKeZhuiHaoJiangQi = YES;
         }
         else
         {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             
             if (jiangQiObject.keZhuiHaoJiangQis) {
                 [jiangQiObject.keZhuiHaoJiangQis removeAllObjects];
             }
             
             keZhuiHaoJiangQiFailTime++;
             if (keZhuiHaoJiangQiFailTime <= JiangQiFailTimeMax) {
                 double delayInSeconds = 4.0;
                 //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
                 dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                 //推迟两纳秒执行
                 dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                 dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                     if (![UserInfomation sharedInfomation].shouldLoginAgain) {
                         [self getKeZhuiHaoJiangQiWithJiangQiObject:jiangQiObject];
                     }
                 });
             }
         }
     }];
}

- (void)processKeZhuiHaoJiangQi:(id)jiangQiObjects jiangQiObject:(JiangQiObject *)jiangQiObject
{
    if (jiangQiObjects) {
        if ([jiangQiObjects isKindOfClass:[NSArray class]]) {
            NSArray *jiangQiAttributes = (NSArray *)jiangQiObjects;
            for (int i = 0; i < jiangQiAttributes.count; ++i)
            {
                id oneObject = [jiangQiAttributes objectAtIndex:i];
                if ([oneObject isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *jiangQiAttribute = (NSDictionary *)oneObject;
                    KeZhuiHaoJiangQiObject *zhjqObj = [[KeZhuiHaoJiangQiObject alloc] initWithAttribute:jiangQiAttribute];
                    [jiangQiObject.keZhuiHaoJiangQis addObject:zhjqObj];
                }
                else
                {
                    DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                }
            }
        }
    }
}
@end
