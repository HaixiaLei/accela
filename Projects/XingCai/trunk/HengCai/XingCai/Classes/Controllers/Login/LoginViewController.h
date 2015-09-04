//
//  LoginViewController.h
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RememberPasswordKey @"RememberPasswordKey"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *rememberPassword;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIButton *userNameBg;
@property (weak, nonatomic) IBOutlet UIButton *passwordBg;

- (IBAction)fogetPasswordAction:(id)sender;

- (IBAction)loginAction:(id)sender;
- (IBAction)rememberAction:(UIButton *)sender;
@end
