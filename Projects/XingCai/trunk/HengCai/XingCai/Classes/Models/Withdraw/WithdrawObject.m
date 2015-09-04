//
//  WithdrawObject.m
//  HengCai
//
//  Created by jay on 14-8-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "WithdrawObject.h"

@implementation WithdrawObject

- (id)init {
    if (self = [super init]) {
        [self setValue:@"BankCardObject" forKeyPath:@"propertyArrayMap.banks"];
    }
    return self;
}

@end
