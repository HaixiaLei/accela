//
//  ZhuiHaoObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-12.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhuiHaoObject : NSObject

@property (nonatomic,strong) NSString *cnname;
@property (nonatomic,strong) NSString *beginissue; //开始期数
@property (nonatomic,strong) NSString *taskprice;  //总金额
@property (nonatomic,strong) NSString *finishprice;//完成金额
@property (nonatomic,strong) NSString *stoponwin;  //中奖后终止 1是 其它否
@property (nonatomic,strong) NSString *status;     //追号状态 0进行中  1已取消  2已完成
@property (nonatomic,strong) NSString *taskid;
@property (nonatomic,strong) NSString *lotteryid;

- (id)initWithAttribute:(NSDictionary *) attribute;

@end
