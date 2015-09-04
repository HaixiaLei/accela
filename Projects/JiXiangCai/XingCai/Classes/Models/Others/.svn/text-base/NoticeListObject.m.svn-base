//
//  NoticeListObject.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "NoticeListObject.h"
@implementation AnnouncementObject
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self=[super init];
    if (self) {
        self.noticeId = [dictionary objectForKey:@"noticeid"];
        self.noticeUrl = [dictionary objectForKey:@"noticeurl"];
        self.sendDay = [dictionary objectForKey:@"sendday"];
        self.subject =[dictionary objectForKey:@"subject"];

    }
    return  self;
}
@end
@implementation NoticeListObject


- (id)initWithAttribute:(NSDictionary *) attribute
{
    if (self = [super init])
    {
            [self setDataArray:[attribute objectForKey:@"results"]];
    }
    return self;
}
-(NSMutableArray *)setDataArray:(NSArray *)array{
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary * element in array) {
        AnnouncementObject *dataObject=[[AnnouncementObject alloc]initWithDictionary:element];
        [_dataArray addObject:dataObject];
    }
    NSLog(@"%@",_dataArray);
    return _dataArray;
}

- (NSMutableArray *)getDataArray{

    return _dataArray;
}
@end
