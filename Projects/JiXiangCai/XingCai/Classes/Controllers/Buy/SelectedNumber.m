//
//  SelectedNumber.m
//  JiXiangCai
//
//  Created by hadis on 14-11-11.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "SelectedNumber.h"

static SelectedNumber *singleInfo=nil;
@implementation SelectedNumber


+(SelectedNumber*)getInstance{

    static SelectedNumber *singleInfo =nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate,^{
        singleInfo = [[self alloc]init];
    });
    return singleInfo;
}
-(id)init
{
    if (self = [super init])
    {
        self.infoArray = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
