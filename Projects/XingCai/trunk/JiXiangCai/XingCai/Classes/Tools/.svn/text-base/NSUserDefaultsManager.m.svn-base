//
//  NSUserDefaultsManager.m
//  JellyBomb
//
//  Created by weststar on 13-11-11.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "NSUserDefaultsManager.h"
#import "EnCodeDeCode.h"

#define kUserUsernameKey               @"kUserUsernameKey"
#define kUserPasswordKey               @"kUserPasswordKey"
#define kUserGuestruePasswordKey               @"kUserGuestruePasswordKey"

@implementation NSUserDefaultsManager

+ (NSString *)passwordKeyForAccount:(NSString *)account
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",kUserPasswordKey,account];
    return key;
}

//Set & Get Methods
+ (void)setPassword:(NSString *)password forAccount:(NSString *)account
{
    if (account) {
        NSString *key = [self passwordKeyForAccount:account];
        if (password) {
            NSData *nsdata = [EnCodeDeCode NSDataFromNSString:password];
            nsdata = [EnCodeDeCode encode:nsdata];
            
            [[NSUserDefaults standardUserDefaults] setObject:nsdata forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+ (NSString *)passwordForAccount:(NSString *)account
{
    NSString *password = nil;
    if (!account) {
        return password;
    }
    
    NSString *key = [self passwordKeyForAccount:account];
    NSData *nsdata = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (nsdata) {
        nsdata = [EnCodeDeCode decode:nsdata];
        password = [EnCodeDeCode NSStringFromNSData:nsdata];
    }
    return password;
}

+ (void)setUsername:(NSString *)username
{
    NSData *nsdata = [EnCodeDeCode NSDataFromNSString:username];
    nsdata = [EnCodeDeCode encode:nsdata];
    
    [[NSUserDefaults standardUserDefaults] setObject:nsdata forKey:kUserUsernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)username
{
    NSString *username = nil;
    NSData *nsdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserUsernameKey];
    if (nsdata) {
        nsdata = [EnCodeDeCode decode:nsdata];
        username = [EnCodeDeCode NSStringFromNSData:nsdata];
    }
    return username;
}

+ (NSString *)gesturePasswordKeyForAccount:(NSString *)account
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",kUserGuestruePasswordKey,account];
    return key;
}

+ (void)setGesturePassword:(NSString *)password forAccount:(NSString *)account
{
    if (account) {
        NSString *key = [self gesturePasswordKeyForAccount:account];
        if (password) {
            NSData *nsdata = [EnCodeDeCode NSDataFromNSString:password];
            nsdata = [EnCodeDeCode encode:nsdata];
            
            [[NSUserDefaults standardUserDefaults] setObject:nsdata forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+ (NSString *)gesturePasswordForAccount:(NSString *)account
{
    NSString *password = nil;
    if (!account) {
        return password;
    }
    
    NSString *key = [self gesturePasswordKeyForAccount:account];
    NSData *nsdata = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (nsdata) {
        nsdata = [EnCodeDeCode decode:nsdata];
        password = [EnCodeDeCode NSStringFromNSData:nsdata];
    }
    return password;
}
@end
