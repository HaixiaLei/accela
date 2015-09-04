//
//  OpenLotteryObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-13.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "OpenLotteryObject.h"

@implementation OpenLotteryObject
@synthesize type;
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"code->%@,issue->%@,statuscode->%@",self.code,self.issue,self.statuscode];
}
@end
