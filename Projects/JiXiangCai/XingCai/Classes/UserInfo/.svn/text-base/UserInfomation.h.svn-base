//
//  UserInfomation.h
//  News
//
//  Created by jay on 13-7-23.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PrizeType){//返点类型。默认为1
    PrizeTypeDefault = 0, //无返点，omodel = 0
    PrizeTypeRebates = 1, //自身返点，omodel值根据nfdprize数组中的key
};

@interface UserInfomation : NSObject

@property (nonatomic, strong) NSString *nickName;//用户昵称

@property (nonatomic, assign) NSInteger modeIndex; //模式，元、角、分模式序号
@property (nonatomic, assign) PrizeType prizeType; //返点模式
@property (nonatomic, assign) PrizeType prePrizeType; //上一次返点模式

@property (assign, nonatomic) BOOL shouldLoginAgain;
@property (assign, nonatomic) BOOL loginVCVisible;

@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appBuild;

+ (UserInfomation *)sharedInfomation;

@property (nonatomic, strong) NSString *account;//账号
@property (nonatomic, strong) NSString *password;//密码
@property (nonatomic, strong) NSString *gesturePassword;//手势密码

@end
