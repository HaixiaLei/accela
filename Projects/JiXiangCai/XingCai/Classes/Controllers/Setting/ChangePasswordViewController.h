//
//  ChangePasswordViewController.h
//  XingCai
//
//  Created by jay on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : DerivedViewController

@property (weak, nonatomic) IBOutlet UITextField *password1TF;
@property (weak, nonatomic) IBOutlet UITextField *password2TF;
@property (weak, nonatomic) IBOutlet UITextField *password3TF;
@property (weak, nonatomic) IBOutlet UIButton *password1bg;
@property (weak, nonatomic) IBOutlet UIButton *password2bg;
@property (weak, nonatomic) IBOutlet UIButton *password3bg; 

@end
