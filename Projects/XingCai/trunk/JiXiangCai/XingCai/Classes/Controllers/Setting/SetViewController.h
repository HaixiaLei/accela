//
//  SetViewController.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-29.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"

@interface SetViewController : DerivedViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *changePwdImg;
@property (weak, nonatomic) IBOutlet UIImageView *pwdArrowImg;

@property (weak, nonatomic) IBOutlet UIImageView *changeLoginPwdImg;
@property (weak, nonatomic) IBOutlet UIImageView *loginPwdArrowImg;

@property (weak, nonatomic) IBOutlet UIImageView *feedbackImg;
@property (weak, nonatomic) IBOutlet UIImageView *feedbackArrowImg;

@property (weak, nonatomic) IBOutlet UIImageView *checkVersionImg;

@property (strong ,nonatomic) UIView *shadeView;
@property (strong ,nonatomic) UIView *feedbackView;
@property (strong ,nonatomic) UILabel *leftLabel;
@property (strong ,nonatomic) UITextView *feedbackTextview;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;

- (IBAction)touchDownChangePwd:(id)sender;
- (IBAction)changePwd:(id)sender;

- (IBAction)touchDownChangeLoginPwd:(id)sender;
- (IBAction)changeLoginPwd:(id)sender;

- (IBAction)touchDownFeedback:(id)sender;
- (IBAction)feedback:(id)sender;

- (IBAction)touchDownCheckVersion:(id)sender;
- (IBAction)checkVersion:(id)sender;

@end
