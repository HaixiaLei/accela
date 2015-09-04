//
//  AppDelegate.m
//  Pushdemo
//
//  Created by Luke on 15/3/24.
//  Copyright (c) 2015年 Luke. All rights reserved.
//

#define ServerIP @"http://192.168.20.43:7010/pushService/create/device/ios"
#define EncryptString @"8UPp0KE8sq73zVP370vko7C39403rtK1YwX40Td6irH216036H27Eb12792t"

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 在下面3个方法中插入推送的三个方法，在需要的类对推送的key进行监听
//******************************************//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册监听用户点击推送消息启动app的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchFromPushMessage:) name:PushNoti_LaunchFromPush object:nil];
    
    //添加推送方法
    [Push_iOS_SDK PushDidFinishLaunchingWithOptions:launchOptions];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //添加推送方法
    [Push_iOS_SDK PushDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken
                                                         encryptString:EncryptString
                                                                Server:ServerIP];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //添加推送方法
    [Push_iOS_SDK PushDidReceiveRemoteNotification:userInfo];
}
//******************************************//

#pragma mark - other method
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"获取APNS令牌失败,错误信息:%@", error_str);
}

#pragma mark - echo method
-(void)launchFromPushMessage:(NSNotification *)noti{
    NSString *s = [noti.object JSONString];
    [[NSUserDefaults standardUserDefaults] setObject:s forKey:@"userInfo"];
}

@end


















