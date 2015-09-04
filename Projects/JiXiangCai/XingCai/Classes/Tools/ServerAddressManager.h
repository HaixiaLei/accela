//
//  ServerAddressManager.h
//  XingCai
//
//  Created by jay on 14-5-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerAddressManager : NSObject

@property (nonatomic,strong )NSString *appAPIBaseURLString;
@property (nonatomic,weak) UIViewController *loginVC;//用来获取progresshud对象

+ (ServerAddressManager *)sharedManager;

- (void)getBestServer;
@end
