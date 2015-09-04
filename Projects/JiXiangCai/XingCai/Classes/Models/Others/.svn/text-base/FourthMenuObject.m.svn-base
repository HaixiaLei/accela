//
//  FourthMenuObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "FourthMenuObject.h"
#import "ModeObject.h"

@implementation FourthMenuObject
@synthesize name;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.code_sp = [attribute objectForKey:@"code_sp"];
        self.desc = [attribute objectForKey:@"desc"];
        self.maxcodecount = [attribute objectForKey:@"maxcodecount"];
        self.methoddesc = [attribute objectForKey:@"methoddesc"];
        self.methodexample = [attribute objectForKey:@"methodexample"];
        self.methodhelp = [attribute objectForKey:@"methodhelp"];
        self.methodid = [attribute objectForKey:@"methodid"];
        self.name = [[attribute objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.prize = [attribute objectForKey:@"prize"];
        self.show_str = [attribute objectForKey:@"show_str"];
        
        NSMutableArray *modesArray = [NSMutableArray array];
        NSArray *modesArrayAttributes = [attribute objectForKey:@"modes"];
        for (int i = 0; i < modesArrayAttributes.count; ++i)
        {
            id object = [modesArrayAttributes objectAtIndex:i];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *) object;
                
                ModeObject *modeObject = [[ModeObject alloc] initWithAttribute:dictionary];
                
                [modesArray addObject:modeObject];
            }
        }
        self.modes = modesArray;
        
        self.nfdprize = [attribute objectForKey:@"nfdprize"];
//        NSDictionary *nfdprizeAttribute = [attribute objectForKey:@"nfdprize"];
//        self.nfdprize = [[NfdPrizeObject alloc] initWithAttribute:nfdprizeAttribute];
        
        NSDictionary *selectAreaArrayAttributes = [attribute objectForKey:@"selectarea"];
        self.selectarea = [[SelectAreaObject alloc] initWithAttribute:selectAreaArrayAttributes];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name->%@",self.name];
}

@end
