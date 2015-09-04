//
//  CashViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-2-8.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankPicker.h"

@interface CashViewController : UIViewController<BankPickerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    NSMutableArray *bankInfoArr;
    NSInteger pickRowIndex;
    NSMutableArray *bankConfirmArr;
}

@property (nonatomic, weak) IBOutlet BankPicker *pv;
@property(nonatomic, weak) IBOutlet UILabel *btnTitleLab;
@property(nonatomic,weak) IBOutlet UIView *bannerView;
@property(nonatomic,weak) IBOutlet UILabel *availableBalanceLab;
@property(nonatomic,weak) IBOutlet UILabel *userLab;
@property(nonatomic,weak) IBOutlet UITextField *cashJinELab;
@property(nonatomic,weak) IBOutlet UILabel *cashTimesAndTime;
@property(nonatomic,weak) IBOutlet UILabel *danBiLab;
@property (weak, nonatomic) IBOutlet UIView *lockV;
@property (weak, nonatomic) IBOutlet UIView *alertV;

@property(nonatomic,weak) IBOutlet UILabel *alertUserLab;
@property(nonatomic,weak) IBOutlet UILabel *alertAvailableBalanceLab;
@property(nonatomic,weak) IBOutlet UILabel *alertJinELab;
@property(nonatomic,weak) IBOutlet UILabel *alertBankNameLab;
@property(nonatomic,weak) IBOutlet UILabel *alertProvinceLab;
@property(nonatomic,weak) IBOutlet UILabel *alertCityLab;
@property(nonatomic,weak) IBOutlet UILabel *alertAccountNameLab;
@property(nonatomic,weak) IBOutlet UILabel *alertAccountLab;

@property(nonatomic, weak) IBOutlet UIButton *nextBtn;

@property(nonatomic,strong) id JSON;
@property(nonatomic,strong) NSString *check;

- (IBAction)returnBtnClk:(UIButton *)sender;

-(IBAction)okClick:(id)sender;
-(IBAction)selectBtnClick:(id)sender;
-(IBAction)nextClick:(id)sender;
- (IBAction)confirmAndSubmitAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
