//
//  LoginViewController.h
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *rememberPassword;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tickIV;
@property (weak, nonatomic) IBOutlet UIImageView *userNameTFImage;
@property (weak, nonatomic) IBOutlet UIImageView *passwordTFImage;
@property (weak, nonatomic) IBOutlet UILabel *versonext;
@property (weak, nonatomic) IBOutlet UIImageView *tab_logo;

- (IBAction)fogetPasswordAction:(id)sender;

- (IBAction)loginAction:(id)sender;
- (IBAction)rememberAction:(UIButton *)sender;
@end
