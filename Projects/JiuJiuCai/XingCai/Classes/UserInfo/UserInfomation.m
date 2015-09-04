//
//  UserInfomation.m
//  News
//
//  Created by jay on 13-7-23.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "UserInfomation.h"
#import "AFAppAPIClient.h"
@implementation UserInfomation

+ (UserInfomation *)sharedInfomation {
    static UserInfomation *_sharedInfomation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInfomation = [[UserInfomation alloc] init];
    });
    
    return _sharedInfomation;
}

- (id)init
{
    if (self = [super init]) {
        self.nickName = @"";
        self.modeIndex = 0; //默认首个模式，一般是元
        self.shouldLoginAgain = YES;
        self.loginVCVisible = NO;
//        self.latestVersionGot = YES;
    }
    return self;
}

//- (void)setVersion:(NSString *)version url:(NSString *)url
//{
//    self.version = version;
//    self.download = url;
//    
//    //app版本号
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    
//    DDLogInfo(@"app_version:%@,latest_version:%@",app_Version,version);
//    
//    int result = [version compare:app_Version];
//    if (result > 0) {
//        DDLogWarn(@"need update");
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:@"是否去下载?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
//        [alertView show];
//    }
//    
//}
//#pragma mark - alertView delegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.download]];
//    }
//}
@end
