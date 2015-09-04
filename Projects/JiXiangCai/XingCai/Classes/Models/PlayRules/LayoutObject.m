//
//  LayoutObject.m
//  XingCai
//
//  Created by jay on 14-2-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "LayoutObject.h"

@implementation LayoutObject

- (id)initWithAttribute:(NSDictionary *)attribute
{
    if (self = [super init])
    {
        self.cols = [attribute objectForKey:@"cols"];
        self.no = [[attribute objectForKey:@"no"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.place = [attribute objectForKey:@"place"];
        self.title = [[attribute objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([attribute objectForKey:@"minchosen"]) {
            self.minchosen = [attribute objectForKey:@"minchosen"];
        }
        
//        self.numbers = [self.no componentsSeparatedByString:@"|"];
    }
    return self;
}

//- (void)addNumbers:(NSArray *)newNumbers
//{
//    NSMutableArray *numbers = [NSMutableArray arrayWithArray:self.numbers];
//    [numbers addObjectsFromArray:newNumbers];
//    self.numbers = numbers;
//}

@end
