//
//  ReloadDetailViewController.h
//  JiuJiuCai
//
//  Created by hadis on 15-4-10.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReloadDetailViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *choosebank;
@property (weak, nonatomic) IBOutlet UILabel *bankAccount;
@property (weak, nonatomic) NSString *bankname;
@property (weak, nonatomic) IBOutlet UILabel *tipstring;
@property (weak, nonatomic) IBOutlet UITextField *inputMoney;

- (IBAction)gotoFinish:(id)sender;

- (IBAction)returnBack:(id)sender;
@end
