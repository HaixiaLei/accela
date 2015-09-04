//
//  Utility.m
//  News
//
//  Created by jay on 13-7-22.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <objc/runtime.h>
#import "Utility.h"
#import "UserInfomation.h"
#import "AFAppAPIClient.h"
#import "AppAlertView.h"
#import <QuartzCore/QuartzCore.h>

@implementation Utility

+ (BOOL)containAppAlertViewWithMessage:(NSString *)message
{
    BOOL findOne = NO;
    
    NSArray *alertViews = [AppAlertView allAlertViews];
    for (AppAlertView *alertView in alertViews) {
        if ([alertView.message isEqualToString:message]) {
            findOne = YES;
            break;
        }
    }
    
    return findOne;
}
+ (AppAlertView *)showErrorWithMessage:(NSString *)message
{
    return [Utility showErrorWithMessage:message delegate:nil];
}

+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate
{
    return [Utility showErrorWithMessage:message delegate:delegate tag:0];
}

+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
{
    return [Utility showErrorWithMessage:message delegate:delegate tag:tag duplicationPrevent:YES];
}

+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag duplicationPrevent:(BOOL)duplicationPrevent
{
    return [Utility showErrorWithMessage:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil tag:tag duplicationPrevent:duplicationPrevent];
}

+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle tag:(NSInteger)tag duplicationPrevent:(BOOL)duplicationPrevent
{
    return [Utility showErrorWithTittle:@"提示" message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle tag:tag duplicationPrevent:duplicationPrevent];
}

