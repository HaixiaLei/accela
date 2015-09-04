//
//  LayoutObject.h
//  XingCai
//
//  Created by jay on 14-2-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutObject : NSObject

@property (nonatomic,copy)NSString *cols;         //
@property (nonatomic,copy)NSString *no;         //
@property (nonatomic,copy)NSString *place;         //
@property (nonatomic,copy)NSString *title;         //
@property (nonatomic,copy)NSString *minchosen;

//@property (nonatomic,strong) NSArray *numbers;       //no 分出来的数组

- (id)initWithAttribute:(NSDictionary *)attribute;

//- (void)addNumbers:(NSArray *)newNumbers;   //增加号码，主要用于同一种place有多个LayoutObject的情况

@end
