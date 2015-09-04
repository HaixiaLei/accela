//
//  WithdrawViewController.m
//  HengCai
//
//  Created by jay on 14-8-7.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawObject.h"
#import "BankCardViewController.h"
#import "BankCardObject.h"
#import "DAKeyboardControl.h"

@interface WithdrawViewController ()
{
    NSMutableArray *datasource;
    NSString *bankInfo;
    
    NSString *account_name;
    
    NSString *amount_minStr;
    NSString *amount_maxStr;
}
@end

@implementation WithdrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self addKeyboardHandler];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.view removeKeyboardControl];
}
- (void)addKeyboardHandler
{
    float viewHeight = self.view.frame.size.height;
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView)
    {
        if (keyboardFrameInView.origin.y == viewHeight)
        {
            weakSelf.scrollView_vertical.scrollEnabled = YES;
            weakSelf.scrollView_vertical.contentOffset = CGPointMake(0, weakSelf.scrollView_vertical.contentSize.height - weakSelf.scrollView_vertical.frame.size.height);
        }
        else
        {
            weakSelf.scrollView_vertical.scrollEnabled = NO;
            float height = IS_IPHONE5 ? 212 : 242 + 60;
            weakSelf.scrollView_vertical.contentOffset = CGPointMake(0, height);
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adjustView];
    
    [self initDataScource];
    
    [self setUpPageControl];
    [self setUpPageFlowView];
    
    [self setUpLabels];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTaped:)];
    singleTap.numberOfTapsRequired = 1;
    [self.scrollView_vertical addGestureRecognizer:singleTap];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAction:)];
    singleTap.numberOfTapsRequired = 1;
    [self.submitButton addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0) {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
    
    frame = self.scrollView_vertical.frame;
    frame.size.height = IS_IPHONE5 ? 504 : 436;
    self.scrollView_vertical.frame = frame;
    
    float sizeHeight = IS_IPHONE5 ? 504 : 524;
    self.scrollView_vertical.contentSize = CGSizeMake(320, sizeHeight);
}

- (void)setUpPageFlowView
{
    self.pagedFlowView.delegate = self;
    self.pagedFlowView.dataSource = self;
    self.pagedFlowView.pageControl = self.pageControl;
    self.pagedFlowView.minimumPageAlpha = 0.3;
    self.pagedFlowView.minimumPageScale = 0.9;
}

- (void)setUpPageControl
{
    self.pageControl.numberOfPages = datasource.count;
}

- (void)initDataScource
{
    datasource = [NSMutableArray array];
    NSArray *bankCards = self.withdrawObject.banks;
    for (int i = 0; i < bankCards.count; ++i) {
        BankCardViewController *bankCardViewController = [[BankCardViewController alloc] initWithNibName:@"BankCardViewController" bundle:nil];
        BankCardView *bankCardView = (BankCardView *)bankCardViewController.view;
        BankCardObject *bankCardObject = [bankCards objectAtIndex:i];
        bankCardView.cardNameLB.text = bankCardObject.bank_name;
        bankCardView.cardNumberLB.text = bankCardObject.account;
        NSString *imageName = [self bankLogoImageName:bankCardObject];
        UIImage *image = [UIImage imageNamed:imageName];
        bankCardView.logoImageView.image = image;
        bankCardView.accountNameLB.text = [NSString stringWithFormat:@"持卡人:%@",bankCardObject.account_name];
        
        UIImage *pageImage = [Utility imageWithView:bankCardView];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:pageImage];
        [datasource addObject:imageView];
    }
}

- (NSString *)bankLogoImageName:(BankCardObject *)bankCardObject
{
    NSString *imageName = @"logo_bank_";
    
    if ([bankCardObject.bank_name rangeOfString:@"建设"].location != NSNotFound) {
        imageName = [imageName stringByAppendingString:@"7"];
    }
    else if ([bankCardObject.bank_name rangeOfString:@"工商"].location != NSNotFound) {
        imageName = [imageName stringByAppendingString:@"6"];
    }
    else if ([bankCardObject.bank_name rangeOfString:@"农业"].location != NSNotFound) {
        imageName = [imageName stringByAppendingString:@"10"];
    }
    else if ([bankCardObject.bank_name rangeOfString:@"招商"].location != NSNotFound) {
        imageName = [imageName stringByAppendingString:@"13"];
    }
    else
    {
        imageName = @"";
    }
    
    return imageName;
}

