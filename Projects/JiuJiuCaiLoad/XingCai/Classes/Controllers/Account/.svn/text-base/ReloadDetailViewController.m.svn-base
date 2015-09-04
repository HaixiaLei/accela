//
//  ReloadDetailViewController.m
//  JiuJiuCai
//
//  Created by hadis on 15-4-10.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "ReloadDetailViewController.h"
#import "ReloadFinishViewController.h"
#import "AccelaUniversalDoneButton.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bannerView.hidden = YES;
    self.pv.hidden = YES;
    
    if ([self.bankname isEqualToString:@"abc"])
    {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_ns"] forState:UIControlStateNormal];
    }
    else if ([self.bankname isEqualToString:@"icbc"])
    {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_gs"] forState:UIControlStateNormal];
    }
    else if ([self.bankname isEqualToString:@"ccb"])
    {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_js"] forState:UIControlStateNormal];
    }
    else if ([self.bankname isEqualToString:@"cmb"])
    {
        [self.choosebank setBackgroundImage:[UIImage imageNamed:@"icon_zs"] forState:UIControlStateNormal];
    }
    
    self.inputMoney.keyboardType =UIKeyboardTypeNumberPad;

    [[AppHttpManager sharedManager] bankInfoWithBankCode:self.bankname block:^(id JSON, NSError *error)
    {
        if (!error)
        {
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic_bankinfo = [JSON objectForKey:@"bankinfo"];
                NSDictionary *dic_bankname = [dic_bankinfo objectForKey:self.bankname];
                NSLog(@"%@",dic_bankname);
                self.tipstring.text=[NSString stringWithFormat:@"注: 单笔最低充值额度为%@,最高为%@。",[dic_bankname objectForKey:@"loadmin"],[dic_bankname objectForKey:@"loadmax"]];
            
                array_banklist  =[JSON objectForKey:@"banklist"];
                if (array_banklist.count>0)
                {
                    self.bankAccount.text = [[array_banklist objectAtIndex:0] objectForKey:@"account"];
                    bidStr=[[array_banklist objectAtIndex:0] objectForKey:@"bank_id"];
                    bankId=[[array_banklist objectAtIndex:0] objectForKey:@"id"];
                }
                
                NSMutableArray *bankNames = [NSMutableArray array];
                for (int i=0; i<array_banklist.count; i++) {
                    [bankNames addObject:[NSString stringWithFormat:@"%@   %@",[[array_banklist objectAtIndex:i] objectForKey:@"bank_name"],[[array_banklist objectAtIndex:i] objectForKey:@"account"]]];
                }
                [self.pv setBankNames:bankNames];
                [self.pv reloadAllComponents];
            }
        }
    }];
    [AccelaUniversalDoneButton sharedSetupToNumberPadInView:self.view];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    self.bannerView.hidden = YES;
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
    if (self.inputMoney.text.length < 1 || self.inputMoney.text.floatValue == 0) {
        [Utility showErrorWithMessage:@"请输入充值金额!"];
        self.inputMoney.text = @"";
        return;
    }
    [self.inputMoney resignFirstResponder];
    [[AppHttpManager sharedManager] loadConfirmWithBankCode:self.bankname bankId:bidStr bankIdInBankInfo:bankId amount:self.inputMoney.text block:^(id JSON, NSError *error) {
        if (!error) {
        ReloadFinishViewController *reloadVC = [[ReloadFinishViewController alloc] init];
        reloadVC.JSON = JSON;
        [self.navigationController pushViewController:reloadVC animated:YES];
        }else{
        }
    }];
}

- (IBAction)returnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectBtnClick:(id)sender
{
    self.bannerView.hidden = NO;
    self.pv.hidden = NO;
}

-(IBAction)okClick:(id)sender
{
    self.bannerView.hidden = YES;
    self.pv.hidden = YES;
}

- (void)bankPicker:(BankPicker *)picker didSelectBankWithName:(NSString *)name
{
    pickRowIndex = [self.pv selectRowNo];
    self.bankAccount.text = [[array_banklist objectAtIndex:pickRowIndex] objectForKey:@"account"];
    bidStr=[[array_banklist objectAtIndex:pickRowIndex] objectForKey:@"bank_id"];
    bankId=[[array_banklist objectAtIndex:pickRowIndex] objectForKey:@"id"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *moneStr = [[NSMutableString alloc] init];
    [moneStr appendString:textField.text];
    if(![string isEqualToString:@""])
    {
        [moneStr appendString:string];
    }else{
        [moneStr deleteCharactersInRange:range];
    }
    NSLog(@"%@",[self toChineseAmount:moneStr]);
    self.moneyDaxie.text = [self toChineseAmount:moneStr];
    return YES;
}

//将数学金额转换为汉字大写金额
- (NSString *)toChineseAmount:(NSString *)amountStr
{
    if(amountStr.length == 0)
    {
        return @"零圆整";
    }
    
    NSRange range = [amountStr rangeOfString:@"."];
    NSInteger begin = [amountStr integerValue];
    NSInteger end = 0;
    if(range.length > 0)
    {
        begin = [[amountStr substringToIndex:range.location] integerValue];
        
        NSString *endstr = [amountStr substringFromIndex:range.location];
        float endF = [endstr floatValue];
        end = endF * 100;
    }
    NSMutableString *result = [[NSMutableString alloc] init];
    NSArray *ChinaUnits = @[@"仟", @"佰", @"拾", @""];
    NSArray *ChinaUnitss = @[@"亿", @"万", @"圆"];
    NSArray *ChinaNumbers = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    // 圆
    NSInteger base = 100000000;
    NSInteger temp = begin / base;
    begin %= base;
    for(int j = 0; j < 3; j++)
    {
        if(temp > 0)
        {
            NSInteger d = 1000;
            for(int i = 0; i < 4; i++)
            {
                NSInteger index = temp / d;
                temp %= d;
                d /= 10;
                if(index == 0 && result.length > 0)
                {
                    if(d > 0 && temp / d > 0)
                        [result appendFormat:@"%@", ChinaNumbers[index]];
                }
                else if(index > 0 && index < 10)
                    [result appendFormat:@"%@%@", ChinaNumbers[index], ChinaUnits[i]];
                
            }
            if(result.length > 0)
                [result appendString:ChinaUnitss[j]];
        }
        
        base /= 10000;
        if(base > 0)
        {
            temp = begin / base;
            begin %= base;
        }
    }
    range = [result rangeOfString:@"圆"];
    if(range.length == 0)
        [result appendString:@"圆"];
    
    // 角、分
    if(end > 0)
    {
        temp = end / 10;
        if(temp > 0)
            [result appendFormat:@"%@角", ChinaNumbers[temp]];
        else
            [result appendString:@"零"];
        temp = end % 10;
        if(temp > 0)
            [result appendFormat:@"%@分", ChinaNumbers[temp]];
        else
            [result appendString:@"整"];
    }
    else
        [result appendString:@"整"];
    
    return result;
}
@end
