//
//  BuyFinishViewController.m
//  XingCai
//
//  Created by Bevis on 14-1-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BuyFinishViewController.h"
#import "BuyChooseViewController.h"
#import "ModeObject.h"
#import "BettingInformation.h"
#import "LotteryInformation.h"
#import "BuyChooseViewController.h"
#import "DAKeyboardControl.h"
#import "BetNumberCell.h"
#import "BetNumberBottomCell.h"
#import "JiangQiManager.h"
#import "AppAlertView.h"
#import "UIViewController+CustomNavigationBar.h"
#import "AccelaUniversalDoneButton.h"
@interface BuyFinishViewController ()
@end

@implementation BuyFinishViewController
{
    //投注信息
    NSMutableArray *lotteryInformations;
    
    NSMutableArray *lotteryInformationsSorted;
    //投注总金额
    long long total_money;
    //投注总注数
    int total_nums;
    
    BOOL zhuiHaoEnable;
    
    AppAlertView *makeSureAlertView;
    UIButton *doneButton;
}

@synthesize stopWhenWinSelectButton;

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    if (lotteryInformations.count > 0) {
        self.removeBtn.enabled = YES;
    }

    [self addKeyboardHandler];
}
- (void)viewDidAppear:(BOOL)animated
{
    DDLogDebug(@"BuyFinishViewController viewDidAppear");
    
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = YES;
    [JiangQiManager sharedManager].kindOfLottery = self.buyChooseViewController.kindOfLottery;
}

- (void)viewDidDisappear:(BOOL)animated
{
    DDLogDebug(@"BuyFinishViewController viewDidDisappear");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self.view removeKeyboardControl];

    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AccelaUniversalDoneButton sharedSetupToNumberPadInView:self.view];
    DDLogDebug(@"BuyFinishViewController viewDidLoad");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
    
    //Air 2014-04－16注销，标题要改为“重庆时时彩投注列表”,以后上新疆、江西，要根据彩种灵活改标题。
    //self.titleLabel.text = self.titleLabelText;
    
    self.timeOfChase = 1;
    self.times = 1;
    
    [self updateBettingInformations];
    
    zhuiHaoEnable = NO;
    
//    self.containerView.point=CGPointMake(0, 0);
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(0, 0, 40, 40);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"btn_return_normal"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backsomeMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backtoOne = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem=backtoOne;
    
    self.navigationItem.title=self.buyChooseViewController.kindOfLottery.cnname;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, self.tableView.bounds.size.width, 400)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView addSubview:topView];
}
-(void)backsomeMethod:(UIButton *)backtoOne
{
     
    if (lotteryInformations.count == 0) {
        [self cleanUpAndPop];
    }
    else
    {
        [Utility showErrorWithMessage:@"确定退出投注吗？退出投注您的号码将不被保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeBackButton duplicationPrevent:YES];
    }

}
- (void)addKeyboardHandler
{
    self.view.keyboardTriggerOffset = self.chooseContainerView.bounds.size.height;
    
    UIView *toolBar = self.chooseContainerView;
    float viewHeight = self.view.frame.size.height;
    float bottomHeight = self.bottomView.frame.size.height;
    
//    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView)
    {
        //收起键盘
        if (keyboardFrameInView.origin.y == viewHeight)
        {
            CGRect toolBarFrame = toolBar.frame;
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - bottomHeight - toolBarFrame.size.height;
            if (SystemVersion >= 7.0) {
//                toolBarFrame.origin.y -= 20;
            }
            toolBar.frame = toolBarFrame;
            
//            [weakSelf updateTableView];
        }
        else
        {
            CGRect toolBarFrame = toolBar.frame;
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
            if (SystemVersion >= 7.0)
            {
//                toolBarFrame.origin.y -= 20;
            }
            toolBar.frame = toolBarFrame;
        }
    }];
    
    [self updateTableViewFrame]; 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [doneButton removeFromSuperview];
}


