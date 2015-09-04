//
//  MsgListObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-7.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MsgListObject.h"

@implementation MsgListObject
@synthesize title;
@synthesize subject;
@synthesize sendtime;
@synthesize entry;
@synthesize isview;

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.title = [attribute objectForKey:@"title"];
        self.subject = [attribute objectForKey:@"subject"];
        self.sendtime = [attribute objectForKey:@"sendtime"];
        self.entry = [attribute objectForKey:@"entry"];
        self.isview = [attribute objectForKey:@"isview"];
    }
    return self;
}

@end
