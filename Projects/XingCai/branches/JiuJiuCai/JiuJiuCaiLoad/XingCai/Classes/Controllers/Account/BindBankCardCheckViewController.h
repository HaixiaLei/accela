//
//  BindBankCardCheckViewController.h
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindBankCardCheckViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *accountNameTxt;
@property (nonatomic, weak) IBOutlet UITextField *accountNoTxt;

-(IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)bindBankCardInsertInfoVC:(id)sender;
@end
