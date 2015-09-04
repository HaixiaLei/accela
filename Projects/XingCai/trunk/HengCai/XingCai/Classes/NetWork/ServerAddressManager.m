//
//  ServerAddressManager.m
//  XingCai
//
//  Created by jay on 14-5-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ServerAddressManager.h"
#import "NSUserDefaultsManager.h"

@implementation ServerAddressManager
{
    NSArray *serverAddressSaveList;
    
    NSArray *currentServerList;
    NSMutableArray *requests;
    
    unsigned saveListIndex;
    
    unsigned long failedCountMax;
    unsigned failedCount;
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
        serverAddressSaveList = [NSArray arrayWithObjects:
                                                            @"http://0310pipe.com/hc_ol_list.data",
                                                            @"http://0514rjw.com/hc_ol_list.data",
                                                            @"http://0515sd.com/hc_ol_list.data",
                                                            @"http://0536ol.com/hc_ol_list.data",
                                                            @"http://0817zc.com/hc_ol_list.data",
                                                            nil];
        saveListIndex = 0;
        failedCountMax = serverAddressSaveList.count * 3;
        failedCount = 0;
    }
    return self;
}

- (void)saveAddressListToFile
{
    NSArray *serverAddressList = [NSArray arrayWithObjects:@"http://www.zx9898.com:80/feed/",
                                                            @"http://www.xxg88.com:80/feed/",
                                                            @"http://www.nc580.com:8080/feed/",
                                                            @"http://www.hxj1.com:8080/feed/",
                                                            @"http://www.hengli88.com:8080/feed/",
                                                            nil];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docDir stringByAppendingPathComponent:@"list.data"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:serverAddressList];
    NSLog(@"1length:%lu",(unsigned long)data.length);
    data = [NSUserDefaultsManager encode:data];
    NSLog(@"2length:%lu",(unsigned long)data.length);
    [data writeToFile:path atomically:YES];
}

- (void)getAddressList
{
    if (failedCount >= failedCountMax) {
        failedCount = 0;
        
        [self hideProgressHUD];
        [Utility showErrorWithMessage:@"无法获取可用服务器地址" delegate:self];
    }
    else
    {
        if (saveListIndex >= serverAddressSaveList.count) {
            saveListIndex = 0;
        }
        
        NSString *urlString = [serverAddressSaveList objectAtIndex:saveListIndex];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSLog(@"url:%@",urlString);
                NSData *data = (NSData *)responseObject;
                NSLog(@"row data length:%lu",(unsigned long)data.length);
                data = [NSUserDefaultsManager decode:data];
                NSLog(@"real data length:%lu",(unsigned long)data.length);
                NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                NSLog(@"serverAddressList=%@",array);
                currentServerList = array;
                [self getBestServer];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            failedCount++;
            [self getAddressList];
        }];
        [requestOperation start];
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
    
    for (unsigned i = 0; i < currentServerList.count; ++i) {
        NSString *urlString = [currentServerList objectAtIndex:i];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        AFJSONRequestOperation *requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self setBestServer:urlString];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            [self checkIfFinish];
        }];
        [requests addObject:requestOperation];
        [requestOperation start];
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
    for (AFJSONRequestOperation *operate in requests) {
        if (!operate.isFinished) {
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
    [self showProgressHUD];
    [self getAddressList];
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
