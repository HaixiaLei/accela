//
//  NSUserDefaultsManager.m
//  JellyBomb
//
//  Created by weststar on 13-11-11.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "NSUserDefaultsManager.h"
#import "EnCodeDeCode.h"
@implementation NSUserDefaultsManager

//加密
+ (NSData *)encode:(NSData*)data
{
    int portId = 10;
    NSMutableData *allData = [[NSMutableData alloc]init];
    NSData *portIdData = [NSData dataWithBytes:&portId length: sizeof(portId)];
    [allData appendData:portIdData];
    [allData appendData:data];
    
    return [EnCodeDeCode binaryEncode:allData];
}

//解密
+ (NSData *)decode:(NSData*)data
{
    return [EnCodeDeCode binaryDecode:data];
}

//数据处理
+ (NSData *)dataWithLongLong:(long long)intNumber
{
    NSData *data = [NSData dataWithBytes:&intNumber length:sizeof(intNumber)];
    return data;
}
+ (NSData *)dataWithInt:(int)intNumber
{
    NSData *data = [NSData dataWithBytes:&intNumber length:sizeof(intNumber)];
    return data;
}
+ (NSData *)NSDataFromNSString:(NSString *)nsstring
{
    NSData *nsdata = [nsstring dataUsingEncoding:NSASCIIStringEncoding];
    return nsdata;
}

+ (long long)longlongWithData:(NSData *)data
{
    long long intNumber;
    [data getBytes:&intNumber length:sizeof(intNumber)];
    return intNumber;
}
+ (int)intWithData:(NSData *)data
{
    int intNumber;
    [data getBytes:&intNumber length:sizeof(intNumber)];
    return intNumber;
}
+ (NSString *)NSStringFromNSData:(NSData *)nsdata
{
    NSString *nsstring = [[NSString alloc] initWithData:nsdata encoding:NSASCIIStringEncoding];
    return nsstring;
}

//Set & Get Methods

+ (void)setPassword:(NSString *)password
{
    if (password) {
        NSData *nsdata = [NSUserDefaultsManager NSDataFromNSString:password];
        nsdata = [NSUserDefaultsManager encode:nsdata];
        
        [[NSUserDefaults standardUserDefaults] setObject:nsdata forKey:kUserPasswordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPasswordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (NSString *)getPassword
{
    NSString *password = nil;
    NSData *nsdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPasswordKey];
    if (nsdata) {
        nsdata = [self decode:nsdata];
        password = [self NSStringFromNSData:nsdata];
    }
    return password;
}


+ (void)setUsername:(NSString *)username
{
    NSData *nsdata = [NSUserDefaultsManager NSDataFromNSString:username];
    nsdata = [NSUserDefaultsManager encode:nsdata];
    
    [[NSUserDefaults standardUserDefaults] setObject:nsdata forKey:kUserUsernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUsername
{
    NSString *username = nil;
    NSData *nsdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserUsernameKey];
    if (nsdata) {
        nsdata = [self decode:nsdata];
        username = [self NSStringFromNSData:nsdata];
    }
    return username;
}
@end
