//
//  Utility.h
//  News
//
//  Created by jay on 13-7-22.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DegreesToRadians(x) ((x) * M_PI / 180.0)

#define TimeIntervalOfDay(x) (3600 * 24 * (x))
#define TimeIntervalOfMonth(x) (30 * TimeIntervalOfDay(x))

@class JsonCacheBean;
@class AppAlertView;
@interface Utility : NSObject

//显示UIAlertView
+ (AppAlertView *)showErrorWithMessage:(NSString *)message;
+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate;
+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag;
+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag duplicationPrevent:(BOOL)duplicationPrevent;
+ (AppAlertView *)showErrorWithMessage:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle tag:(NSInteger)tag duplicationPrevent:(BOOL)duplicationPrevent;
+ (AppAlertView *)showErrorWithTittle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle tag:(NSInteger)tag duplicationPrevent:(BOOL)duplicationPrevent;

//+ (BOOL)isAlertViewShowing;
//打印当前系统支持的字体
+ (void)fontAvalable;

//rgb16转 UIColor
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+(void)moveViewToPoint:(CGPoint)point view:(UIView*)view duration:(float)duration;//移动View到指定点point
+(void)moveViewToPoint:(CGPoint)point view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve;//移动View到指定点point
+(void)moveViewToPoint:(CGPoint)point view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve repeatTime:(float)repeatTime;

+(void)rotateViewToAngle:(float)angle view:(UIView*)view duration:(float)duration;//
+(void)rotateViewToAngle:(float)angle view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve;//
+(void)rotateViewToAngle:(float)angle view:(UIView*)view duration:(float)duration curve:(UIViewAnimationCurve)curve repeatTime:(float)repeatTime;

+(UIImage*)getImageByName:(NSString*)name;

+ (NSString *)jsonStringFromJSONObject:(id)JSON;
+ (id)JSONObjectFromJsonString:(NSString *)jsonString;

+ (void)showMessage:(NSString *)message;

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary *)getProperties:(id)obj;

//不显示多余的小数点
+ (NSString *)formatStringFromDouble:(double)number;

+ (UIImage *)imageWithView:(UIView *)view;

////金额格式化，加入逗号分隔
+ (NSString *)formatStringFromDoubleWithDecimal:(double)number;

//给金额字符串加逗号
+ (NSString *)addDotForMoneyString:(NSString *)money;

//用iOS系统类NSDecimailNumber进行金额乘除法运算
+(NSString *)multiplyingDecimalNumberByMultiplicandAarray:(NSArray *)DNArr;
@end
