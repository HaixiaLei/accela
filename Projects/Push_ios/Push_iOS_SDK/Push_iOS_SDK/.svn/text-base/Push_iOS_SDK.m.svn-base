//
//  Push_iOS_SDK.m
//  Push_iOS_SDK
//
//  Created by Sywine on 4/8/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import "Push_iOS_SDK.h"
#import <UIKit/UIKit.h>
#import "CommonCrypto/CommonDigest.h"

@implementation Push_iOS_SDK

#pragma mark - apns methos
+(void)PushDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]){
        //iOS8
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    if (launchOptions) {
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:PushNoti_LaunchFromPush object:userInfo];
        }
    }
}

+(void)PushDidRegisterForRemoteNotificationsWithDeviceToken:(NSData*)token
                                              encryptString:(NSString *)encryptStr
                                                     Server:(NSString *)serverIP;
{
    //获取应用包名称
    NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
    NSString *bundleName = [infoDictionary objectForKey:@"CFBundleName"];
    
    //把token转为字符串
    NSString *tokenStr = [NSString stringWithFormat:@"%@",token];
    tokenStr = [tokenStr substringWithRange:NSMakeRange(1, tokenStr.length-2)];//去掉两端尖括号
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉空格
    NSLog(@"tokenStr=%@",tokenStr);
    
    //拼接hmac
    NSString *hmac = [NSString stringWithFormat:@"%@%@%@",tokenStr,bundleName,encryptStr];
    //hmac进行md5加密
    hmac = [self md5:hmac];
    
    //构建字典，
    NSString *temp = [NSString stringWithFormat:@"{\"token\":\"%@\",\"package\":\"%@\",\"hmac\":\"%@\"}",tokenStr,bundleName,hmac];
    temp = [@"params=" stringByAppendingString:temp];//设置参数格式
    
    NSData *postData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *requestURL = [NSURL URLWithString:[serverIP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:RequestTimeOutSeconds];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];

    //新创建一个线程，避免堵塞主线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (data == nil) {
            //发送token失败
            if (error) {
                NSLog(@"发送token失败:%@",error.localizedDescription);
            }
        }else {
//            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"response: %@", response);
        }
    });
}

+(void)PushDidReceiveRemoteNotification:(NSDictionary *)userInfo{
     [[NSNotificationCenter defaultCenter] postNotificationName:PushNoti_ReceivePush object:userInfo];
}

#pragma mark -
+(NSDictionary *)PushUserAllowedPushTypes{
    NSInteger type;
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        //iOS8
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        type = settings.types;
        
    }
    else{
        type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
    
    NSString *typeStr = [NSString stringWithFormat:@"%li",type];
    NSMutableDictionary *typesDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"code":typeStr}];
    
    NSMutableArray *typesArray = [NSMutableArray array];
    if (type == UIRemoteNotificationTypeNone) {
        [typesArray addObject:@"UIRemoteNotificationTypeNone"];
    }
    if(type & UIRemoteNotificationTypeBadge){
        [typesArray addObject:@"UIRemoteNotificationTypeBadge"];
    }
    if(type & UIRemoteNotificationTypeSound){
        [typesArray addObject:@"UIRemoteNotificationTypeSound"];
    }
    if(type & UIRemoteNotificationTypeAlert){
        [typesArray addObject:@"UIRemoteNotificationTypeAlert"];
    }
    if(type & UIRemoteNotificationTypeNewsstandContentAvailability){
        [typesArray addObject:@"UIRemoteNotificationTypeNewsstandContentAvailability"];
    }
    [typesDic setObject:typesArray forKey:@"types"];
    return typesDic;
}


#pragma mark - MD5
+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

@end
