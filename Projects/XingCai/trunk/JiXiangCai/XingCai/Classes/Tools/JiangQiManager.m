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
#import "KindOfLottery.h"

#define JiangQiFailTimeMax 1

@implementation JiangQiManager
{
    NSMutableDictionary *allJiangQiDictionary; //所有奖期对象
    
    BOOL shouldShowNextAlert; //本期截止，进入下一期，显示弹框标志
    
    int jiangQiFailTime;    //奖期获取失败计数
    int keZhuiHaoJiangQiFailTime;  //可追号奖期获取失败计数
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

//更新所有奖期
- (void)updateAllJiangQi
{
    [self resetFailCount];
    
    NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
    
    for (int i = 0; i < lotteryList.count; ++i) {
        KindOfLottery *kindOfLottery = [lotteryList objectAtIndex:i];
        [self updateJiangQiWithKindOfLottery:kindOfLottery];
    }
}

//停止所有奖期倒计时
- (void)stopAllCountDownTimer
{
    NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
    
    for (int i = 0; i < lotteryList.count; ++i) {
        KindOfLottery *kindOfLottery = [lotteryList objectAtIndex:i];
        
        [kindOfLottery.countDownTimer invalidate];
        kindOfLottery.countDownTimer = nil;
        
        //清空奖期和投注截止时间
        kindOfLottery.timeString = @"暂无";
        kindOfLottery.currentJiangQi = @"暂无";
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateTime object:kindOfLottery];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateJiangQi object:kindOfLottery];
    }
}

//更新某个彩种的奖期
- (void)updateJiangQiWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    kindOfLottery.latestJiangQi = NO;

    [[AFAppAPIClient sharedClient] currentIssue_with_nav:kindOfLottery.lotteryName lotteryid:kindOfLottery.lotteryId block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if (shouldShowNextAlert && self.shouldShowNextJiangQiAlert && [self.kindOfLottery.lotteryId isEqualToString:kindOfLottery.lotteryId]) {
                 [Utility showErrorWithMessage:@"当期销售已截止，请确认进入下一期购买！"];
             }
             shouldShowNextAlert = NO;
             
             if (JSON && [JSON objectForKey:@"result"]) {
                 NSDictionary *result = [JSON objectForKey:@"result"];
                 [self setJiangQiAndDateWithJSON:result kindOfLottery:kindOfLottery];
                 
                 kindOfLottery.latestJiangQi = YES;
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             
             [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJiangQiUpdateFinished object:error];
             
             jiangQiFailTime++;
             if (jiangQiFailTime <= JiangQiFailTimeMax) {
                 double delayInSeconds = 4.0;
                 //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
                 dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                 //推迟两纳秒执行
                 dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                 dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                     if (![UserInfomation sharedInfomation].shouldLoginAgain) {
                         [self updateJiangQiWithKindOfLottery:kindOfLottery];
                     }
                 });
             }
         }
     }];
}

//设置奖期倒计时
- (void)setJiangQiAndDateWithJSON:(id)JSON kindOfLottery:(KindOfLottery *)kindOfLottery
{
    /*获取奖期开始和结束时间*/
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSString *nowtime = [JSON objectForKey:@"nowtime"];
    NSString *endtime = [JSON objectForKey:@"saleend"];
    
    //记录当前奖期号
    kindOfLottery.currentJiangQi = [JSON objectForKey:@"issue"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateJiangQi object:kindOfLottery];
    
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
    kindOfLottery.timeOffset = currentDate.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970;
    
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
    
    kindOfLottery.endDate = [cal dateFromComponents:sleendtime];
    
    //进入本地倒计时
    [kindOfLottery.countDownTimer invalidate];
    kindOfLottery.countDownTimer = nil;
    
    kindOfLottery.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCountdownTime:) userInfo:kindOfLottery repeats:YES];
    [kindOfLottery.countDownTimer fire];
    
    [self getKeZhuiHaoJiangQiWithKindOfLottery:kindOfLottery];
}

