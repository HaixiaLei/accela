//
//  ThirdMenuObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdMenuObject : NSObject

@property (nonatomic,strong)NSString *gtitle;       //五星直选(二级菜单)
@property (nonatomic,strong)NSArray *label;         //FourthMenuObject

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
