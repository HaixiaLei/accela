//
//  BetListObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-11.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BetListObject : NSObject

@property (nonatomic,strong) NSString *issue;      //奖期
@property (nonatomic,strong) NSString *lotteryid;  //彩种id
@property (nonatomic,strong) NSString *totalprice; //投注金额
@property (nonatomic,strong) NSString *bonus;      //奖金
@property (nonatomic,strong) NSString *iscancel;   //订单状态
@property (nonatomic,strong) NSString *isgetprize; //是否开奖
@property (nonatomic,strong) NSString *prizestatus;//中奖后的状态
@property (nonatomic,strong) NSString *lotteryname;//彩种name

@property (nonatomic,strong) NSString *projectid;  //方案ID

- (id)initWithAttribute:(NSDictionary *) attribute;

@end
