//
//  MessageManager.m
//  JiXiangCai
//
//  Created by jay on 14-10-18.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MessageManager.h"

@implementation MessageManager

+ (MessageManager *)sharedManager {
    static MessageManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[MessageManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}

- (void)updateMessages
{
    
}

@end
