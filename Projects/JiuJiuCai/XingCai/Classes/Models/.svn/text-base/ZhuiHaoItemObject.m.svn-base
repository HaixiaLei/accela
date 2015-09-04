//
//  ZhuiHaoItemObject.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 14-6-25.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZhuiHaoItemObject.h"

@implementation ZhuiHaoItemObject
@synthesize issue;

@synthesize status;
@synthesize iscancel;
@synthesize isgetprize;
@synthesize prizestatus;

@synthesize bonus;

@synthesize entry;

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.issue = [attribute objectForKey:@"issue"];
        
        self.status = [attribute objectForKey:@"status"];
        self.iscancel = [attribute objectForKey:@"iscancel"];
        self.isgetprize = [attribute objectForKey:@"isgetprize"];
        self.prizestatus = [attribute objectForKey:@"prizestatus"];
        
        self.bonus = [attribute objectForKey:@"bonus"];
        
        self.entry = [attribute objectForKey:@"entry"];
    }
    return self;
}

@end
