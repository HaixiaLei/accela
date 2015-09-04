//
//  AtmListObject.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtmListObject : NSObject

@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *availablebalance;
@property (nonatomic,strong) NSString *cntitle;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *entitle;
@property (nonatomic,strong) NSString *entry;
@property (nonatomic,strong) NSString *fromuserid;
@property (nonatomic,strong) NSString *operations;
@property (nonatomic,strong) NSString *orderno;
@property (nonatomic,strong) NSString *ordertypeid;
@property (nonatomic,strong) NSString *preavailable;
@property (nonatomic,strong) NSString *times;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *transferstatus;
@property (nonatomic,strong) NSString *uniquekey;
@property (nonatomic,strong) NSString *username;

- (id)initWithAttribute:(NSDictionary *) attribute;

@end