#pragma mark - 按钮事件
//增加手选号码
- (IBAction)addMoreNumber:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    [self.view removeKeyboardControl];

    if ([self checkNumberOfRowsInSection])
    {
        BuyChooseViewController *buyChooseViewController = [[BuyChooseViewController alloc] initWithNibName:@"BuyChooseViewController" bundle:nil];
        buyChooseViewController.buyFinishViewController = self;
        buyChooseViewController.isChooseMore = YES;
        buyChooseViewController.kindOfLottery = self.buyChooseViewController.kindOfLottery;
        [buyChooseViewController setMenuAndRule:[self.buyChooseViewController menuAndRule]];
        [self.buyChooseViewController setBuyChooseViewControllerIndex:buyChooseViewController];
        [self.view endEditing:YES];
        [self.navigationController pushViewController:buyChooseViewController animated:YES];
    }
 
}
-(BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}
//增加机选号码
- (IBAction)gotoRandomLottery:(id)sender
{
    if ([self checkNumberOfRowsInSection])
    {
        self.buyChooseViewController.buyFinishViewController = self;
        [self.buyChooseViewController addRandomNumber];
    }
    self.removeBtn.enabled = YES;
}
//- (IBAction)returnBtnClk:(id)sender
//{
//    //如果没有投注信息，就不啰嗦提示了
//    if (lotteryInformations.count == 0) {
//        [self cleanUpAndPop];
//    }
//    else
//    {
//        [Utility showErrorWithMessage:@"确定退出投注吗？退出投注您的号码将不被保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeBackButton duplicationPrevent:YES];
//    }
//}
- (IBAction)confirmBet:(id)sender
{
    if (!lotteryInformations || lotteryInformations.count == 0) {
        [Utility showErrorWithMessage:@"请至少选择一注"];
        return;
    }
    
    KindOfLottery *kindOfLottery = self.buyChooseViewController.kindOfLottery;
    if (!kindOfLottery.latestJiangQi) {
        [Utility showErrorWithMessage:@"奖期未获取成功，请稍后重试"];
        [[JiangQiManager sharedManager] updateAllJiangQi];
        return;
    }
    else if(!kindOfLottery.latestKeZhuiHaoJiangQi) {
        [Utility showErrorWithMessage:@"可追号奖期未获取成功，请稍后重试"];
        [[JiangQiManager sharedManager] updateAllJiangQi];
        return;
    }
    
    //排序
    [self sortLotteryInformations];
    
    NSString *lastModeId;
    if (self.beginChaseSelectButton.selected) {
        NSMutableString *message = [NSMutableString stringWithFormat:@"确定要追号%ld期?\n",(long)self.timeOfChase];
        for (int i = 0; i < lotteryInformationsSorted.count; ++i) {
            LotteryInformation *lotteryInformation = [lotteryInformationsSorted objectAtIndex:i];
            if (![lotteryInformation.mode.modeid isEqualToString:lastModeId]) {
                [message appendFormat:@"%@\n%@\n",lotteryInformation.mode.name,lotteryInformation.bettingInformation.desc];
            }
            else
            {
                [message appendFormat:@"%@\n",lotteryInformation.bettingInformation.desc];
            }
            lastModeId = lotteryInformation.mode.modeid;
        }
        [message appendFormat:@"\n\n总金额:%@元",self.betMoney.text];
        
      makeSureAlertView = [Utility showErrorWithMessage:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeChaseConfirm duplicationPrevent:YES];
        DDLogDebug(@"makeSureAlertView=%p\n message=%@",makeSureAlertView,makeSureAlertView.message);
    }
    else
    {
        NSString *currentJiangQi = kindOfLottery.currentJiangQi;
        NSMutableString *message = [NSMutableString stringWithFormat:@"你确定加入%@期?\n",currentJiangQi];
        for (int i = 0; i < lotteryInformationsSorted.count; ++i) {
            LotteryInformation *lotteryInformation = [lotteryInformationsSorted objectAtIndex:i];
            if (![lotteryInformation.mode.modeid isEqualToString:lastModeId]) {
                [message appendFormat:@"%@\n%@\n",lotteryInformation.mode.name,lotteryInformation.bettingInformation.desc];
            }
            else
            {
                [message appendFormat:@"%@\n",lotteryInformation.bettingInformation.desc];
            }
            lastModeId = lotteryInformation.mode.modeid;;
        }
        [message appendFormat:@"\n\n总金额:%@元",self.betMoney.text];
        makeSureAlertView = [Utility showErrorWithMessage:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeConfirm duplicationPrevent:YES];
        DDLogDebug(@"makeSureAlertView=%p\n message=%@",makeSureAlertView,makeSureAlertView.message);
    }
}

