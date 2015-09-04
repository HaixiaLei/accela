//
//  OpenNoObject.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-10-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "OpenNoObject.h"

@implementation OpenNoObject

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.issue = [attribute objectForKey:@"issue"];
        self.lotteryid = [attribute objectForKey:@"lotteryid"];
        self.statuscode = [attribute objectForKey:@"statuscode"];
        self.code = [attribute objectForKey:@"code"];
    }
    return self;
}
@end
