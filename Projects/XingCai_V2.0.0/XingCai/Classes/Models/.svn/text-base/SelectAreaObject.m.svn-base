//
//  SelectAreaObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-27.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "SelectAreaObject.h"
#import "LayoutObject.h"

@implementation SelectAreaObject
@synthesize type;
@synthesize layout;
@synthesize noBigIndex;
@synthesize isButton;
@synthesize singletypetips;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.type = [attribute objectForKey:@"type"];
        self.noBigIndex = [attribute objectForKey:@"noBigIndex"];
        self.isButton = [attribute objectForKey:@"isButton"];
        self.singletypetips = [attribute objectForKey:@"singletypetips"];
        
        NSMutableArray *layoutArray = [NSMutableArray array];
        NSArray *layoutArrayAttributes = [attribute objectForKey:@"layout"];
        for (int i = 0; i < layoutArrayAttributes.count; ++i)
        {
            id object = [layoutArrayAttributes objectAtIndex:i];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *) object;
                
                LayoutObject *layoutObject = [[LayoutObject alloc] initWithAttribute:dictionary];
                
                [layoutArray addObject:layoutObject];
            }
        }
        self.layout = layoutArray;
        
        //按需要整理
        NSMutableDictionary *orderDictionary = [NSMutableDictionary dictionary];
        for (int i = 0; i < layoutArray.count; ++i) {
            LayoutObject *layoutObject = [layoutArray objectAtIndex:i];
            if (![orderDictionary objectForKey:layoutObject.place]) {
                [orderDictionary setObject:layoutObject forKey:layoutObject.place];
            }
            else
            {
                LayoutObject *layoutObjectInDictionary = [orderDictionary objectForKey:layoutObject.place];
                [layoutObjectInDictionary addNumbers:layoutObject.numbers];
            }
        }
        self.orderlylayout = [orderDictionary allValues];
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"type->%@",self.type];
}

@end
