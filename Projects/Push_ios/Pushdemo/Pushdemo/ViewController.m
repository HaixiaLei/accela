//
//  ViewController.m
//  Pushdemo
//
//  Created by Luke on 15/3/24.
//  Copyright (c) 2015年 Luke. All rights reserved.
//

#import "ViewController.h"
#import "Push_iOS_SDK.h"
#import "JSONKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //在这里监听收到的推送消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:PushNoti_ReceivePush object:nil];
    
    //这里处理用户点击推送消息启动
    NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (s) {
        self.laugchLabel.text = [NSString stringWithFormat:@"app通过点击推送消息启动：\n%@",s];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
    }
    
    //把app图片右上方的红圈数字恢复为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (IBAction)getUserPushSetting:(id)sender {
    NSDictionary *dic = [Push_iOS_SDK PushUserAllowedPushTypes];
    NSString *str = [dic JSONString];
    self.settingLabel.text = str;
}

-(void)didReceiveNotification:(NSNotification *)noti{
    self.showLabel.text = [noti.object JSONString];
}
@end