- (void)setUpLabels
{
    [self updateBankNameAtIndex:0];
    
    NSString *timeCount = [NSString stringWithFormat:@"*(每天限制提款%@次,您已经成功提款%@次)",self.withdrawObject.times,self.withdrawObject.count];
    self.timeCountLB.text = timeCount;
    NSString *timeScope = [NSString stringWithFormat:@"*(提款时间为%@至%@)",[self.withdrawObject.wraptime objectForKey:@"starttime"],[self.withdrawObject.wraptime objectForKey:@"endtime"]];
    self.timeScopeLB.text = timeScope;
    
    self.balanceLB.text = [NSString stringWithFormat:@"可用余额：%@",self.withdrawObject.availablebalance];
}

- (BOOL)userInputCorrect
{
    BOOL isCorrect = YES;
    NSString *amountStr = self.moneyAmountTF.text;
    float amount = [amountStr floatValue];
    float amount_min = [amount_minStr floatValue];
    float amount_max = [amount_maxStr floatValue];
    float balance = [self.withdrawObject.availablebalance floatValue];
    if (!amountStr || amountStr.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"提现金额不能为空!"];
    }
    else if (amount < amount_min) {
        isCorrect = NO;
        [Utility showErrorWithMessage:[NSString stringWithFormat:@"提现金额不能小于%@元！",amount_minStr]];
    }
    else if (amount > amount_max) {
        isCorrect = NO;
        [Utility showErrorWithMessage:[NSString stringWithFormat:@"提现金额不能大于%@元！",amount_maxStr]];
    }
    else if (amount > balance) {
        isCorrect = NO;
        NSString *message = [NSString stringWithFormat:@"可用余额不足，当前可用余额为：%@元", self.withdrawObject.availablebalance];
        [Utility showErrorWithMessage:message];
    }
    
    return isCorrect;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)submitAction:(id)sender {
    [self.view endEditing:YES];
    if (![self userInputCorrect]) {
        return;
    }
    
//    NSString *message = [NSString stringWithFormat:@"是否确认提现%@元现金到户主名为:%@ %@?",self.moneyAmountTF.text,account_name,self.bankNameLB.text];
    NSString *message = [NSString stringWithFormat:@"是否确认提现%@元现金到 %@?",self.moneyAmountTF.text,self.bankNameLB.text];
    [Utility showErrorWithMessage:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeWithdraw duplicationPrevent:YES];
}

- (void)submit
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] queRenTiKuangXinXiWithCheck:self.check bankInfo:bankInfo money:self.moneyAmountTF.text Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSString *cardid = [JSON objectForKey:@"cardid"];
                 NSString *money = [JSON objectForKey:@"money"];
                 //提交
                 [[AppHttpManager sharedManager] zuiZhongTiKuangXinXiWithCheck:self.check cardId:cardid money:money Block:^(id JSON, NSError *error)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          if ([JSON isKindOfClass:[NSDictionary class]])
                          {
                              NSString *msg = [JSON objectForKey:@"msg"];
                              [Utility showErrorWithMessage:[msg stringByAppendingString:@"！"] delegate:self tag:AlertViewTypeWithdrawSuccess];
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
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
     }];
}
- (void)scrollViewTaped:(id)sender
{
    self.moneyAmountBg.highlighted = NO;
    [self.scrollView_vertical resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)updateBankNameAtIndex:(NSInteger)index
{
    NSArray *bankCards = self.withdrawObject.banks;
    if (index >= 0 && index < bankCards.count) {
        BankCardObject *bankCardObject = [bankCards objectAtIndex:index];
        NSArray *components = [bankCardObject.account componentsSeparatedByString:@"*"];
        NSString *tailNumber = [components lastObject];
        NSString *bankName = [NSString stringWithFormat:@"%@(尾号%@)",bankCardObject.bank_name,tailNumber];
        self.bankNameLB.text = bankName;
        bankInfo = bankCardObject.bankInfo;
        
        account_name = bankCardObject.account_name;
        
        NSString *moneyScope = [NSString stringWithFormat:@"*(单笔最低提现金额:%@元 最高:%@元)",bankCardObject.min_money,bankCardObject.max_money];
        self.monyScopeLB.text = moneyScope;
        
        amount_minStr = bankCardObject.min_money;
        amount_maxStr = bankCardObject.max_money;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return CGSizeMake(240, 124);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    NSLog(@"Scrolled to page # %d", (int)pageNumber);
    [self updateBankNameAtIndex:pageNumber];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    return datasource.count;
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    UIView *pageView = [datasource objectAtIndex:index];
    return pageView;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.moneyAmountTF) {
        self.moneyAmountBg.highlighted = YES;
    }
    return YES;
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

-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        if (alertView.tag == AlertViewTypeWithdrawSuccess) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else
    {
        if (alertView.tag == AlertViewTypeWithdraw) {
            [self submit];
        }
    }
}
@end
