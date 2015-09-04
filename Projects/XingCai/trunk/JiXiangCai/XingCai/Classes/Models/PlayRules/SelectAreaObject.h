//
//  SelectAreaObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-27.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectAreaObject : NSObject

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *noBigIndex;
@property (nonatomic,copy) NSString *isButton;
@property (nonatomic,copy) NSString *singletypetips;
@property (nonatomic,copy) NSArray *layout;               //LayoutObject

@property (nonatomic,copy) NSArray *orderlylayout;        //经过整理的LayoutObject,同样地place值得layoutObject进行了合并

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
