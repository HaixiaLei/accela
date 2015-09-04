//
//  AppAPITest.m
//  JiXiangCai
//
//  Created by jay on 14-9-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AppAPITest.h"
#import "AFAppAPIClient.h"

@implementation AppAPITest

+ (void)start
{
    AppAPITest *appAPITest = [[AppAPITest alloc] init];
    [appAPITest beginTest];
}

- (void)beginTest
{
//    [self test1];
}

//2.1.1.	登陆
- (void)test1
{
    //账号 sykee002
    //登录密码 123qwe
    //资金密码 sykee8965
    [[AFAppAPIClient sharedClient] login_with_account:@"sykee002" password:@"123qwe" logintype:@"login" block:^(id JSON, NSError *error) {
        [self test5];
    }];
}

//2.1.2.	退出
- (void)test2
{
    [[AFAppAPIClient sharedClient] logout_with_block:^(id JSON, NSError *error){
        
    }];
}

- (void)test3
{
    [[AFAppAPIClient sharedClient] historyOfTheWinningNumbers_with_lotteryId:@"1" type:@"1" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test4
{
    [[AFAppAPIClient sharedClient] getBalance_with_block:^(id JSON, NSError *error){
        
    }];
}

- (void)test5
{
    [[AFAppAPIClient sharedClient] getMessageList_with_maxid:@"2803968" count:@"200" block:^(id JSON, NSError *error){
        
    }];
}

//- (void)test6
//{
//    [[AFAppAPIClient sharedClient] getMessageDetail_with_noticeId:@"2803968" block:^(id JSON, NSError *error){
//        
//    }];
//}

- (void)test7
{
    [[AFAppAPIClient sharedClient] getNoticeList_with_block:^(id JSON, NSError *error){
        
    }];
}

//- (void)test8
//{
//    //取消此接口，NoticeList接口加入url字段，webview直接load
//    [[AFAppAPIClient sharedClient] getNoticeDetail_with_noticeId:@"80" block:^(id JSON, NSError *error){
//        
//    }];
//}

- (void)test9
{
    [[AFAppAPIClient sharedClient] historyOfTheWinningNumbers_with_lotteryId:@"1" type:@"2" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test10
{
    [[AFAppAPIClient sharedClient] traceRecordList_with_lotteryid:@"1" startTime:@"2011-03-07 02:20:00" endTime:@"2015-03-08 02:20:00" maxid:@"0" count:@"200" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test11
{
    [[AFAppAPIClient sharedClient] betRecordList_with_lotteryid:@"1" startTime:@"2011-03-07 02:20:00" endTime:@"2015-03-08 02:20:00" maxid:@"17133056" count:@"200" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test12
{
    [[AFAppAPIClient sharedClient] cancelBet_with_projectId:@"D20141017-030VBHBDDIBCK" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test13
{
    [[AFAppAPIClient sharedClient] cancelTrace_with_taskId:@"T20141021-053VBBJACBFKL" detailId:@"2319,2320" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test17
{
    [[AFAppAPIClient sharedClient] findPassword_with_newPassword:@"123qwe" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test18
{
    [[AFAppAPIClient sharedClient] getActivityList_with_screenType:ScreenType3p5 block:^(id JSON, NSError *error){
        
    }];
}

- (void)test19
{
    [[AFAppAPIClient sharedClient] getMessageAmount_with_block:^(id JSON, NSError *error){
        
    }];
}

- (void)test20
{
    [[AFAppAPIClient sharedClient] betDetail_with_projectid:@"D20141008-062VBHBDDAFGK" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test21
{
    [[AFAppAPIClient sharedClient] traceDetail_with_taskId:@"T20141021-053VBBJACBFKL" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test22
{
    [[AFAppAPIClient sharedClient] feedback_with_content:@"good" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test23
{
    [[AFAppAPIClient sharedClient] changePassword_with_oldPassword:@"qwe123" newPassword:@"123qwe" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test24
{
    [[AFAppAPIClient sharedClient] playRules_with_type:@"ssc" block:^(id JSON, NSError *error){
       
    }];
}

- (void)test25
{
    [[AFAppAPIClient sharedClient] currentIssue_with_nav:@"ssc" lotteryid:@"1" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test26
{
    [[AFAppAPIClient sharedClient] traceIssue_with_nav:@"ssc" block:^(id JSON, NSError *error){
        
    }];
}

- (void)test28
{
    [[AFAppAPIClient sharedClient] version_with_block:^(id JSON, NSError *error){
        
    }];
}
@end
