//
//  HYJSocketEnCodeDeCode.h
//  聊天
//
//  Created by weststar on 13-2-7.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnCodeDeCode : NSObject

//加密
+ (NSData *)encode:(NSData*)data;
//解密
+ (NSData *)decode:(NSData*)data;

//数据处理 id -> NSData
+ (NSData *)dataWithLongLong:(long long)intNumber;
+ (NSData *)dataWithInt:(int)intNumber;
+ (NSData *)NSDataFromNSString:(NSString *)nsstring;

//数据处理 NSData -> id
+ (long long)longlongWithData:(NSData *)data;
+ (int)intWithData:(NSData *)data;
+ (NSString *)NSStringFromNSData:(NSData *)nsdata;

//二进制加密
+ (NSData*) binaryEncode:(NSData *)actionContent;
//二进制解密
+ (NSData*) binaryDecode:(NSData *)inputData;
@end
