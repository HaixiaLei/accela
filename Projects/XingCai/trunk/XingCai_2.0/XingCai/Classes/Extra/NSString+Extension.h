//
//  NSString+Extension.h
//  ECTester
//
//  Created by Feather Chan on 13-2-17.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (BOOL) isEmail;
- (BOOL) isEmpty;

- (NSString *) trim;
- (NSString *) MD5;

- (BOOL)has:(NSString *)pattern;

-(NSString *) stringByStrippingHTML;
+(NSString *)changeText:(NSString *)content;
+(NSString *)getStringByStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+(NSString *)combinateArrayToString:(NSArray *)array byString:(NSString *)str;
+(CGFloat)getContentHeight:(NSString *)contentStr;
+(CGFloat)getContentHeightShortCell:(NSString *)contentStr;
+(CGSize)getContentSize:(NSString *)contentStr andFontSize:(NSInteger)size andWidth:(CGFloat)w andHeight:(CGFloat)h;
+(NSString *)getDateByString:(NSString *)string;
+(NSString *)getSubStringInString:(NSString*)string atIndex:(NSInteger)index length:(NSInteger)length;
@end
