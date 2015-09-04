//
//  SecondMenuObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-24.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "SecondMenuObject.h"
#import "ThirdMenuObject.h"

@implementation SecondMenuObject
//@synthesize isnew;
@synthesize isdefault;
@synthesize title;
@synthesize label;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.isnew = [attribute objectForKey:@"isnew"];
        self.isdefault = [attribute objectForKey:@"isdefault"];
        self.title = [attribute objectForKey:@"title"];
        
        id lotteryid = [attribute objectForKey:@"lotteryid"];
        if ([lotteryid respondsToSelector:@selector(stringValue)]) {
            lotteryid = [lotteryid stringValue];
        }
        self.lotteryid = lotteryid;
        
        NSMutableArray *thirdArray = [NSMutableArray array];
        NSArray *thirdLabelArr = [attribute objectForKey:@"label"];
        for (int i = 0; i < thirdLabelArr.count; i++)
        {
            id object = [thirdLabelArr objectAtIndex:i];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *) object;
                
                ThirdMenuObject *third = [[ThirdMenuObject alloc] initWithAttribute:dictionary];
                
                [thirdArray addObject:third];
            }
        }
        
        self.label = thirdArray;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"title->%@",self.title];
}

@end
