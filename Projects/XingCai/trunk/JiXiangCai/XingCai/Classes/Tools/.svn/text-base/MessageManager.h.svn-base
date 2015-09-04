//
//  MessageManager.h
//  JiXiangCai
//
//  Created by jay on 14-10-18.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RightNavButton.h"

#define NotificationNameNewMessageCount @"NotificationNameNewMessageCount"

@interface MessageManager : NSObject

+ (MessageManager *)sharedManager;

- (RightNavButton *)rightNavButtonWithTarget:(id)target action:(SEL)action;
- (RightNavButton *)rightNavButtonLotteryListWithTarget:(id)target action:(SEL)action;

- (void)updateMessages;

- (void)setTotal:(NSString *)totalString;

@end
