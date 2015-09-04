//
//  Mode.m
//  XingCai
//
//  Created by jay on 14-2-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ModeObject.h"

@implementation ModeObject

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.modeid = [[attribute objectForKey:@"modeid"] stringValue];
        self.name = [attribute objectForKey:@"name"];
        self.rate = [attribute objectForKey:@"rate"];
    }
    return self;
}

@end
