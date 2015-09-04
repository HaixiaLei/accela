//
//  BetListObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-11.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetListObject.h"

@implementation BetListObject
@synthesize issue;      //奖期
@synthesize lotteryid;  //彩种id
@synthesize totalprice; //投注金额
@synthesize bonus;      //奖金
@synthesize iscancel;   //订单状态
@synthesize isgetprize; //是否开奖
@synthesize prizestatus;//中奖后的状态
@synthesize lotteryname;//彩种name
@synthesize projectid;  //方案ID
@synthesize writetime;

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.issue = [attribute objectForKey:@"issue"];
        self.lotteryid = [attribute objectForKey:@"lotteryid"];
        self.totalprice = [attribute objectForKey:@"totalprice"];
        self.bonus = [attribute objectForKey:@"bonus"];
        self.iscancel = [attribute objectForKey:@"iscancel"];
        self.isgetprize = [attribute objectForKey:@"isgetprize"];
        self.prizestatus = [attribute objectForKey:@"prizestatus"];
        self.projectid = [attribute objectForKey:@"projectid"];
        self.writetime = [attribute objectForKey:@"writetime"];
    }
    return self;
}

@end
