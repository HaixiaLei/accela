//
//  SecondMenuObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-24.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecondMenuObject : NSObject

@property (nonatomic,strong)NSString *isnew;       //
@property (nonatomic,strong)NSString *isdefault;   //
@property (nonatomic,strong)NSString *title;       //五星、四星、三星(二级菜单)
@property (nonatomic,strong)NSArray *label;        //ThirdMenuObject
@property (nonatomic,strong)NSString *lotteryid;   //彩种id

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
