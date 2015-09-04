//
//  BankListPicker.h
//  XingCai
//
//  Created by Air.Zhao on 14-2-14.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) x
#define AH_RELEASE(x)
#define AH_AUTORELEASE(x) x
#define AH_SUPER_DEALLOC
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [x retain]
#define AH_RELEASE(x) [x release]
#define AH_AUTORELEASE(x) [x autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#endif
#endif

//  Weak reference support
#ifndef AH_WEAK
#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_4_3
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
#if __MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_6
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#endif
#endif

#import <Foundation/Foundation.h>

@class BankListPicker;

@protocol BankListPickerDelegate <UIPickerViewDelegate>
- (void)bankListPicker:(BankListPicker *)picker didSelectDateWithName:(NSString *)name;
@end

@interface BankListPicker : UIPickerView

- (NSArray *)dates;
- (void)setDates:(NSArray *)names;

- (int)selectRowNo;
- (void)setSelectRowNo:(int)row;

@property (nonatomic, AH_WEAK) id<BankListPickerDelegate> delegate;

@end