- (IBAction)removeAllNumbers:(id)sender {
    [Utility showErrorWithMessage:@"您确定要清空当前的投注内容？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeRemoveAll duplicationPrevent:YES];
}

- (IBAction)beginChaseClk:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.stopWhenWinSelectButton.enabled = sender.selected;
    self.stopWhenWinSelectButton.selected = sender.selected;
    zhuiHaoEnable = !zhuiHaoEnable;
    if (zhuiHaoEnable) {
        self.chaseView.alpha = 1.0f;
    }
    else
    {
        self.chaseView.alpha = 0.3f;
    }
    
    self.timesLB.text = sender.selected ? @"追" : @"投";
    self.timesTF.text = @"1";
    
    if ([self.timesTF.text integerValue] > 999 && sender.selected) {
        self.timesTF.text = [NSString stringWithFormat:@"%d",999];
    }
    
    [self updateBettingInformations];
}

- (IBAction)stopWhenWinClk:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertViewTypeSuccess) {
        [self cleanUpAndPop];
    }
    else if(alertView.tag == AlertViewTypeBackButton)
    {
        switch (buttonIndex) {
            case 1:
                [self cleanUpAndPop];
                break;
            default:
                break;
        }
    }
    else if(alertView.tag == AlertViewTypeConfirm || alertView.tag == AlertViewTypeChaseConfirm)
    {
        switch (buttonIndex) {
            case 1:
                [self payMoney];
                break;
            default:
                break;
        }
    }
    else if(alertView.tag == AlertViewTypeErrorBlocked)
    {
        switch (buttonIndex) {
            case 1:
                [self cleanUpAndPop];
                break;
            default:
                break;
        }
    }
    else if(alertView.tag == AlertViewTypeRemoveAll)
    {
        switch (buttonIndex) {
            case 1:
                [self cleanAllNumbers];
                break;
            default:
                break;
        }
    }
}

