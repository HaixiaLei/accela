//
//  BindBankCardConfirmViewController.h
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindBankCardConfirmViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *userNameLab;
@property (nonatomic, weak) IBOutlet UILabel *bankNameLab;
@property (nonatomic, weak) IBOutlet UILabel *provinceLab;
@property (nonatomic, weak) IBOutlet UILabel *cityLab;
@property (nonatomic, weak) IBOutlet UILabel *branchLab;
@property (nonatomic, weak) IBOutlet UILabel *accountNameLab;
@property (nonatomic, weak) IBOutlet UILabel *accountNoLab;

-(IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)bindBankCardSuccessfulVC:(id)sender;
@end
