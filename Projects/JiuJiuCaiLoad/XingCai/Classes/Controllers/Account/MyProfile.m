//
//  MyProfile.m
//  JiuJiuCai
//
//  Created by Bevis on 14-6-23.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MyProfile.h"
#import "NSUserDefaultsManager.h"

@implementation MyProfile

-(NSString *)getUserName
{
   
    if (![[UserInfomation sharedInfomation].nickName isEqualToString:@""])
    {
      self.userName = [UserInfomation sharedInfomation].nickName;
    }
    else
    {
        self.userName =[NSUserDefaultsManager getUsername];
    }

    return self.userName;
}
-(NSString*)getBalance
{
 
    [[AppHttpManager sharedManager] getBalanceWithBlock:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSString class]])
             {
               
                 self.balance= JSON;
                 
               
             }
             else
             {
                 DDLogWarn(@"JSON should be NSString,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
             if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"] && ![UserInfomation sharedInfomation].shouldLoginAgain) {
                 [Utility showErrorWithMessage:[JSON objectForKey:@"msg"]];
                 DDLogDebug(@"Utility showErrorMessage:%@",[JSON objectForKey:@"msg"]);
             }
         }
     }];

    return self.balance;
}

@end
