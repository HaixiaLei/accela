//
//  BankListObject.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-13.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "BankListObject.h"

@implementation BankListObject

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.api_id = [attribute objectForKey:@"api_id"];
        self.api_name = [attribute objectForKey:@"api_name"];
        self.atime = [attribute objectForKey:@"atime"];
        self.bank_code = [attribute objectForKey:@"bank_code"];
        self.bank_id = [attribute objectForKey:@"bank_id"];
        self.bank_name = [attribute objectForKey:@"bank_name"];
        self.idd = [attribute objectForKey:@"id"];
        self.status = [attribute objectForKey:@"status"];
        self.utime = [attribute objectForKey:@"utime"];
    }
    return self;
}

@end
