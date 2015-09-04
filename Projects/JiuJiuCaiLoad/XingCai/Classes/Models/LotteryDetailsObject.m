//
//  LotteryDetailsObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-14.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "LotteryDetailsObject.h"

@implementation LotteryDetailsObject
@synthesize code;
@synthesize issue;
@synthesize statuscode;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.code = [attribute objectForKey:@"code"];
        self.issue = [attribute objectForKey:@"issue"];
        self.statuscode = [attribute objectForKey:@"statuscode"];
    }
    return self;
}

@end
