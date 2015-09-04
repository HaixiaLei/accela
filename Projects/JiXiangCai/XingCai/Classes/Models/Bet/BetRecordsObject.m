//
//  BetRecordsObject.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-24.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetRecordsObject.h"

@implementation BetRecordsObject

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.issue = [attribute objectForKey:@"issue"];
        self.lotteryid = [attribute objectForKey:@"lotteryid"];
        self.methodname = [attribute objectForKey:@"methodname"];
        self.isgetprize = [attribute objectForKey:@"isgetprize"];
        self.nocode = [attribute objectForKey:@"nocode"];
        self.prizestatus = [attribute objectForKey:@"prizestatus"];
        self.code = [attribute objectForKey:@"code"];
        self.totalprice = [attribute objectForKey:@"totalprice"];
        self.multiple = [attribute objectForKey:@"multiple"];
        self.bonus = [attribute objectForKey:@"bonus"];
        self.projectidcode = [attribute objectForKey:@"projectidcode"];
        self.projectid = [attribute objectForKey:@"projectid"];
        self.iscancel = [attribute objectForKey:@"iscancel"];
    }
    return self;
}

@end
