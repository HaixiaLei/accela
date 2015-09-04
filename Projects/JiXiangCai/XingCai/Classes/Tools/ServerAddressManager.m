//
//  ServerAddressManager.m
//  XingCai
//
//  Created by jay on 14-5-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ServerAddressManager.h"

@implementation ServerAddressManager
{
    NSArray *currentServerList;
    NSMutableArray *requests;
    NSMutableArray *requestStatus; //NSNumber,isFinish:YES/NO
}

+ (ServerAddressManager *)sharedManager {
    static ServerAddressManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ServerAddressManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    if (self = [super init])
    {
        currentServerList = [NSArray arrayWithObjects:
                             @"http://mobile.b2tz.com/mobileindex.php",
                             @"http://mobile.b7zz.com/mobileindex.php",
                             @"http://mobile.bzz5.com/mobileindex.php",
                             @"http://mobile.m8w2.com/mobileindex.php",
                             @"http://mobile.muw2.com/mobileindex.php",
                             @"http://mobile.wm8y.com/mobileindex.php",
                             @"http://mobile.mc4z.com/mobileindex.php",
                             @"http://mobile.mp9z.com/mobileindex.php",
                             @"http://mobile.ap8p.com/mobileindex.php",
                             @"http://mobile.a2yd.com/mobileindex.php",
//                             @"http://mobile.jxc666.org/mobileindex.php",//online去掉此行，仅供测试用
                             nil];
        
        requestStatus = [NSMutableArray array];
        for (unsigned i = 0; i < currentServerList.count; ++i) {
            [requestStatus addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return self;
}

//重置request状态
- (void)resetRequestStatus
{
    for (unsigned i = 0; i < requestStatus.count ; ++i) {
        [self setRequstStatus:NO atIndex:i];
    }
}

//设置request状态
- (void)setRequstStatus:(BOOL)isFinish atIndex:(NSInteger)index
{
    if (index < requestStatus.count) {
        [requestStatus replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:isFinish]];
    }
    else
    {
        NSLog(@"数组越界");
    }
}

- (void)getBestServer
{
    if (!requests) {
        requests = [NSMutableArray array];
    }
    else
    {
        [requests removeAllObjects];
    }
    
    [self resetRequestStatus];
    for (unsigned i = 0; i < currentServerList.count; ++i) {
        NSString *urlString = [currentServerList objectAtIndex:i];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        AFJSONRequestOperation *requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self setRequstStatus:YES atIndex:i];
            [self setBestServer:urlString];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            [self setRequstStatus:YES atIndex:i];
            [self checkIfFinish];
        }];
        [requests addObject:requestOperation];
    }
    
    [requests makeObjectsPerformSelector:@selector(start)];
}

- (void)setBestServer:(NSString *)address
{
    [requests makeObjectsPerformSelector:@selector(cancel)];
    
    NSLog(@"bestServer（最佳服务器地址）:%@",address);
    self.appAPIBaseURLString = address;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetVersion object:nil];
    
    [self hideProgressHUD];
}
- (void)checkIfFinish
{
    BOOL allFinished = YES;
    for (NSNumber *isFinish in requestStatus) {
        if (!isFinish.boolValue) {
            allFinished = NO;
            break;
        }
    }
    
    if (allFinished && !self.appAPIBaseURLString) {
        [Utility showErrorWithMessage:@"无法获取可用服务器地址" delegate:self];
        [self hideProgressHUD];
    }
}

- (void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismiss];
    [self showProgressHUD];
    [self getBestServer];
}

- (void)showProgressHUD
{
    UIViewController *loginVC = self.loginVC;
    if (loginVC) {
        [MBProgressHUD showHUDAddedTo:loginVC.view animated:YES];
    }
}

- (void)hideProgressHUD
{
    UIViewController *loginVC = self.loginVC;
    if (loginVC) {
        [MBProgressHUD hideAllHUDsForView:loginVC.view animated:YES];
    }
}
@end
