//
//  GestureViewController.h
//  JiXiangCai
//
//  Created by jay on 14-10-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"

typedef NS_ENUM(NSInteger,GestureType){
    GestureTypeDefault = 0, //default
    GestureTypeSet     = 1, //设置手势密码
    GestureTypeLogin   = 2, //手势密码登录
    GestureTypeReset   = 3, //重置手势密码
};

@interface GestureViewController : UIViewController<KKGestureLockViewDelegate>

@property (weak, nonatomic) IBOutlet KKGestureLockView *lockView;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *promptLB;

- (void)setType:(GestureType)type;

@end
