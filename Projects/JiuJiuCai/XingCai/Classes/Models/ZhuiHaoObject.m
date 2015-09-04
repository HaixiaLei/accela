//
//  ZhuiHaoObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-12.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZhuiHaoObject.h"

@implementation ZhuiHaoObject
@synthesize cnname;
@synthesize beginissue; //开始期数
@synthesize taskprice;  //总金额
@synthesize finishprice;//完成金额
@synthesize stoponwin;  //中奖后终止 1是 其它否
@synthesize status;     //追号状态 0进行中  1已取消  2已完成
@synthesize taskid;
@synthesize begintime;  //追号时间

- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
        self.cnname = [attribute objectForKey:@"cnname"];
        self.beginissue = [attribute objectForKey:@"beginissue"];
        self.taskprice = [attribute objectForKey:@"taskprice"];
        self.finishprice = [attribute objectForKey:@"finishprice"];
        self.stoponwin = [attribute objectForKey:@"stoponwin"];
        self.status = [attribute objectForKey:@"status"];
        self.taskid = [attribute objectForKey:@"taskid"];
        self.begintime = [attribute objectForKey:@"begintime"];
    }
    return self;
}

@end
