//
//  MyLotteryObject.h
//  HengCai
//
//  Created by jay on 14-8-11.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLotteryObject : NSObject

@property (nonatomic,strong) NSString *bonus;       //奖金
@property (nonatomic,strong) NSString *cnname;      //彩种名称
@property (nonatomic,strong) NSString *code;        //投注内容
@property (nonatomic,strong) NSString *codetype;    //投注类型

@property (nonatomic,strong) NSString *iscancel;    //订单状态 0受理  1本人撤单  2平台撤单  3错开撤单
@property (nonatomic,strong) NSString *isgetprize;  //是否开奖 0未开奖  2未中奖
@property (nonatomic,strong) NSString *issue;       //投注期号
@property (nonatomic,strong) NSString *lotteryid;   //彩种id

@property (nonatomic,strong) NSString *lotterytype; //彩种类型
@property (nonatomic,strong) NSString *methodid;    //彩种方法id
@property (nonatomic,strong) NSString *methodname;  //方法名称
@property (nonatomic,strong) NSString *modes;       //购买模式

@property (nonatomic,strong) NSString *multiple;    //投了多少注
@property (nonatomic,strong) NSString *nocode;      //开奖号码
@property (nonatomic,strong) NSString *packageid;   //订单id
@property (nonatomic,strong) NSString *prizestatus; //中奖后的状态 0未派奖 其它表已派奖

@property (nonatomic,strong) NSString *projectid;   //记录id
@property (nonatomic,strong) NSString *statuscode;  //开奖奖期状态 0:未写入;1:写入待验证;2:已验证;3:官方未开奖
@property (nonatomic,strong) NSString *taskid;      //任务id
@property (nonatomic,strong) NSString *totalprice;  //投注金额

@property (nonatomic,strong) NSString *userid;      //用户id
@property (nonatomic,strong) NSString *username;    //用户
@property (nonatomic,strong) NSString *writetime;   //投注时间

@end
