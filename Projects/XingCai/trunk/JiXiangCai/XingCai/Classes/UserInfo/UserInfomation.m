//
//  UserInfomation.m
//  News
//
//  Created by jay on 13-7-23.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "UserInfomation.h"
#import "NSUserDefaultsManager.h"

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
    }
    return self;
}

- (void)setAccount:(NSString *)account
{
    [NSUserDefaultsManager setUsername:account];
}

- (NSString *)account
{
    return [NSUserDefaultsManager username];
}

- (void)setPassword:(NSString *)password
{
    [NSUserDefaultsManager setPassword:password forAccount:self.account];
}

- (NSString *)password
{
    return [NSUserDefaultsManager passwordForAccount:self.account];
}

- (void)setGesturePassword:(NSString *)gesturePassword
{
    [NSUserDefaultsManager setGesturePassword:gesturePassword forAccount:self.account];
}

- (NSString *)gesturePassword
{
    return [NSUserDefaultsManager gesturePasswordForAccount:self.account];
}

@end