#pragma mark - UITextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField;
//{
//    CGRect frame = self.containerView.frame;
//    frame.origin.y = SystemVersion < 7.0 ? -200 : -200;
//    self.containerView.frame = frame;
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.chaseTimesTF)
    {
         return zhuiHaoEnable;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *nowText = textField.text;
    if (nowText.length > 0)
    {
        //去掉开头的'0'
        for (int i = 0; i < nowText.length; ++i)
        {
            char aChar = [nowText characterAtIndex:i];
            if (aChar != '0')
            {
                nowText = [nowText substringFromIndex:i];
                break;
            }
        }
        
        textField.text = nowText;
    }
    
    if (textField == self.chaseTimesTF && [textField.text intValue] <= 0)
    {
        self.chaseTimesTF.text = @"1";
    }
    else if (textField == self.timesTF && [textField.text intValue] <= 0)
    {
        self.timesTF.text = @"1";
    }
    [self updateBettingInformations];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *nowText = textField.text;
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //不允许首个数字0
    if (newText.length == 1 && [newText isEqualToString:@"0"] && [nowText isEqualToString:@""]) {
        return NO;
    }
    
    KindOfLottery *kindOfLottery = self.buyChooseViewController.kindOfLottery;
    NSArray *keZhuiHaoJiangQis = kindOfLottery.keZhuiHaoJiangQis;
    
    if (textField == self.chaseTimesTF) {
        if ([kindOfLottery.cnname isEqualToString:@"重庆时时彩"]){
            if ([newText integerValue] > 120) {
                self.chaseTimesTF.text = @"120";
                return NO;
            }
            else if ([newText integerValue] > keZhuiHaoJiangQis.count) {
                self.chaseTimesTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)keZhuiHaoJiangQis.count];
                return NO;
            }
            
        }else
        {
                if ([newText integerValue] > 288) {
                    self.chaseTimesTF.text = @"288";
                    return NO;
                }
                else if ([newText integerValue] > keZhuiHaoJiangQis.count) {
                    self.chaseTimesTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)keZhuiHaoJiangQis.count];
                    return NO;
                }
                
        }
    }
    else if (textField == self.timesTF && [newText integerValue] > 10000 && !self.beginChaseSelectButton.selected) {
        self.timesTF.text = [NSString stringWithFormat:@"%d",10000];
        return NO;
    }
    else if (textField == self.timesTF && [newText integerValue] > 999 && self.beginChaseSelectButton.selected) {
        self.timesTF.text = [NSString stringWithFormat:@"%d",999];
        return NO;
    }
    return YES;
}
#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UI数据刷新
- (void)purchaseSucess
{    
    [Utility showErrorWithMessage:@"购买成功" delegate:self tag:AlertViewTypeSuccess];
}
- (void)purchaseFailed:(id)JSON error:(NSError *)error
{
    if (error.code == AppServerErrorBlocked) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)JSON;
            if ([dict.allKeys containsObject:@"content"]) {
                NSMutableString *message = [NSMutableString stringWithFormat:@"成功投注:%@单,失败:%@单。以下内容\n投注失败:\n",[dict objectForKey:@"success"],[dict objectForKey:@"fail"]];
                
                id content = [dict objectForKey:@"content"];
                if ([content isKindOfClass:[NSArray class]]) {
                    for (NSString *string in content) {
                        [message appendFormat:@"%@\n",[string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""]];
                    }
                }
                [message appendString:@"\n\n是否返回并清空所有投注项?"];
                [Utility showErrorWithMessage:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeErrorBlocked duplicationPrevent:YES];
            }
        }
    }
}

- (void)sortLotteryInformations
{
    NSMutableDictionary *sortedLotteryInformations = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < lotteryInformations.count; ++i) {
        LotteryInformation *lotteryInformation = [lotteryInformations objectAtIndex:i];
        
        if (![sortedLotteryInformations objectForKey:lotteryInformation.mode.modeid]) {
            NSMutableArray *array = [NSMutableArray array];
            [sortedLotteryInformations setObject:array forKey:lotteryInformation.mode.modeid];
        }
        NSMutableArray *array = [sortedLotteryInformations objectForKey:lotteryInformation.mode.modeid];
        [array addObject:lotteryInformation];
        [sortedLotteryInformations setObject:array forKey:lotteryInformation.mode.modeid];
    }
    
    NSMutableArray *newLotteryInformations = [NSMutableArray array];
    NSArray *allkeys = [sortedLotteryInformations allKeys];
    NSArray *sortedKeys = [allkeys sortedArrayUsingComparator:^(id obj1,id obj2)
    {
        return [obj1 compare:obj2];
    }];
    
    for (int i = 0; i < sortedKeys.count; ++i) {
        NSString *key = [sortedKeys objectAtIndex:i];
        NSMutableArray *array = [sortedLotteryInformations objectForKey:key];
        [newLotteryInformations addObjectsFromArray:array];
    }
    lotteryInformationsSorted = newLotteryInformations;
}

- (void)cleanAllNumbers
{
    NSUInteger count = lotteryInformations.count;
    [lotteryInformations removeAllObjects];
    [self updateBettingInformations];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < count; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    self.removeBtn.enabled = NO;
}

- (void)cleanUpAndPop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view removeKeyboardControl];
    [self.buyChooseViewController cleanSelectNumber];
    [self.navigationController popViewControllerAnimated:YES];
}

//判断是否超过30单
- (BOOL)checkNumberOfRowsInSection
{
    BOOL isOK = lotteryInformations.count < 30;
    if (!isOK) {
        [Utility showErrorWithMessage:@"最多投注30单！"];
    }
    return isOK;
}

