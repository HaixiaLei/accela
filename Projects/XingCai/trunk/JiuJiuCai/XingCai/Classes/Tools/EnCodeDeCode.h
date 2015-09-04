//
//  HYJSocketEnCodeDeCode.h
//  聊天
//
//  Created by weststar on 13-2-7.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnCodeDeCode : NSObject

+ (NSData*) binaryEncode:(NSData *)actionContent;
+ (NSData*) binaryDecode:(NSData *)inputData;
@end
