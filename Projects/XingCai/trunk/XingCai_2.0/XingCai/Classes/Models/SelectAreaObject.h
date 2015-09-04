//
//  SelectAreaObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-27.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectAreaObject : NSObject

@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *noBigIndex;
@property (nonatomic,strong) NSString *isButton;
@property (nonatomic,strong) NSString *singletypetips;
@property (nonatomic,strong) NSArray *layout;               //LayoutObject

@property (nonatomic,strong) NSArray *orderlylayout;        //经过整理的LayoutObject,同样地place值得layoutObject进行了合并

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