- (BOOL)betNumberExist:(NSString *)betNumber title:(NSString *)title name:(NSString *)name
{
    BOOL exist = NO;
    
    for(LotteryInformation *lotteryInfomation in lotteryInformations)
    {
        NSString *showDesc = lotteryInfomation.bettingInformation.showDesc;
        showDesc = [showDesc substringFromIndex:1];
        showDesc = [showDesc substringToIndex:showDesc.length - 1];
        NSArray *subStrings = [showDesc componentsSeparatedByString:@"_"];
        NSString *aTitle = [subStrings firstObject];
        NSString *aName = [subStrings lastObject];
        
        if ([aTitle isEqualToString:title] && [aName isEqualToString:name] && [lotteryInfomation.bettingInformation.codes isEqualToString:betNumber]) {
            exist = YES;
            break;
        }
    }
    
    return exist;
}

- (NSInteger)totalBetNumberWithTitle:(NSString *)title name:(NSString *)name
{
    NSInteger total = 0;
    
    for(LotteryInformation *lotteryInfomation in lotteryInformations)
    {
        NSString *showDesc = lotteryInfomation.bettingInformation.showDesc;
        showDesc = [showDesc substringFromIndex:1];
        showDesc = [showDesc substringToIndex:showDesc.length - 1];
        NSArray *subStrings = [showDesc componentsSeparatedByString:@"_"];
        NSString *aTitle = [subStrings firstObject];
        NSString *aName = [subStrings lastObject];
        if ([aTitle isEqualToString:title] && [aName isEqualToString:name]) {
            total++;
        }
    }
    return total;
}
#pragma mark - 下注数据
- (void)addLotteryInformation:(LotteryInformation *)lotteryInformation
{
    if (!lotteryInformations) {
        lotteryInformations = [NSMutableArray array];
    }
    [lotteryInformations insertObject:lotteryInformation atIndex:0];
    
    [self updateBettingInformations];
    
//    [self updateTableView];
    
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
- (void)deleteLotteryInformationAtIndex:(NSInteger)index
{
    [lotteryInformations removeObjectAtIndex:index];
    if (lotteryInformations.count == 0) {
        self.removeBtn.enabled = NO;
    }
    [self updateBettingInformations];
    
//    [self updateTableView];
    
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
- (void)updateBettingInformations
{
    self.timeOfChase = [self.chaseTimesTF.text integerValue];
    self.times = [self.timesTF.text longLongValue];
    
    total_money = 0;
    total_nums = 0;
    for (LotteryInformation *lotteryInformation in lotteryInformations) {
        BettingInformation *bettingInformation = lotteryInformation.bettingInformation;
        bettingInformation.times = [NSString stringWithFormat:@"%lli",self.times];
        long long money = 2 * self.times * [bettingInformation.nums integerValue];
        bettingInformation.money = [NSString stringWithFormat:@"%lli",(long long)(RateToInt * [lotteryInformation.mode.rate floatValue]) * money];
        
        
        total_nums += [bettingInformation.nums intValue];
        total_money += [bettingInformation.money longLongValue];
    }
    self.betNumber.text = [NSString stringWithFormat:@"共%d注",total_nums];
    self.betMoney.text = self.beginChaseSelectButton.selected ? [Utility formatStringFromDouble:(double)(total_money * self.timeOfChase) / RateToInt] : [Utility formatStringFromDouble:(double)total_money / RateToInt];
   
    [self.betNumber sizeToFit];
    [self.betMoney sizeToFit];
    [self.yuanLabel sizeToFit];
    
    int totalWidth = self.betNumber.frame.size.width + self.betMoney.frame.size.width + self.yuanLabel.frame.size.width + 5;
    int screenWidth = ScreenSize.width;
    
    if (totalWidth < 160) {
        int origin = screenWidth * 0.5 - totalWidth * 0.7;
        
        self.betNumber.point = CGPointMake(origin, 12);
        origin += self.betNumber.frame.size.width + 5;
        
        self.betMoney.point = CGPointMake(origin, 12);
        origin += self.betMoney.frame.size.width;
        
        self.yuanLabel.point = CGPointMake(origin, 12);
    }
    else
    {
        self.betNumber.point = CGPointMake((screenWidth -149 - 65 - self.betNumber.frame.size.width)*0.5 + 78, 5);
        self.betMoney.point = CGPointMake((screenWidth -149 - 65 - self.betMoney.frame.size.width - self.yuanLabel.frame.size.width)*0.5 + 78 , 5 + self.betNumber.frame.size.height);
        self.yuanLabel.point = CGPointMake(self.betMoney.frame.origin.x + self.betMoney.frame.size.width, 5 + self.betNumber.frame.size.height);
    }
}

- (NSArray *)getBettingInformationPropertyArray
{
    NSMutableArray *bettingInformationProperties = [NSMutableArray array];
    for (int i = 0; i < lotteryInformations.count; ++i) {
        LotteryInformation *lotteryInformation = [lotteryInformations objectAtIndex:i];
        BettingInformation *bettingInformation = lotteryInformation.bettingInformation;
        
        //金额修正
        NSDictionary *bettingInformationPropertie = [Utility getProperties:bettingInformation];
        NSString *money = [bettingInformationPropertie objectForKey:@"money"];
        money = [Utility formatStringFromDouble:[money doubleValue] / RateToInt];
        [bettingInformationPropertie setValue:money forKey:@"money"];
        
        [bettingInformationProperties addObject:bettingInformationPropertie];
    }
    return bettingInformationProperties;
}

//判断是否为单一圆角分模式
//- (BOOL)isModeAllSame
//{
//    BOOL isOk = YES;
//    LotteryInformation *lotteryInformation = [lotteryInformations objectAtIndex:0];
//    NSString *modeid = lotteryInformation.mode.modeid;
//    
//    if (lotteryInformations.count >= 1) {
//        for (int i = 1; i < lotteryInformations.count; ++i) {
//            LotteryInformation *lotteryInformation = [lotteryInformations objectAtIndex:i];
//            if (![modeid isEqualToString:lotteryInformation.mode.modeid]) {
//                isOk = NO;
//                break;
//            }
//        }
//    }
//    return isOk;
//}

- (void)payMoney
{
    [self updateBettingInformations];
    
    NSArray *bettingInformationProperties = [self getBettingInformationPropertyArray];
    
    NSString *totalNums = [NSString stringWithFormat:@"%d",total_nums];
    NSString *totalMoney = self.betMoney.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    KindOfLottery *kindOfLottery = self.buyChooseViewController.kindOfLottery;
    
    LotteryInformation *lotteryInformation = [lotteryInformations objectAtIndex:0];
    //圆角分模式
    ModeObject *mode = lotteryInformation.mode;
    
    NSString *currentJiangQi = kindOfLottery.currentJiangQi;
    
    if (self.beginChaseSelectButton.selected == YES) {
    
        NSString *lt_trace_count_input = [NSString stringWithFormat:@"%ld",(long)self.timeOfChase];
        NSString *lt_trace_stop = self.stopWhenWinSelectButton.selected ? @"yes" : nil;

        NSArray *keZhuiHaoJiangQis = kindOfLottery.keZhuiHaoJiangQis;
       
        if (!keZhuiHaoJiangQis || keZhuiHaoJiangQis.count == 0) {
            [Utility showErrorWithMessage:@"当前未找到可追号奖期，请稍后重试"];
            return;
        }
        
        //投注追号接口
        [[AppHttpManager sharedManager] touZhuZhuiHaoWithKind:kindOfLottery lotteryid:self.lotteryid lt_issue_start:currentJiangQi bettingInformations:bettingInformationProperties lt_project_modes:mode.modeid lt_total_money:totalMoney lt_total_nums:totalNums lt_trace_count_input:lt_trace_count_input lt_trace_diff:@"1" lt_trace_if:@"yes" lt_trace_margin:@"50" lt_trace_money:totalMoney lt_trace_stop:lt_trace_stop lt_trace_times_diff:@"2" lt_trace_times_margin:@"1" lt_trace_times_same:self.timesTF.text keZhuiHaoJiangQis:keZhuiHaoJiangQis Block:^(id JSON, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (!error)
             {
                 [self purchaseSucess];
             }
             else
             {
                 DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                 [self purchaseFailed:JSON error:error];
             }
         }];
    }
    else
    {
        //投注接口
        [[AppHttpManager sharedManager] touZhuWithKind:kindOfLottery lotteryid:self.lotteryid lt_issue_start:currentJiangQi bettingInformations:bettingInformationProperties lt_project_modes:mode.modeid lt_total_money:totalMoney lt_total_nums:totalNums Block:^(id JSON, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (!error)
             {
                 [self purchaseSucess];
             }
             else
             {
                DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                 [self purchaseFailed:JSON error:error];
             }
         }];
    }
}
#pragma mark - UITableViewDelegate
- (void)updateTableViewFrame
{
    float totalHeight = self.chooseContainerView.frame.origin.y - self.tableView.frame.origin.y;

    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, totalHeight);
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:0];
    if (indexPath.row == numberOfRows - 1) {
        return 12;
    }
    else
    {
      return 72;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lotteryInformations.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *betNumberCell = @"BetNumberCell";
    static NSString *betNumberBottomCell = @"BetNumberBottomCell";
    
    NSInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:0];
    if (numberOfRows == 1 || (numberOfRows > 1 && indexPath.row == numberOfRows - 1))
    {
        BetNumberBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:betNumberBottomCell];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BetNumberBottomCell" owner:self options:nil];
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[BetNumberBottomCell class]]) {
                    cell = (BetNumberBottomCell *)oneObject;
                    break;
                }
            }
        }
        return cell;
    }
    else
    {
        BetNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:betNumberCell];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BetNumberCell" owner:self options:nil];
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[BetNumberCell class]]) {
                    cell = (BetNumberCell *)oneObject;
                    break;
                }
            }
        }
        LotteryInformation *lotteryInformation = [lotteryInformations objectAtIndex:indexPath.row];
        
        cell.betNumberLabel.text = lotteryInformation.bettingInformation.showCodes;
        cell.descLabel.text = lotteryInformation.bettingInformation.showDesc;
        cell.numberOfBetLabel.text = [NSString stringWithFormat:@"%@注",lotteryInformation.bettingInformation.nums];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@元",[Utility formatStringFromDouble:(double)([lotteryInformation.bettingInformation.money longLongValue] / [lotteryInformation.bettingInformation.times integerValue]) / RateToInt]];
