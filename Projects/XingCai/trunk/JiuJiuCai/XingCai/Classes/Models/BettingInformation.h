//
//  BettingInformation.h
//  XingCai
//
//  Created by jay on 14-2-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BettingInformation : NSObject

@property (nonatomic, strong) NSString *type;       //类型：数字，基诺，乐透。玩法selectarea里有
@property (nonatomic, strong) NSString *methodid;   //玩法id。玩法里有
@property (nonatomic, strong) NSString *codes;      //投注号码。比如:3&6|4&5&7
@property (nonatomic, strong) NSString *nums;       //注数
@property (nonatomic, strong) NSString *omodel;     //奖金模式
@property (nonatomic, strong) NSString *times;      //倍率
@property (nonatomic, strong) NSString *money;      //本次费用
@property (nonatomic, strong) NSString *mode;       //圆角分模式
@property (nonatomic, strong) NSString *desc;       //描述

@property (nonatomic, strong) NSString *showCodes;  //下注页显示投注号码
@property (nonatomic, strong) NSString *showDesc;   //下注页显示描述
@end
