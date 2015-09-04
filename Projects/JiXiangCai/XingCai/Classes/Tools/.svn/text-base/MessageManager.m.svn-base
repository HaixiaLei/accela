//
//  MessageManager.m
//  JiXiangCai
//
//  Created by jay on 14-10-18.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MessageManager.h"

@implementation MessageManager
{
    RightNavButton *rightNavButton;
    RightNavButton *rightNavButtonLotteryList;
}

+ (MessageManager *)sharedManager {
    static MessageManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[MessageManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}

- (RightNavButton *)rightNavButtonWithTarget:(id)target action:(SEL)action
{
    if (!rightNavButton) {
        rightNavButton = [RightNavButton rightNavButtonWithTarget:target action:action];
        if (rightNavButtonLotteryList) {
            rightNavButton.dotImgView.hidden = rightNavButtonLotteryList.dotImgView.hidden;
        }
    }
    else
    {
        [rightNavButton setTarget:target action:action];
    }
    
    return rightNavButton;
}

- (RightNavButton *)rightNavButtonLotteryListWithTarget:(id)target action:(SEL)action
{
    if (!rightNavButtonLotteryList) {
        rightNavButtonLotteryList = [RightNavButton rightNavButtonWithTarget:target action:action];
        if (rightNavButton) {
            rightNavButtonLotteryList.dotImgView.hidden = rightNavButton.dotImgView.hidden;
        }
    }
    else
    {
        [rightNavButtonLotteryList setTarget:target action:action];
    }
    
    return rightNavButtonLotteryList;
}
- (void)updateMessages
{
    [[AFAppAPIClient sharedClient] getMessageAmount_with_block:^(id JSON, NSError *error){
        if (!error) {
            NSString *totalString = [JSON objectForKey:@"total"];
            [self setTotal:totalString];
        }
    }];
}

- (void)setTotal:(NSString *)totalString
{
    NSInteger total = [totalString integerValue];
    [self setDotHidden:!(total > 0)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameNewMessageCount object:totalString];
}

- (void)setDotHidden:(BOOL)hidden
{
    rightNavButton.dotImgView.hidden = hidden;
    rightNavButtonLotteryList.dotImgView.hidden = hidden;
}
@end
