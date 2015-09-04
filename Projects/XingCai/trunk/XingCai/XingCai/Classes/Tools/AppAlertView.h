//
//  AppAlertView.h
//  XingCai
//
//  Created by jay on 14-4-23.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "CXAlertView.h"

@class AppAlertView;
@protocol AppAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface AppAlertView : CXAlertView
@property (nonatomic, readonly) NSInteger cancelButtonIndex;
@property (nonatomic, strong) NSString *message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<AppAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)dismissAllAlertViews;

+ (NSArray *)allAlertViews;

@end


