//
//  LotteryInfomation.h
//  XingCai
//
//  Created by jay on 14-2-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BettingInformation;
@class ModeObject;
@interface LotteryInformation : NSObject

@property (nonatomic, strong) BettingInformation *bettingInformation;
@property (nonatomic, strong) ModeObject *mode;
@end
