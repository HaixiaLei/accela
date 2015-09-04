//
//  CashViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-2-8.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "CashViewController.h"
//#import "Utility.h"
#import "BankObject.h"

@interface CashViewController ()
@end

@implementation CashViewController
@synthesize pv;
@synthesize btnTitleLab;
@synthesize bannerView;
@synthesize availableBalanceLab;
@synthesize userLab;
@synthesize cashJinELab;
@synthesize cashTimesAndTime;
@synthesize danBiLab;
@synthesize lockV;
@synthesize alertV;
@synthesize alertUserLab;
@synthesize alertAvailableBalanceLab;
@synthesize alertJinELab;
@synthesize alertBankNameLab;
@synthesize alertProvinceLab;
@synthesize alertCityLab;
@synthesize alertAccountNameLab;
@synthesize alertAccountLab;
@synthesize nextBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//}
//- (void)keyboardWillShow:(NSNotification *)note
//{
//    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    for(int i = 0; i < [tempWindow.subviews count]; i++)
//    {
//        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        if (SystemVersion >= 7.0) {
//            doneButton.frame = CGRectMake(0, 163, 104, 54);
//            [doneButton setTitle:@"完成" forState:UIControlStateNormal];
//            [doneButton setTitle:@"完成" forState:UIControlStateHighlighted];
//            [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [doneButton setBackgroundImage:[UIImage imageNamed:@"btn_finished-568h"] forState:UIControlStateHighlighted];
//        }
//        else
//        {
//            doneButton.frame = CGRectMake(0, 163, 105, 54);
//            [doneButton setTitle:@"完成" forState:UIControlStateNormal];
//            [doneButton setTitle:@"完成" forState:UIControlStateHighlighted];
//            [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//            [doneButton setBackgroundImage:[UIImage imageNamed:@"btn_finished"] forState:UIControlStateHighlighted];
//        }
//        [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//        UIView *keyboard = [tempWindow.subviews objectAtIndex:i];
//        if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) || ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES))
//        {
//            if (![keyboard.subviews containsObject:doneButton])
//            {
//                [keyboard addSubview:doneButton];
//            }
//        }
//    }
//}
//- (void)doneButton:(id)sender {
//    [self.view endEditing:YES];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cashJinELab.delegate = self;
    
    bannerView.hidden = YES;
    pv.hidden = YES;
    
    [self getInfo];
    
    //[alertV.layer setCornerRadius:5];
}
- (void)getInfo
{
    NSMutableArray *bankNames = [NSMutableArray array];
    id JSON = self.JSON;
    if ([JSON isKindOfClass:[NSDictionary class]])
    {
        //读取可提款金额-用户名
        id obj = [JSON objectForKey:@"availablebalance"];
        if ([obj isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber *) obj;
            availableBalanceLab.text = [number stringValue];
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            availableBalanceLab.text = obj;
        }
        //读取可提取金额
        userLab.text = [JSON objectForKey:@"user"];
//        NSLog(@"%@",availableBalanceLab.text);
        //提款次数和时间
        NSString *totalTimes = [JSON objectForKey:@"times"];
        NSString *successTimes = [JSON objectForKey:@"count"];
        NSDictionary *cashTimeDic = [JSON objectForKey:@"wraptime"];
        NSString *beginTime = [cashTimeDic objectForKey:@"starttime"];
        NSString *endTime = [cashTimeDic objectForKey:@"endtime"];
        NSString *timesAndTime = [[[[[[[@"每天限制提款" stringByAppendingString:totalTimes] stringByAppendingString:@"次，您已经成功提款"] stringByAppendingString:successTimes] stringByAppendingString:@"次；提款时间为"] stringByAppendingString:beginTime] stringByAppendingString:@"至"] stringByAppendingString:endTime];
        cashTimesAndTime.text = timesAndTime;
        //单笔限制条件
        NSString *maxMoney = nil;
        id maxM = [JSON objectForKey:@"max_money"];
        if ([maxM isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber *) maxM;
            maxMoney = [number stringValue];
        }
        else if ([maxM isKindOfClass:[NSString class]])
        {
            maxMoney = maxM;
        }
        
        NSString *minMoney = nil;
        id minM = [JSON objectForKey:@"min_money"];
        if ([minM isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber *) minM;
            minMoney = [number stringValue];
        }
        else if ([minM isKindOfClass:[NSString class]])
        {
            minMoney = minM;
        }
        danBiLab.text = [[[[@"(单笔最低提现金额: " stringByAppendingString:minMoney] stringByAppendingString:@"元，最高: "] stringByAppendingString:maxMoney] stringByAppendingString:@"元)"];
        
        bankInfoArr = [[NSMutableArray alloc] init];
        bankConfirmArr = [[NSMutableArray alloc] init];
        NSArray *itemArray = [JSON objectForKey:@"banks"];
        for (int i = 0; i < itemArray.count; ++i)
        {
            id oneObject = [itemArray objectAtIndex:i];
            if ([oneObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                //DLog(@"------------------------->%@", [oneObjectDict objectForKey:@"bank_name"]);
                NSString *accountStr = [oneObjectDict objectForKey:@"account"];
                unsigned long beginIndex = accountStr.length - 4;
                NSString *lastFour = [[@"(尾号" stringByAppendingString:[accountStr substringFromIndex:beginIndex]] stringByAppendingString:@")"];
                [bankNames addObject:[[oneObjectDict objectForKey:@"bank_name"] stringByAppendingString:lastFour]];
                
                //bankInfo-确认提款信息接口-参数
                NSString *idd = [[oneObjectDict objectForKey:@"id"] stringByAppendingString:@"#"];
                NSString *bank_id = [oneObjectDict objectForKey:@"bank_id"];
                [bankInfoArr addObject:[idd stringByAppendingString:bank_id]];
                
                //提现时显示确认用户信息，把banks里的部分属性放到数组
                BankObject *bankObj = [[BankObject alloc] initWithAttribute:oneObjectDict];
                [bankConfirmArr addObject:bankObj];
            }
            else
            {
                DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
            }
        }
        [self.pv setBankNames:bankNames];
        [self.pv reloadAllComponents];
        btnTitleLab.text = [bankNames objectAtIndex:0];
    }
    else
    {
        DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)returnBtnClk:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)selectBtnClick:(id)sender
{
    bannerView.hidden = NO;
    nextBtn.enabled = false;
    pv.hidden = NO;
    [cashJinELab resignFirstResponder];
    if ( [btnTitleLab.text isEqualToString:@""])
    {
        btnTitleLab.text = [[self.pv bankNames] objectAtIndex:0];
    }
}
-(IBAction)okClick:(id)sender
{
    bannerView.hidden = YES;
    nextBtn.enabled = true;
    pv.hidden = YES;
}

- (void)bankPicker:(BankPicker *)picker didSelectBankWithName:(NSString *)name
{
    pickRowIndex = [pv selectRowNo];
    btnTitleLab.text = name;
}
//输入框回车
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [cashJinELab resignFirstResponder];
    nextBtn.enabled = true;
    return true;
}
//当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    bannerView.hidden = YES;
    pv.hidden = YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.cashJinELab resignFirstResponder];
    if (bannerView.hidden)
    {
        nextBtn.enabled = true;
    }
}
-(IBAction)nextClick:(id)sender
{
    int cash =[cashJinELab.text intValue];
    if ([cashJinELab.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"提款金额不得为空!"];
        return;
    }
    else if (cash<100)
    {
        [Utility showErrorWithMessage:@"提款金额最低为100!"];
        return;
    }
    else if (100000<cash)
    {
        [Utility showErrorWithMessage:@"提款金额不得高于100000!"];
        return;
    }

    lockV.hidden = NO;
    alertV.hidden = NO;
    
    alertUserLab.text = userLab.text;
  
    alertAvailableBalanceLab.text = availableBalanceLab.text;
    alertJinELab.text = cashJinELab.text;

    BankObject *bObj = [bankConfirmArr objectAtIndex:pickRowIndex];
    alertBankNameLab.text = [bObj bank_name];
    alertProvinceLab.text = [bObj province];
    alertCityLab.text = [bObj city];
    alertAccountNameLab.text = [bObj account_name];
    alertAccountLab.text = [bObj account];
}
- (IBAction)confirmAndSubmitAction:(id)sender
{
    alertV.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *bankInfo = [bankInfoArr objectAtIndex:[pv selectRowNo]];
    NSString *cashJinE = cashJinELab.text;
    
    NSString *check = self.check;
    //确认
    [[AppHttpManager sharedManager] queRenTiKuangXinXiWithCheck:check bankInfo:bankInfo money:cashJinE Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSString *cardid = [JSON objectForKey:@"cardid"];
                 NSString *money = [JSON objectForKey:@"money"];
                 //提交
                 [[AppHttpManager sharedManager] zuiZhongTiKuangXinXiWithCheck:check cardId:cardid money:money Block:^(id JSON, NSError *errcor)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          if ([JSON isKindOfClass:[NSDictionary class]])
                          {
                              NSString *msg = [JSON objectForKey:@"msg"];
                              msg = [NSString stringWithFormat:@"%@!",msg];
                              [Utility showErrorWithMessage:msg delegate:self];
                          }
                      }
                      else
                      {
                          DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                      }
                  }];
             }
             else
             {
                 DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             }
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             lockV.hidden = YES;
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        lockV.hidden = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)cancelAction:(id)sender
{
    lockV.hidden = YES;
    alertV.hidden  = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *nowText = textField.text;
    
    //防止出现多个"."
    if ([string isEqualToString:@"."]) {
        NSRange dotRange = [nowText rangeOfString:@"."];
        if (dotRange.location != NSNotFound)
        {
            return NO;
        }
    }
    
    NSRange dotRange = [newText rangeOfString:@"."];
    if (dotRange.location != NSNotFound) {
        //不允许首个数字'.'
        if (newText.length == 1 && [newText isEqualToString:@"."] && [nowText isEqualToString:@""]) {
            return NO;
        }
        //小数点后最多两位
        else if (newText.length - dotRange.location > 3) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        //不允许首个数字'0'
        if (newText.length == 1 && [newText isEqualToString:@"0"] && [nowText isEqualToString:@""]) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *nowText = textField.text;
    if (nowText.length > 0) {
        //去掉末尾的‘.’
        if ([[nowText substringFromIndex:nowText.length - 1] isEqualToString:@"."]) {
            nowText = [nowText substringToIndex:nowText.length - 1];
        }
        
        //去掉开头的'0'
        for (int i = 0; i < nowText.length; ++i) {
            char aChar = [nowText characterAtIndex:i];
            if (aChar != '0') {
                nowText = [nowText substringFromIndex:i];
                break;
            }
        }
        
        textField.text = nowText;
    }
}
@end
