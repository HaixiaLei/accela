//
//  Nfdprize.m
//  XingCai
//
//  Created by jay on 14-2-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "NfdPrizeObject.h"

@implementation NfdPrizeObject

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        if ([attribute isKindOfClass:[NSDictionary class]]) {
            self.defaultprize = [attribute objectForKey:@"defaultprize"];
            self.levs = [attribute objectForKey:@"levs"];
            self.userdiffpoint = [attribute objectForKey:@"userdiffpoint"];
        }
    }
    return self;
}

@end
