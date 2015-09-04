//
//  ZHDetailObject.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZHDetailObject.h"

@implementation ZHDetailObject

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.issue = [attribute objectForKey:@"issue"];
        self.status = [attribute objectForKey:@"status"];
        self.iscan = [attribute objectForKey:@"iscan"];
        self.multiple = [attribute objectForKey:@"multiple"];
        self.entry = [attribute objectForKey:@"entry"];
        
        self.flag = @"未选";
    }
    return self;
}
@end
