//
//  BindBankCardSuccessfulViewController.h
//  JiuJiuCai
//
//  Created by Air.Zhao on 15-4-8.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindBankCardSuccessfulViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
-(IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)gotoLoad:(UIButton *)sender;
@end
