//
//  ZhuiHaoJQObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-2-12.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "KeZhuiHaoJiangQiObject.h"

@implementation KeZhuiHaoJiangQiObject
@synthesize issue;
@synthesize saleend;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.issue = [attribute objectForKey:@"issue"];
        self.saleend = [attribute objectForKey:@"saleend"];
    }
    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"issue->%@",self.issue];
}

@end
