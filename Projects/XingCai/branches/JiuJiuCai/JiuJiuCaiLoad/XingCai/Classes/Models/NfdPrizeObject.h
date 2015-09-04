//
//  Nfdprize.h
//  XingCai
//
//  Created by jay on 14-2-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NfdPrizeObject : NSObject

@property (nonatomic,strong)NSString *defaultprize;         //
@property (nonatomic,strong)NSString *levs;         //
@property (nonatomic,strong)NSString *userdiffpoint;         //

- (id)initWithAttribute:(NSDictionary *)attribute;
@end
