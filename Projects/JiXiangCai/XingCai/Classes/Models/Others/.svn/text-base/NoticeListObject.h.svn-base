//
//  NoticeListObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AnnouncementObject:NSObject

@property (nonatomic,strong) NSString *noticeId;
@property (nonatomic,strong) NSString *noticeUrl;
@property (nonatomic,strong) NSString *sendDay;
@property (nonatomic,strong) NSString *subject;
-(id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface NoticeListObject : NSObject
{
    NSMutableArray * _dataArray;
}


- (id)initWithAttribute:(NSDictionary *) attribute;
- (NSMutableArray *)getDataArray;
@end
