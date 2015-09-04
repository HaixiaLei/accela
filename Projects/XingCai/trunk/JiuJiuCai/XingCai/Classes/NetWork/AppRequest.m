//
//  AppRequest.m
//  XingCai
//
//  Created by jay on 14-4-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AppRequest.h"

@implementation AppRequest

- (id)init
{
    if (self = [super init]) {
        self.method = APIMethodNone;
    }
    return self;
}
@end
