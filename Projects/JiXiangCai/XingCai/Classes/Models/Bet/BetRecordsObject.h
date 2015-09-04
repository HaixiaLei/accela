//
//  BetRecordsObject.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-24.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BetRecordsObject : NSObject

@property (nonatomic,strong) NSString *issue;//奖期
@property (nonatomic,strong) NSString *lotteryid;//判断显示日本/重庆的图片
@property (nonatomic,strong) NSString *methodname;//玩法
@property (nonatomic,strong) NSString *isgetprize;//根据是否开奖判断号球的颜色
@property (nonatomic,strong) NSString *nocode;//开奖号码
@property (nonatomic,strong) NSString *prizestatus;//中奖后的状态
@property (nonatomic,strong) NSString *code;//投注内容
@property (nonatomic,strong) NSString *totalprice;//投注金额
@property (nonatomic,strong) NSString *multiple;//倍数
@property (nonatomic,strong) NSString *bonus;//奖金
@property (nonatomic,strong) NSString *projectidcode;
@property (nonatomic,strong) NSString *projectid;
@property (nonatomic,strong) NSString *iscancel;

- (id)initWithAttribute:(NSDictionary *) attribute;

@end
