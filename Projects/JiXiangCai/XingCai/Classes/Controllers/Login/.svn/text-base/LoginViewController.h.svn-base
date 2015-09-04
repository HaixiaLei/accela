//
//  LoginViewController.h
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *userNameBg;
@property (weak, nonatomic) IBOutlet UIButton *passwordBg;
@property (weak, nonatomic) IBOutlet UIView *inputAreaView;
@property (weak, nonatomic) IBOutlet UIButton *gestureButton;

@property (assign, nonatomic) BOOL isGestureLogin;//是否是手势密码登录

- (IBAction)fogetPasswordAction:(id)sender;
- (IBAction)loginAction:(id)sender;

- (void)loginByGesture;
- (void)loginSuccess;
@end
