//
//  Push_iOS_SDK.h
//  Push_iOS_SDK
//
//  Created by Sywine on 4/8/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//


/**
 *  使用方法：首先必须将下方mark为“推送方法”的3个方法放到指定的位置，然后根据需要监听下方2个通知获取消息推送内容；具体参考demo
 */
#define PushNoti_LaunchFromPush @"PushNoti_LaunchFromPush" //用户点击推送消息启动app
#define PushNoti_ReceivePush @"PushNoti_ReceivePush" //收到推送消息


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RequestTimeOutSeconds 10

@interface Push_iOS_SDK : NSObject

#pragma mark - 推送方法，设置app推送的方法（必须添加到AppDelegate相应方法中）
//添加到didFinishLaunchingWithOptions方法中
+(void)PushDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

//添加到didRegisterForRemoteNotificationsWithDeviceToken方法中
+(void)PushDidRegisterForRemoteNotificationsWithDeviceToken:(NSData*)token
                                              encryptString:(NSString *)encryptStr
                                                     Server:(NSString *)serverIP;
//添加到didReceiveRemoteNotification方法中
+(void)PushDidReceiveRemoteNotification:(NSDictionary *)userInfo;

#pragma mark - 获取用户是否允许推送，和允许推送的类型
+(NSDictionary *)PushUserAllowedPushTypes;
@end