//        cell.deleteButton.tag = indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
}

- (void)deleteButtonAction:(UIButton *)sender
{
    UIView *parentView = sender.superview;
    
    while (![parentView isKindOfClass:[BetNumberCell class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentView = parentView.superview;
    }
    

    NSIndexPath *indexPath = [self.tableView indexPathForCell:(BetNumberCell *)parentView];
    
    [self deleteLotteryInformationAtIndex:indexPath.row];
}

- (void)updateJiangQi:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[KindOfLottery class]]) {
        KindOfLottery *kindOfLottery = (KindOfLottery *)object;
        if (kindOfLottery == self.buyChooseViewController.kindOfLottery) {
            NSString *currentJiangQi = kindOfLottery.currentJiangQi;
            DDLogDebug(@"currentJiangQi:%@\nmakeSureAlertView:%p\n,visible=%@",currentJiangQi,makeSureAlertView,makeSureAlertView.visible ? @"YES":@"NO");
            if (makeSureAlertView) {
                NSString *message = makeSureAlertView.message;
                DDLogDebug(@"makeSureAlertView message:%@",message);
                NSRange range = [message rangeOfString:@"期"];
                range.length = range.location - 5;
                range.location = 5;
                message = [message stringByReplacingCharactersInRange:range withString:currentJiangQi];
                DDLogDebug(@"after update makeSureAlertView message:%@",message);
                makeSureAlertView.message = message;
            }
        }
    }
}
@end
