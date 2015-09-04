//
//  ResetPasswordViewController.h
//  XingCai
//
//  Created by jay on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *password1TF;
@property (weak, nonatomic) IBOutlet UITextField *password2TF;

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *password;
@end
