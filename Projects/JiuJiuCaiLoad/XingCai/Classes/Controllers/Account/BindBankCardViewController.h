//
//  BindBankCardViewController.h
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindBankCardViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tixianPin;

-(IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)bindBankCardCheckVC:(id)sender;
@end
