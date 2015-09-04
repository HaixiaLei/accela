//
//  BindBankCardInsertInfoViewController.h
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankListPicker.h"
#import "ProvinceListPicker.h"
#import "CityListPicker.h"

@interface BindBankCardInsertInfoViewController : UIViewController<BankListPickerDelegate, ProvinceListPickerDelegate, CityListPickerDelegate, UITextFieldDelegate>
{
    NSMutableArray *bankListArr;
    NSMutableArray *bankNameArr;
    int bankIndex;
    NSString *bankListText;
    
    NSMutableArray *provinceListArr;
    NSMutableArray *provinceNameArr;
    int provinceIndex;
    NSString *provinceListText;
    
    NSMutableArray *cityListArr;
    NSMutableArray *cityNameArr;
    int cityIndex;
    NSString *cityListText;
    
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIView *bankListView;
@property (nonatomic, weak) IBOutlet UILabel *bankListLab;
@property (nonatomic, weak) IBOutlet BankListPicker *blp;

@property (weak, nonatomic) IBOutlet UIView *provinceListView;
@property (nonatomic, weak) IBOutlet UILabel *provinceListLab;
@property (nonatomic, weak) IBOutlet ProvinceListPicker *plp;

@property (weak, nonatomic) IBOutlet UIView *cityListView;
@property (nonatomic, weak) IBOutlet UILabel *cityListLab;
@property (nonatomic, weak) IBOutlet CityListPicker *clp;

@property (nonatomic, weak) IBOutlet UITextField *branchNameTxt;
@property (nonatomic, weak) IBOutlet UITextField *accountNameTxt;
@property (nonatomic, weak) IBOutlet UITextField *accountNoTxt;
@property (nonatomic, weak) IBOutlet UITextField *accountNoConfirmTxt;

-(IBAction)returnBtnClk:(UIButton *)sender;

-(IBAction)bankListClk:(id)sender;
-(IBAction)bankCancelClk:(id)sender;
-(IBAction)bankOKClk:(id)sender;

-(IBAction)provinceListClk:(id)sender;
-(IBAction)provinceCancelClk:(id)sender;
-(IBAction)provinceOKClk:(id)sender;

-(IBAction)cityListClk:(id)sender;
-(IBAction)cityCancelClk:(id)sender;
-(IBAction)cityOKClk:(id)sender;


-(IBAction)bindBankCardConfirmInfoVC:(id)sender;

@end
