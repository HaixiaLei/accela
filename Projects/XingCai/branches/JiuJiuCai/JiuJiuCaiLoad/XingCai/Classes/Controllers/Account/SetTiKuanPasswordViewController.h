//
//  SetTiKuanPasswordViewController.h
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-23.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTiKuanPasswordViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *pwdTxt;
@property (nonatomic, weak) IBOutlet UITextField *pwdConfirmTxt;

-(IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)setPwdClk:(UIButton *)sender;

@end
