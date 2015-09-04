//
//  AccountViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshButton.h"

#define NotificationNameCleanBalance @"NotificationNameCleanBalance"

@interface AccountViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UIView *lockV;
@property (weak, nonatomic) IBOutlet UIView *alertV;
@property (weak, nonatomic) IBOutlet UITextField *pwdLab;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet RefreshButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;

- (IBAction)ReloadACtion:(id)sender;
- (IBAction)cashAction:(id)sender;
- (IBAction)atmAction:(id)sender;
- (IBAction)betAction:(id)sender;
- (IBAction)zhAction:(id)sender;
- (IBAction)confirmAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)gotoBuyViewcontroller:(id)sender;
- (IBAction)myMsgAction:(id)sender;
- (IBAction)refreshAction:(id)sender;

- (void)setAvatarImageWithIndex:(NSInteger)avatarId;
@end
