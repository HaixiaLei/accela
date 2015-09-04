//
//  ZHRecordsObject.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHRecordsObject : NSObject

@property (nonatomic,strong) NSString *beginissue;
@property (nonatomic,strong) NSString *lotteryid;//判断显示日本/重庆的图片
@property (nonatomic,strong) NSString *methodname;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *codes;
//@property (nonatomic,strong) NSString *issuecount;
//@property (nonatomic,strong) NSString *finishedcount;
@property (nonatomic,strong) NSString *stoponwin;
@property (nonatomic,strong) NSString *taskprice;
@property (nonatomic,strong) NSString *taskidcode;
@property (nonatomic,strong) NSString *taskid;
@property (nonatomic,strong) NSString *begintime;//追号时间

- (id)initWithAttribute:(NSDictionary *) attribute;

@end
