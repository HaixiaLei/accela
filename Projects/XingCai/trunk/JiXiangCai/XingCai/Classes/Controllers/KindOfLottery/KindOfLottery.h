//
//  KindOfLottery.h
//  XingCai
//
//  Created by Bevis on 14-1-16.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KindOfLottery : NSObject

@property (nonatomic,strong)NSString *cnname;         //彩种
@property (nonatomic,strong)NSString *curmid;         //开奖号码
@property (nonatomic,strong)NSString *nav;        //奖期
@property (nonatomic,strong)NSString *pid;   //

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
