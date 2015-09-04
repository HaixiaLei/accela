//
//  UserInfomation.h
//  News
//
//  Created by jay on 13-7-23.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PrizeType){//返点类型。默认为1
    PrizeTypeDefault = 1,
    PrizeTypeLevs,
};

@interface UserInfomation : NSObject

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, assign) unsigned modeIndex; //模式，元、角、分模式序号
@property (nonatomic, assign)PrizeType prizeType;//返点模式
@property (nonatomic, assign)PrizeType prePrizeType;//上一次返点模式

@property (assign, nonatomic) BOOL shouldLoginAgain;
@property (assign, nonatomic) BOOL loginVCVisible;

//@property (assign, nonatomic) BOOL latestVersionGot;

//@property (nonatomic, strong) NSString *version;
//@property (nonatomic, strong) NSString *download;
+ (UserInfomation *)sharedInfomation;

//- (void)setVersion:(NSString *)version url:(NSString *)url;
@end
