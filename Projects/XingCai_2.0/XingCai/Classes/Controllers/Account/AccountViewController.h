//
//  AccountViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NotificationNameCleanBalance @"NotificationNameCleanBalance"

@interface AccountViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UIView *lockV;
@property (weak, nonatomic) IBOutlet UIView *alertV;
@property (weak, nonatomic) IBOutlet UITextField *pwdLab;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bgscrollview;

- (IBAction)cashAction:(id)sender;
- (IBAction)atmAction:(id)sender;
- (IBAction)betAction:(id)sender;
- (IBAction)zhAction:(id)sender;
- (IBAction)confirmAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)bindCardAction:(id)sender;

@end