+ (AppAlertView *)showErrorWithTittle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle tag:(NSInteger)tag duplicationPrevent:(BOOL)duplicationPrevent
{
    if ([message isKindOfClass:[NSString class]]) {
        //防止重复显示相同message的alertView
        BOOL shouldShow = YES;
        
        if (duplicationPrevent) {
            shouldShow = ![self containAppAlertViewWithMessage:message];
        }
        
        if (shouldShow) {
            AppAlertView *alertView = [[AppAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle,nil];
            alertView.tag = tag;
            [alertView show];
            
            return alertView;
        }
    }
    return nil;
}

//+ (BOOL)isAlertViewShowing
//{
//    for (UIWindow* window in [UIApplication sharedApplication].windows) {
//        NSArray* subviews = window.subviews;
//        if ([subviews count] > 0)
//            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])
//                return YES;
//    }
//    return NO;
//}
+ (void)fontAvalable
{
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+(void)moveViewToPoint:(CGPoint)point view:(UIView*)view duration:(float)duration
{
    [self moveViewToPoint:point view:view duration:duration curve:UIViewAnimationCurveEaseIn];
}
+(void)moveViewToPoint:(CGPoint)point view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve
{
    [self moveViewToPoint:point view:view duration:duration curve:curve repeatTime:0];
}
+(void)moveViewToPoint:(CGPoint)point view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve repeatTime:(float)repeatTime
{
    [UIView  beginAnimations:nil context:NULL];
	[UIView  setAnimationCurve:curve];
	[UIView  setAnimationDuration:duration];
    [UIView  setAnimationRepeatCount:repeatTime];
	view.point = point;
	[UIView  commitAnimations];
}

+(void)rotateViewToAngle:(float)angle view:(UIView*)view duration:(float)duration
{
    [self rotateViewToAngle:angle view:view duration:duration curve:UIViewAnimationCurveEaseIn];
}
+(void)rotateViewToAngle:(float)angle view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve
{
    [self rotateViewToAngle:angle view:view duration:duration curve:curve repeatTime:0];
}
+(void)rotateViewToAngle:(float)angle view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve repeatTime:(float)repeatTime
{
    [UIView  beginAnimations:@"rotate" context:NULL];
	[UIView  setAnimationCurve:curve];
	[UIView  setAnimationDuration:duration];
    [UIView  setAnimationRepeatCount:repeatTime];
    CGRect frame = view.frame;
	view.transform = CGAffineTransformMakeRotation(DegreesToRadians(angle));
    view.frame = frame;
	[UIView  commitAnimations];
}

+(NSString *)getImgPath:(NSString*)imgName
{
    //成功找到标志
    BOOL success = NO;
    
    //先搜索mainBundle
    
    //找png
    NSString* path = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
    success = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    //找jpg
    if (!success)
    {
        path = [[NSBundle mainBundle] pathForResource:imgName ofType:@"jpg"];
        success = [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
    
    //如果是iphone 4以上版本，找高清图png
    if(!success && !IS_IPAD && IS_RETINA)
    {
        //        NSString *fileName = [imgName substringToIndex:imgName.length - 4];
        NSString *retinaFileName  = [NSString stringWithFormat:@"%@@2x",imgName];
        
        path = [[NSBundle mainBundle] pathForResource:retinaFileName ofType:@"png"];
        
        success = [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
    
    //如果是iphone 4以上版本，找高清图jpg
    if(!success && !IS_IPAD && IS_RETINA)
    {
        //        NSString *fileName = [imgName substringToIndex:imgName.length - 4];
        NSString *retinaFileName  = [NSString stringWithFormat:@"%@@2x",imgName];
        
        path = [[NSBundle mainBundle] pathForResource:retinaFileName ofType:@"jpg"];
        
        success = [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
    
    if (success) {
        return path;
    }
    else
    {
        DDLogError(@"do not find file:%@",imgName);
        return  nil;
    }
}

+(UIImage*)getImageByName:(NSString*)name
{
    NSString* path = [self getImgPath:name];
    if (path) {
        UIImage* image = [UIImage imageWithContentsOfFile:path];
        return image;
    }
    else
    {
        return nil;
    }
}
//+ (NSString *)currentUserId
//{
//    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USERID];
//    NSLog(@"%@",userId);
//    return userId;
//}
+ (NSString *)jsonStringFromJSONObject:(id)JSON
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:&error];
    
    NSString *jsonString = nil;
    if (!jsonData) {
        DDLogError(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (id)JSONObjectFromJsonString:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id JSONObject = nil;
    if (data) {
        JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    } else {
         NSLog(@"Got an error: %@", error);
    }
    return JSONObject;
}

+ (void)showMessage:(NSString *)message
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0f];
}

+ (NSDictionary *)getProperties:(id)obj
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *properties = class_copyPropertyList([obj class], &propsCount);
    for (int i = 0; i < propsCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propertyValue = [self getObjectInternal:[obj valueForKey:(NSString *)propertyName]];
        if (propertyValue)
        {
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

+ (id)getObjectInternal:(id)obj
{
    if(!obj || [obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]){
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr addObject:[self getObjectInternal:[objarr objectAtIndex:i]]];
        }
        return arr;
    }
    else if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    else
    {
        return [self getProperties:obj];
    }
}

//不显示多余的小数点
+ (NSString *)formatStringFromDouble:(double)number
{
    NSString *formatString;
    long long longValuePart = (long long)number;
    double doubleValuePart = number - longValuePart;
    NSString *formateDouble = [NSString stringWithFormat:@"%g",doubleValuePart];
    
    NSRange dotRange = [formateDouble rangeOfString:@"."];
    if (dotRange.location != NSNotFound)
    {
        NSString *formateDoubleSubString = [formateDouble substringFromIndex:dotRange.location];
        formatString = [NSString stringWithFormat:@"%lli%@",longValuePart,formateDoubleSubString];
    }
    else
    {
        formatString = [NSString stringWithFormat:@"%lli",longValuePart];
    }
    
    return formatString;
//    if (number <= 999999) {
//        return [NSString stringWithFormat:@"%g",number];
//    }
//    else if (number > 999999 && number == (long long)number) {
//        return [NSString stringWithFormat:@"%lld",(long long)number];
//    }
//    else
//    {
//        return [NSString stringWithFormat:@"%f",number];
//    }
}
@end