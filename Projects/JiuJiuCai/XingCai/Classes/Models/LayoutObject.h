//
//  LayoutObject.h
//  XingCai
//
//  Created by jay on 14-2-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutObject : NSObject

@property (nonatomic,strong)NSString *cols;         //
@property (nonatomic,strong)NSString *no;         //
@property (nonatomic,strong)NSString *place;         //
@property (nonatomic,strong)NSString *title;         //
@property (nonatomic,strong)NSString *minchosen;

@property (nonatomic,strong) NSArray *numbers;       //no 分出来的数组

- (id)initWithAttribute:(NSDictionary *)attribute;

- (void)addNumbers:(NSArray *)newNumbers;   //增加号码，主要用于同一种place有多个LayoutObject的情况

@end
