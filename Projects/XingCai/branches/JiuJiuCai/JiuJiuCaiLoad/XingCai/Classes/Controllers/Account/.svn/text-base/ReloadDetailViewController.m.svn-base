//
//  ReloadDetailViewController.m
//  JiuJiuCai
//
//  Created by hadis on 15-4-10.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "ReloadDetailViewController.h"
#import "ReloadFinishViewController.h"
@interface ReloadDetailViewController ()
{
    NSString *bankId;
    NSString *bidStr;
    NSString *amount;
    UIButton *doneButton;

}

@end

@implementation ReloadDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.bankname isEqualToString:@"abc"]) {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_ns"] forState:UIControlStateNormal];
    } else if ([self.bankname isEqualToString:@"icbc"]) {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_gs"] forState:UIControlStateNormal];

    }else if ([self.bankname isEqualToString:@"ccb"]) {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_js"] forState:UIControlStateNormal];

    }else if ([self.bankname isEqualToString:@"cmb"]) {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_zs"] forState:UIControlStateNormal];

    }
    
    self.inputMoney.keyboardType =UIKeyboardTypeNumberPad;
  

    [[AppHttpManager sharedManager] bankInfoWithBankCode:self.bankname block:^(id JSON, NSError *error) {
        
        if (!error) {
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic_bankinfo = [JSON objectForKey:@"bankinfo"];
                NSDictionary *dic_bankname = [dic_bankinfo objectForKey:self.bankname];
                NSLog(@"%@",dic_bankname);
                self.tipstring.text=[NSString stringWithFormat:@"注: 单笔最低充值额度为%@,最高为%@。",[dic_bankname objectForKey:@"loadmax"],[dic_bankname objectForKey:@"loadmin"]];
            
                NSArray *array_banklist  =[JSON objectForKey:@"banklist"];
                if (array_banklist.count>0) {
                    
                    self.bankAccount.text = [[array_banklist objectAtIndex:0] objectForKey:@"account"];
                    bidStr=[[array_banklist objectAtIndex:0] objectForKey:@"bank_id"];
                    bankId=[[array_banklist objectAtIndex:0] objectForKey:@"id"];


                }
                
               
        
               
                

            }
        }
    }];

}
- (void)keyboardWillShow:(NSNotification *)note
{
    if (!doneButton)
    {
        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    if (SystemVersion >= 7.0)
    {
        doneButton.frame = CGRectMake(0, 163, 104, 54);
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitle:@"完成" forState:UIControlStateHighlighted];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"btn_finished-568h"] forState:UIControlStateHighlighted];
    }
    else
    {
        doneButton.frame = CGRectMake(0, 163, 105, 54);
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitle:@"完成" forState:UIControlStateHighlighted];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"btn_finished"] forState:UIControlStateHighlighted];
    }
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // locate keyboard view
    int windowCount = [[[UIApplication sharedApplication] windows] count];
    if (windowCount < 2)
    {
        return;
    }
    
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView *keyboard;
    
    for(int i = 0; i < [tempWindow.subviews count]; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
        {
            UIButton *searchbtn = (UIButton*)[keyboard viewWithTag:67123];
            if (searchbtn == nil)
            {
                //to avoid adding again and again as per my requirement (previous and next button on keyboard)
                if (![keyboard.subviews containsObject:doneButton])
                {
                    [keyboard addSubview:doneButton];
                }
            }
        }//This code will work on iOS 8.0
        else if([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)
        {
            for(int i = 0; i < [keyboard.subviews count]; i++)
            {
                UIView *hostkeyboard = [keyboard.subviews objectAtIndex:i];
                
                if([[hostkeyboard description] hasPrefix:@"<UIInputSetHost"] == YES)
                {
                    UIButton *donebtn = (UIButton*)[hostkeyboard viewWithTag:67123];
                    if (donebtn == nil)
                    {
                        //to avoid adding again and again as per my requirement (previous and next button on keyboard)
                        if (![hostkeyboard.subviews containsObject:doneButton])
                        {
                            [hostkeyboard addSubview:doneButton];
                        }
                    }
                }
            }
        }
    }
}
- (void)keyboardHide:(NSNotification *)note
{
    [doneButton removeFromSuperview];
}
- (void)doneButton:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoFinish:(id)sender {
    ReloadFinishViewController *reloadVC = [[ReloadFinishViewController alloc] init];
    reloadVC.bankID=bankId;
    reloadVC.bidStr=bidStr;
    reloadVC.amountStr=self.inputMoney.text;
    reloadVC.bankTag=self.bankname;
    [self.inputMoney resignFirstResponder];
    [self.navigationController pushViewController:reloadVC animated:YES];
}

- (IBAction)returnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