//获取可追号奖期
- (void)getKeZhuiHaoJiangQiWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    kindOfLottery.latestKeZhuiHaoJiangQi = NO;
    [[AFAppAPIClient sharedClient] traceIssue_with_nav:kindOfLottery.lotteryName block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if (!kindOfLottery.keZhuiHaoJiangQis) {
                 kindOfLottery.keZhuiHaoJiangQis = [NSMutableArray array];
             }
             else
             {
                 [kindOfLottery.keZhuiHaoJiangQis removeAllObjects];
             }
             
             if ([JSON isKindOfClass:[NSDictionary class]] && [((NSDictionary *)JSON).allKeys containsObject:@"today"]) {
                 id jiangQiObjects = [JSON objectForKey:@"today"];
                 [self processKeZhuiHaoJiangQi:jiangQiObjects kindOfLottery:kindOfLottery];
             }
             if ([JSON isKindOfClass:[NSDictionary class]] && [((NSDictionary *)JSON).allKeys containsObject:@"tomorrow"]) {
                 id jiangQiObjects = [JSON objectForKey:@"tomorrow"];
                 [self processKeZhuiHaoJiangQi:jiangQiObjects kindOfLottery:kindOfLottery];
             }
             
             kindOfLottery.latestKeZhuiHaoJiangQi = YES;
             
             [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJiangQiUpdateFinished object:kindOfLottery];
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             
             [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJiangQiUpdateFinished object:error];
             
             if (kindOfLottery.keZhuiHaoJiangQis) {
                 [kindOfLottery.keZhuiHaoJiangQis removeAllObjects];
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
                         [self getKeZhuiHaoJiangQiWithKindOfLottery:kindOfLottery];
                     }
                 });
             }
         }
     }];
}

//处理追号奖期
- (void)processKeZhuiHaoJiangQi:(id)jiangQiObjects kindOfLottery:(KindOfLottery *)kindOfLottery
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
                    [kindOfLottery.keZhuiHaoJiangQis addObject:zhjqObj];
                }
                else
                {
                    DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                }
            }
        }
    }
}

//倒计时
-(void)showCountdownTime:(NSTimer *)timer
{
    KindOfLottery *kindOfLottery = timer.userInfo;
    
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
    timeInterval += kindOfLottery.timeOffset;
    NSDate *serverCurrentDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    if ([kindOfLottery.endDate timeIntervalSinceDate:serverCurrentDate] >= 0)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
        NSDateComponents *d =[cal components:unitFlags fromDate:serverCurrentDate toDate:kindOfLottery.endDate options:0];
        
        NSString *timeString = [NSString stringWithFormat:@"%ld时%ld分%ld秒", (long)[d hour], (long)[d minute], (long)[d second]];
        DDLogDebug(@"%@奖期倒计时:%@",kindOfLottery.lotteryName,timeString);
        
        timeString = [NSString stringWithFormat:@"%ld_%ld_%ld", (long)[d hour], (long)[d minute], (long)[d second]];
        kindOfLottery.timeString = timeString;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateTime object:kindOfLottery];
        
    }
    else if ([kindOfLottery.endDate timeIntervalSinceDate:serverCurrentDate] <= -2) { //服务端在2秒后才返回新的奖期，所以在超出2秒后客户端再刷新，避免刷新的时候客户端频繁请求
        shouldShowNextAlert = YES;
        [kindOfLottery.countDownTimer invalidate];
        kindOfLottery.countDownTimer = nil;
        [self currentJiangQiTimeoutWithKindOfLottery:kindOfLottery];
    }
}

//本期截止，奖期刷新
- (void)currentJiangQiTimeoutWithKindOfLottery:(KindOfLottery *)kindOfLottery
{
    [self resetFailCount];
    
    //获取下一期奖期
    [self updateJiangQiWithKindOfLottery:kindOfLottery];
}
@end
