//
//  BankObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-19.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BankObject.h"

@implementation BankObject
@synthesize bank_name;
@synthesize province;
@synthesize city;
@synthesize account_name;
@synthesize account;

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.bank_name = [attribute objectForKey:@"bank_name"];
        self.province = [attribute objectForKey:@"province"];
        self.city = [attribute objectForKey:@"city"];
        self.account_name = [attribute objectForKey:@"account_name"];
        self.account = [attribute objectForKey:@"account"];
    }
    return self;
}

@end
