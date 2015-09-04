//
//  ReloadDetailViewController.h
//  JiuJiuCai
//
//  Created by hadis on 15-4-10.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankPicker.h"

@interface ReloadDetailViewController : UIViewController<UITextFieldDelegate,BankPickerDelegate>
{
    int pickRowIndex;
    NSArray *array_banklist;
}

@property (weak, nonatomic) IBOutlet UIButton *choosebank;
@property (weak, nonatomic) IBOutlet UILabel *bankAccount;
@property (weak, nonatomic) NSString *bankname;
@property (weak, nonatomic) IBOutlet UILabel *tipstring;
@property (weak, nonatomic) IBOutlet UITextField *inputMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *moneyDaxie;
@property(nonatomic,weak) IBOutlet UIView *bannerView;
@property (nonatomic, weak) IBOutlet BankPicker *pv;

- (IBAction)gotoFinish:(id)sender;

- (IBAction)returnBack:(id)sender;

-(IBAction)selectBtnClick:(id)sender;

-(IBAction)okClick:(id)sender;
@end
