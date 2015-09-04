//
//  ProvinceListObject.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-14.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "ProvinceListObject.h"

@implementation ProvinceListObject

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.ext = [attribute objectForKey:@"ext"];
        self.fullname = [attribute objectForKey:@"fullname"];
        self.idd = [attribute objectForKey:@"id"];
        
        self.name = [attribute objectForKey:@"name"];
        self.name1 = [attribute objectForKey:@"name1"];
        self.name2 = [attribute objectForKey:@"name2"];
        self.name3 = [attribute objectForKey:@"name3"];
        
        self.orders = [attribute objectForKey:@"orders"];
        self.parent_id = [attribute objectForKey:@"parent_id"];
        self.telecode = [attribute objectForKey:@"telecode"];
        self.used = [attribute objectForKey:@"used"];
        self.zipcode = [attribute objectForKey:@"zipcode"];
    }
    return self;
}

@end
