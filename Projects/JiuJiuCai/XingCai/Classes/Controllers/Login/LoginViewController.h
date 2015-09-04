//
//  LoginViewController.h
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *loginBackView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *rememberPassword;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)fogetPasswordAction:(id)sender;
//@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

- (IBAction)loginAction:(id)sender;
- (IBAction)rememberAction:(UIButton *)sender;
@end
