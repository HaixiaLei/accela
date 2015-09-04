//
//  NSUserDefaultsManager.h
//  JellyBomb
//
//  Created by weststar on 13-11-11.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserUsernameKey               @"kUserUsernameKey"
#define kUserPasswordKey               @"kUserPasswordKey"
#define KNotFind -1

@interface NSUserDefaultsManager : NSObject

//加密
+ (NSData *)encode:(NSData*)data;
//解密
+ (NSData *)decode:(NSData*)data;

//数据处理
+ (NSData *)dataWithLongLong:(long long)intNumber;
+ (NSData *)dataWithInt:(int)intNumber;
+ (long long)longlongWithData:(NSData *)data;
+ (int)intWithData:(NSData *)data;

+ (void)setPassword:(NSString *)password;
+ (NSString *)getPassword;

+ (void)setUsername:(NSString *)username;
+ (NSString *)getUsername;
@end
