//
//  NSUserDefaultsManager.h
//  JellyBomb
//
//  Created by weststar on 13-11-11.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultsManager : NSObject

+ (NSString *)passwordForAccount:(NSString *)account;
+ (void)setPassword:(NSString *)password forAccount:(NSString *)account;

+ (void)setUsername:(NSString *)username;
+ (NSString *)username;

+ (void)setGesturePassword:(NSString *)password forAccount:(NSString *)account;
+ (NSString *)gesturePasswordForAccount:(NSString *)account;
@end
