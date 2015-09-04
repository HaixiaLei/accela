//
//  AppAlertView.m
//  XingCai
//
//  Created by jay on 14-4-23.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AppAlertView.h"
#import <objc/runtime.h>

@implementation AppAlertView

+ (void)dismissAllAlertViews
{
    NSArray *alert_queue = [NSArray arrayWithArray:[CXAlertView sharedQueue]];
    for (CXAlertView *alertView in alert_queue) {
        [alertView dismiss];
    }
}

+ (NSArray *)allAlertViews
{
    return [CXAlertView sharedQueue];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<AppAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    _message = message;
    self = [super initWithTitle:title message:message cancelButtonTitle:nil];
    
    if(self)
    {
        if(cancelButtonTitle)
        {
            [self addButtonWithTitle:cancelButtonTitle
                                type:CXAlertViewButtonTypeCancel
                             handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                 [alertView dismiss];
                                 if(delegate && [delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                 {
                                     AppAlertView *appAlertView = (AppAlertView *)alertView;
                                     [delegate alertView:appAlertView clickedButtonAtIndex:0];
                                 }
                             }];
        }
        
        if(otherButtonTitles)
        {
            [self addButtonWithTitle:otherButtonTitles
                                type:CXAlertViewButtonTypeCustom
                             handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                 [alertView dismiss];
                                 if(delegate && [delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                 {
                                     AppAlertView *appAlertView = (AppAlertView *)alertView;
                                     [delegate alertView:appAlertView clickedButtonAtIndex:1];
                                 }
                             }];
        }
    }
    
    NSArray *buttons = [self valueForKey:@"buttons"];
    if (buttons.count == 1)
    {
        UIButton *button = [buttons firstObject];
        button.frame = CGRectMake(0, 0, self.containerWidth, self.buttonHeight);
    }
    else if(buttons.count > 1)
    {
        CXAlertButtonItem *button = [buttons lastObject];
        button.defaultRightLineVisible = NO;
    }
    return self;
}

- (void)setMessage:(NSString *)aMessage
{
    _message = aMessage;
    UILabel *messageLabel = [self valueForKey:@"messageLabel"];
    messageLabel.text = aMessage;
}

@end
