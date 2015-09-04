//
//  Mode.h
//  XingCai
//
//  Created by jay on 14-2-15.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModeObject : NSObject

@property (nonatomic,strong)NSString *modeid;         //
@property (nonatomic,strong)NSString *name;         //
@property (nonatomic,strong)NSString *rate;         //

- (id)initWithAttribute:(NSDictionary *)attribute;
@end
