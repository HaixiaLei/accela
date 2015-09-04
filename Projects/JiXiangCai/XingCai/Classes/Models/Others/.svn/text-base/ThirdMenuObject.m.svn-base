//
//  ThirdMenuObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ThirdMenuObject.h"
#import "FourthMenuObject.h"

@implementation ThirdMenuObject
@synthesize gtitle;
@synthesize label;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.gtitle = [attribute objectForKey:@"gtitle"];
        
        NSMutableArray *fourthArray = [NSMutableArray array];
        NSArray *fourthLabelArr = [attribute objectForKey:@"label"];
        for (int j = 0; j < fourthLabelArr.count; j++)
        {
            id object = [fourthLabelArr objectAtIndex:j];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *) object;
                
                FourthMenuObject *fourth = [[FourthMenuObject alloc] initWithAttribute:dictionary];
                
                [fourthArray addObject:fourth];
            }
        }
        
        self.label = fourthArray;
       
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"gtitle->%@",self.gtitle];
}

@end
