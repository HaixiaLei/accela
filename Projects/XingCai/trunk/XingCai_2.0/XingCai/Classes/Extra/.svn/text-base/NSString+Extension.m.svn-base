//
//  NSString+Extension.m
//  ECTester
//
//  Created by Feather Chan on 13-2-17.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (BOOL) isEmail
{
	NSError* error = nil;
	NSRegularExpression* expr = [NSRegularExpression
                                 regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                                 options:0
                                 error:&error];
	NSRange range = NSMakeRange(0, self.length);
	NSRange matchRange = [expr rangeOfFirstMatchInString:self options:0 range:range];
	return NSEqualRanges(range, matchRange);
}

- (BOOL) isEmpty
{
    return ([self trim].length == 0);
}

- (NSString *) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) MD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)has:(NSString *)pattern
{
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                          options:0
                                                                            error:nil];
    return ([exp numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)]>0);
}

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
//    while ((r = [s rangeOfString:@"<+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    while ((r = [s rangeOfString:@"&nbsp;" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@" "];
    
    while ((r = [s rangeOfString:@"&nbsp" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@" "];
    
    return s;
}

+(NSString *)changeText:(NSString *)content
{
    NSMutableString *newStr=[content mutableCopy];
    while ([newStr rangeOfString:@"\n"].location!=NSNotFound) {
        
        [newStr replaceCharactersInRange:NSMakeRange([newStr rangeOfString:@"\n"].location, [newStr rangeOfString:@"\n"].length) withString:@"<br>"];
        
    }
    return newStr;
}

+(NSString *)getStringByStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *format1=[[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *workStartTime=[format1 dateFromString:startTime];
    
    NSDateFormatter *format2=[[NSDateFormatter alloc]init];
    [format2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *wordEndTime=[format2 dateFromString:endTime];
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    NSDateComponents *components1=[calendar components:NSHourCalendarUnit fromDate:workStartTime];
    
    NSDateComponents *components2=[calendar components:NSHourCalendarUnit fromDate:wordEndTime];
    NSString *startStr=nil;
    NSString *endStr=nil;
    if ([components1 hour]>=12) {
        startStr=[NSString stringWithFormat:@"%d:00",[components1 hour]];
    }else{
        if([components1 hour]<10){
            startStr=[NSString stringWithFormat:@"0%d:00",[components1 hour]];
        }else{
            startStr=[NSString stringWithFormat:@"%d:00",[components1 hour]];
        }
        
    }
    if ([components2 hour]>=12) {
        endStr=[NSString stringWithFormat:@"%d:00",[components2 hour]];
    }else{
        if ([components2 hour]<10) {
            endStr=[NSString stringWithFormat:@"0%d:00",[components2 hour]];
        }else{
            endStr=[NSString stringWithFormat:@"%d:00",[components2 hour]];
        }
        
    }
    
    return [NSString stringWithFormat:@"%@-%@",startStr,endStr];
    
}
+(CGFloat)getContentHeight:(NSString *)contentStr
{
    CGFloat height=0.0f;
    if (IOS_VERSION>=7) {
        height=[contentStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    else {
        height=[contentStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    NSLog(@">>>content:%@,height:%f",contentStr,height);
    return height;
}
+(CGSize)getContentSize:(NSString *)contentStr andFontSize:(NSInteger)size andWidth:(CGFloat)w andHeight:(CGFloat)h
{

  
       return  [contentStr sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(w, h) lineBreakMode:NSLineBreakByWordWrapping];
 

}
+(CGFloat)getContentHeightShortCell:(NSString *)contentStr
{
    CGFloat height=0.0f;
    NSLog(@"%@",contentStr);
    if (IOS_VERSION>=7) {
        height=[contentStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    else {
        height=[contentStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    NSLog(@">>>content:%@,height:%f",contentStr,height);
    return height;
}
+(NSString *)combinateArrayToString:(NSArray *)array byString:(NSString *)str
{
    NSString *string;
    if (array.count>0) {
        string=[array componentsJoinedByString:str];
    }
    return string;
}
+(NSString *)getDateByString:(NSString *)string
{
    NSString *year = [string substringToIndex:4];
    NSString *MM = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *dd = [string substringWithRange:NSMakeRange(6, 2)];
    return  [[[[year stringByAppendingString:@"-"] stringByAppendingString:MM] stringByAppendingString:@"-"] stringByAppendingString:dd];
}
+(NSString *)getSubStringInString:(NSString*)string atIndex:(NSInteger)index length:(NSInteger)length
{
    return [string substringWithRange:NSMakeRange(index, length)];
    
}
@end
