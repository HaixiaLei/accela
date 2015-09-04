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
#import "AFAppAPIClient.h"
#import "BalanceObject.h"
#import "buyFinshObject.h"
#define originalHeight 25.0f
#define newHeight 85.0f
#define isOpen @"85.0f"

#import "SelectedNumber.h"
@interface BuyFinishViewController ()
@end

@implementation BuyFinishViewController
{
    //投注信息
//    NSMutableArray *lotteryInformations;
    
    NSMutableArray *codesArray;
    NSMutableArray *lotteryInformationsSorted;
    //投注总金额
    long long total_money;
    //投注总注数
    int total_nums;
    
    BOOL zhuiHaoEnable;
    
    AppAlertView *makeSureAlertView;
    NSInteger cellHeight;
    NSInteger selectedCell;
    NSIndexPath *currentindex;
    NSArray *moneyModes;
    BOOL markCell;
    
    NSMutableDictionary *dicClicked;
    UIButton *doneButton;
    
    //纪录betMoney的y位置
    float betMoneyY;
    
    //键盘弹出时遮挡tableview
    UIButton *coverTableButton;
    
    CGRect betMoneyFrame;
    CGRect balanceLabelFrame;
    CGRect yuanLabelFrame;
    CGRect balance_yuanFrame;
}

@synthesize stopWhenWinSelectButton;

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    //    //从新设置发起追号菜单的位置（键盘事件造成这里位置不对）
    //    UIView *toolBar = self.chooseContainerView;
    //    float viewHeight = self.view.frame.size.height;
    //    float bottomHeight = self.bottomView.frame.size.height;
    //    CGRect toolBarFrame = toolBar.frame;
    //    toolBarFrame.origin.y = viewHeight - bottomHeight - toolBarFrame.size.height;
    //    if (SystemVersion >= 7.0) {
    //        toolBarFrame.origin.y -= 20;
    //    }
    //    toolBar.frame = toolBarFrame;
//    [self updateBettingInformations];
//    [self.tableView reloadData];

    
//    for (LotteryInformation *lottetInfo in lotteryInformations) {
//        bfobject = [[buyFinshObject alloc]init];
//        bfobject.detail =lottetInfo.bettingInformation.showCodes;
//        bfobject.isExpand=NO;
//        [codesArray addObject:bfobject];
//    }
    NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
    NSString *lotterIDStr  =[[NSUserDefaults standardUserDefaults]objectForKey:@"lotterID"];
    int lotterID =[lotterIDStr intValue];
    self.kindOfLottery = [lotteryList objectAtIndex:lotterID];
  NSLog(@"%@---%@",self.kindOfLottery.curmid,self.kindOfLottery.nav);
    [self updateBettingInformations];
}
- (void)viewDidAppear:(BOOL)animated
{
    DDLogDebug(@"BuyFinishViewController viewDidAppear");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = YES;
    [JiangQiManager sharedManager].kindOfLottery = self.kindOfLottery;
    [self addKeyboardHandler];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DDLogDebug(@"BuyFinishViewController viewDidDisappear");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self.view removeKeyboardControl];
    [doneButton removeFromSuperview];
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = NO;
    if (self.beginChaseSelectButton.selected) {
        self.beginChaseSelectButton.selected=NO;
        self.stopWhenWinSelectButton.selected=NO;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DDLogDebug(@"BuyFinishViewController viewDidLoad");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
    
    //Air 2014-04－16注销，标题要改为“重庆时时彩投注列表”,以后上新疆、江西，要根据彩种灵活改标题。
    //self.titleLabel.text = self.titleLabelText;
    //    self.timesTF.borderStyle=UITextBorderStyleNone;
    //    [self.timesTF setBackground:[UIImage imageNamed:@"btn_dialog_normal"]];
   
    self.timeOfChase = 1;
    self.times = 1;
    
    [self.tableView reloadData];

    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"BuyFinsh"];

    [self adjustView];
    self.navigationItem.title=[[NSUserDefaults standardUserDefaults]objectForKey:@"JTITLE"];
    self.clearButton.titleEdgeInsets = UIEdgeInsetsMake(5, 30, 5, 10);
    self.buyButton.titleEdgeInsets = UIEdgeInsetsMake(5, 30, 5, 10);
    moneyModes  =[[NSArray alloc]initWithObjects:@"元",@"角",@"分",nil];
    dicClicked = [NSMutableDictionary dictionaryWithCapacity:3];
}
- (void)dealloc
{
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self.view removeKeyboardControl];
    [doneButton removeFromSuperview];
}
-(void)adjustView
{
    if (SystemVersion < 7.0)
    {
        self.containerView.point = CGPointZero;
        CGRect frame = self.containerView.frame;
        frame.size.height = 568;
        self.containerView.frame = frame;
    }
}

- (void)addKeyboardHandler
{
    self.view.keyboardTriggerOffset = self.chooseContainerView.bounds.size.height;
    
    UIView *toolBar = self.chooseContainerView;
    float viewHeight = self.view.frame.size.height;
    float bottomHeight = self.bottomView.frame.size.height;
    
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        //收起键盘
        if (keyboardFrameInView.origin.y == viewHeight) {
            CGRect toolBarFrame = toolBar.frame;
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - bottomHeight - toolBarFrame.size.height;
            //            if (SystemVersion >= 7.0) {
            //                toolBarFrame.origin.y -= 20;
            //            }
            toolBar.frame = toolBarFrame;
            weakSelf.zhuihaoBG.selected=NO;
            weakSelf.toubeiBG.selected=NO;
            
            
            //            [weakSelf updateTableView];
        }
        else
        {
            CGRect toolBarFrame = toolBar.frame;
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
            //            if (SystemVersion >= 7.0) {
            //                toolBarFrame.origin.y -= 20;
            //            }
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
#pragma mark - UIKeyboardDidShowNotification
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
//键盘完成按钮
- (void)doneButton:(id)sender
{
    [self.view endEditing:YES];
    [self.tableView reloadData];
    //    [self updateBetMoneyAndBetNumber]
}

#pragma mark - 按钮事件
//增加手选号码
//- (IBAction)addMoreNumber:(id)sender {
//    if ([self checkNumberOfRowsInSection]) {
//        BuyChooseViewController *buyChooseViewController = [[BuyChooseViewController alloc] initWithNibName:@"BuyChooseViewController" bundle:nil];
//        buyChooseViewController.buyFinishViewController = self;
//        buyChooseViewController.isChooseMore = YES;
//        buyChooseViewController.kindOfLottery = self.buyChooseViewController.kindOfLottery;
//        [buyChooseViewController setMenuAndRule:[self.buyChooseViewController menuAndRule]];
//        [self.buyChooseViewController setBuyChooseViewControllerIndex:buyChooseViewController];
//
//        [self.view endEditing:YES];
//        [self.navigationController pushViewController:buyChooseViewController animated:YES];
//    }
//}

//重写返回
- (void)backButtonClicked:(UIButton *)sender
{
    [self resumeOfDefaultValue];
    
//    [self.chaseTimesTF resignFirstResponder];
//    [self.timesTF resignFirstResponder];
//    if (self.beginChaseSelectButton.selected) {
//        self.beginChaseSelectButton.selected=NO;
//        self.stopWhenWinSelectButton.selected=NO;
//        self.stopWhenWinSelectButton.enabled = NO; //中奖后停止按钮默认是enable = NO,点击返回时恢复默认状态。#7873
//    }
//
//    zhuiHaoEnable = NO;
//    self.chaseView.alpha = 0.3f;

    if ([SelectedNumber getInstance].infoArray.count == 0) {
       
        [[SelectedNumber getInstance].infoArray removeAllObjects];
        [self cleanUpAndPop];
    }else {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//增加机选号码
//- (IBAction)gotoRandomLottery:(id)sender {
//    if ([self checkNumberOfRowsInSection]) {
//        self.buyChooseViewController.buyFinishViewController = self;
//        [self.buyChooseViewController addRandomNumber];
//    }
//}


- (IBAction)confirmBet:(id)sender
{
    NSLog(@"%@", self.kindOfLottery);
    if (![SelectedNumber getInstance].infoArray || [SelectedNumber getInstance].infoArray.count == 0) {
        [Utility showErrorWithMessage:@"请至少选择一注"];
        return;
    }
    
    if (!self.kindOfLottery.latestJiangQi) {
        [Utility showErrorWithMessage:@"奖期未获取成功，请稍后重试"];
        [[JiangQiManager sharedManager] updateAllJiangQi];
        return;
    }
    else if(!self.kindOfLottery.latestKeZhuiHaoJiangQi) {
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
        NSString *currentJiangQi = self.kindOfLottery.currentJiangQi;
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
    
    if (sender.selected == NO) {
        [self.chaseTimesTF resignFirstResponder];
    }
    else
    {
        [self.timesTF resignFirstResponder];
    }
    
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
    
    if ([self.timesTF.text integerValue] > 99999 && sender.selected) {
        self.timesTF.text = [NSString stringWithFormat:@"%d",99999];
    }
    [self.tableView reloadData];
    [self updateBettingInformations];
}

- (IBAction)stopWhenWinClk:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(void)coverTableBtnPressed:(UIButton *)btn{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
    if (zhuiHaoEnable)
    {
        if (textField == self.chaseTimesTF) {
            self.toubeiBG.selected = NO;
            self.zhuihaoBG.selected = YES;
        }else if (textField == self.timesTF) {
            self.toubeiBG.selected = YES;
            self.zhuihaoBG.selected = NO;
        }
    }
    
    return zhuiHaoEnable;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //增加遮挡tableview，键盘弹出时不可点击tableview
    if(!coverTableButton || !coverTableButton.superview){
        coverTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverTableButton setBackgroundColor:[UIColor clearColor]];
        UIView *tableSuperview = self.tableView.superview;
        coverTableButton.frame = tableSuperview.bounds;
        //把coverbutton加在table的上面
        [tableSuperview insertSubview:coverTableButton aboveSubview:self.tableView];
        [coverTableButton addTarget:self action:@selector(coverTableBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [coverTableButton setAlpha:0];
    }
    [coverTableButton setAlpha:1];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //让table上方的coverbutton隐藏
    if (coverTableButton && coverTableButton.superview) {
        [coverTableButton setAlpha:0];
    }
    
    NSString *nowText = textField.text;
    if (nowText.length > 0) {
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
    
    if (textField == self.chaseTimesTF && [textField.text intValue] <= 0) {
        self.chaseTimesTF.text = @"1";
    }
    else if (textField == self.timesTF && [textField.text intValue] <= 0) {
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
    NSLog(@"%@",self.kindOfLottery.lotteryName);
    NSArray *keZhuiHaoJiangQis = self.kindOfLottery.keZhuiHaoJiangQis;
    if (textField == self.chaseTimesTF) {
        if ([self.kindOfLottery.lotteryName isEqualToString:@"ssc"]) {
            if ([newText integerValue] > 120) {
                self.chaseTimesTF.text = @"120";
                return NO;
            }
            else if ([newText integerValue] > keZhuiHaoJiangQis.count) {
                self.chaseTimesTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)keZhuiHaoJiangQis.count];
                return NO;
            }

        }else if([self.kindOfLottery.lotteryName isEqualToString:@"rbssc"]){
            if ([newText integerValue] > 312) {
                self.chaseTimesTF.text = @"312";
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
    else if (textField == self.timesTF && [newText integerValue] > 99999 && self.beginChaseSelectButton.selected) {
        self.timesTF.text = [NSString stringWithFormat:@"%d",99999];
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

//重置默认值
-(void)resumeOfDefaultValue{
    [self.chaseTimesTF resignFirstResponder];
    [self.timesTF resignFirstResponder];
    self.beginChaseSelectButton.selected=NO;
    self.stopWhenWinSelectButton.selected=NO;
    self.stopWhenWinSelectButton.enabled = NO;
    self.chaseTimesTF.text = @"1";
    self.timesTF.text = @"1";
    self.timeOfChase = 1;
    self.times = 1;
    zhuiHaoEnable = NO;
    self.chaseView.alpha = 0.3f;
}

- (void)purchaseSucess
{
    //当购买成功后，重置默认值
    [self resumeOfDefaultValue];
    
    [Utility showErrorWithMessage:@"购买成功" delegate:self tag:AlertViewTypeSuccess];
}
- (void)purchaseFailed:(id)JSON error:(NSError *)error
{
    if (error.code == AppServerErrorBlocked) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)JSON;
            if ([dict.allKeys containsObject:@"msg"]) {
                NSMutableString *message = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:@"msg"]];
                
                [message appendString:@"是否返回并清空所有投注项?"];
                [Utility showErrorWithMessage:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeErrorBlocked duplicationPrevent:YES];
            }
        }
    }
}

- (void)sortLotteryInformations
{
    NSMutableDictionary *sortedLotteryInformations = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [SelectedNumber getInstance].infoArray.count; ++i) {
        LotteryInformation *lotteryInformation = [[SelectedNumber getInstance].infoArray objectAtIndex:i];
        
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
    NSUInteger count = [SelectedNumber getInstance].infoArray.count;
    
//    [lotteryInformations removeAllObjects];
    [codesArray removeAllObjects];
    [[SelectedNumber getInstance].infoArray removeAllObjects];
    [self updateBettingInformations];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < count; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)cleanUpAndPop
{
  
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view removeKeyboardControl];
    [self.buyChooseViewController cleanSelectNumber];
    [self cleanAllNumbers];
    [self.navigationController popViewControllerAnimated:YES];
}

//判断是否超过30单
- (BOOL)checkNumberOfRowsInSection
{
    BOOL isOK = [SelectedNumber getInstance].infoArray.count < 30;
    if (!isOK) {
        [Utility showErrorWithMessage:@"最多投注30单！"];
    }
    return isOK;
}

- (BOOL)betNumberExist:(NSString *)betNumber title:(NSString *)title name:(NSString *)name
{
    BOOL exist = NO;
    
    for(LotteryInformation *lotteryInfomation in [SelectedNumber getInstance].infoArray)
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
    
    for(LotteryInformation *lotteryInfomation in [SelectedNumber getInstance].infoArray)
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
//    if (!lotteryInformations) {
//        lotteryInformations = [NSMutableArray array];
//    }
//    if (!codesArray) {
//        codesArray = [NSMutableArray array];
//    }
//    buyFinshObject *bfobject = [[buyFinshObject alloc]init];
//    bfobject.detail =lotteryInformation.bettingInformation.showCodes;
//    
//    bfobject.isExpand=NO;
//    [codesArray addObject:bfobject];
//    [[SelectedNumber getInstance].infoArray addObject:lotteryInformation];

    [[SelectedNumber getInstance].infoArray insertObject:lotteryInformation atIndex:0];
 
    [self updateBettingInformations];
    
    if ([SelectedNumber getInstance].infoArray.count>0) {
        codesArray = [NSMutableArray array];
//        lotteryInformations =[NSMutableArray array];
        for (LotteryInformation *lotteryinfo in [SelectedNumber getInstance].infoArray) {
            buyFinshObject *bfobject = [[buyFinshObject alloc]init];
            bfobject.detail =lotteryinfo.bettingInformation.showCodes;
            bfobject.isExpand=NO;
            [codesArray addObject:bfobject];
//            [lotteryInformations addObject:lotteryinfo];
            NSLog(@"%@======-%@",bfobject.detail,lotteryInformation.bettingInformation.showCodes);
        }
    }
    
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}
- (void)deleteLotteryInformationAtIndex:(NSInteger)index
{
    [[SelectedNumber getInstance].infoArray removeObjectAtIndex:index];
//    [lotteryInformations removeObjectAtIndex:index];
    [self updateBettingInformations];
    //    [self updateTableView];
    
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
- (void)updateBettingInformations
{
    if (betMoneyFrame.size.width == 0) {
        betMoneyFrame = self.betMoney.frame;
        balanceLabelFrame = self.balanceLabel.frame;
        balance_yuanFrame = self.balance_yuan.frame;
        yuanLabelFrame = self.yuanLabel.frame;
    }
    
    
    
    self.timeOfChase = [self.chaseTimesTF.text integerValue];
    self.times = [self.timesTF.text longLongValue];
    
    
    total_money = 0;
    total_nums = 0;

//    if ([SelectedNumber getInstance].infoArray.count>0&&!lotteryInformations) {
//        lotteryInformations = [NSMutableArray array];
//        lotteryInformations=[SelectedNumber getInstance].infoArray;
//    }
    for (LotteryInformation *lotteryInformation in [SelectedNumber getInstance].infoArray) {
        BettingInformation *bettingInformation = lotteryInformation.bettingInformation;
        bettingInformation.times = [NSString stringWithFormat:@"%lli",self.times];
        
        //使用NSDecimalNumber类处理金额乘法
        NSString *timeS = [NSString stringWithFormat:@"%lld",self.times];
        NSString *time_S = [NSString stringWithFormat:@"%@",bettingInformation.time_s];
        NSString *numS = [NSString stringWithFormat:@"%@",bettingInformation.nums];
        NSString *moneyS = [Utility multiplyingDecimalNumberByMultiplicandAarray:@[@"2",timeS,numS]];
        NSString *money_S = [Utility multiplyingDecimalNumberByMultiplicandAarray:@[@"2",time_S,numS]];
        
//        long long money = 2 * self.times * [bettingInformation.nums integerValue];
//        long long money_s = 2 * [bettingInformation.time_s integerValue] * [bettingInformation.nums integerValue];
        long long money = [moneyS longLongValue];
        long long money_s = [money_S longLongValue];

        
        //        bettingInformation.money = [NSString stringWithFormat:@"%lli",(long long)(RateToInt * [lotteryInformation.mode.rate floatValue]) * money];
  
        if (!self.beginChaseSelectButton.selected) {
            
            bettingInformation.money = [NSString stringWithFormat:@"%lli",(long long)(RateToInt * [lotteryInformation.mode.rate floatValue]) * money_s];
            bettingInformation.times = bettingInformation.time_s;
            
        }else
        {
            bettingInformation.money = [NSString stringWithFormat:@"%lli",(long long)(RateToInt * [lotteryInformation.mode.rate floatValue]) * money];
        }
        total_nums += [bettingInformation.nums intValue];
        total_money += [bettingInformation.money longLongValue];
    }
    [[AFAppAPIClient sharedClient] getBalance_with_block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             BalanceObject *balanceObject = [[BalanceObject alloc] initWithDictionary:JSON];
             
//             //格式化，加入逗号分隔
//             NSNumberFormatter *formatter = [NSNumberFormatter new];
//             [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
//             [formatter setMinimumFractionDigits:4];
//             [formatter setMaximumFractionDigits:4];
//             [formatter setLocale:[NSLocale currentLocale]];
//             NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:[balanceObject.money doubleValue]]];
//             self.balanceLabel.text = formatted;
             
             self.balanceLabel.text = balanceObject.money;
             
             UILabel *tempLabel = [[UILabel alloc]init];
             tempLabel.font = self.balanceLabel.font;
             tempLabel.text = self.balanceLabel.text;
             [tempLabel sizeToFit];
             CGRect f = self.balanceLabel.frame;
             float offset = f.size.width - tempLabel.frame.size.width;
             if (offset > f.size.width/2) {
                 offset = f.size.width/2;
             }
             f.size.width -= offset;
             [self.balanceLabel setFrame:f];
             CGRect r = self.balance_yuan.frame;
             r.origin.x -= offset;
             [self.balance_yuan setFrame:r];
             
             if (self.balanceLabel.frame.size.width > balanceLabelFrame.size.width) {
                 [self.balanceLabel setFrame:balanceLabelFrame];
                 [self.balance_yuan setFrame:balance_yuanFrame];
             }
         }
     }];

//    self.betMoney.text = self.beginChaseSelectButton.selected ? [Utility formatStringFromDouble:(double)(total_money * self.timeOfChase) / RateToInt] : [Utility formatStringFromDouble:(double)total_money / RateToInt];
    NSString *betMoneyString = self.beginChaseSelectButton.selected ? [Utility formatStringFromDouble:(double)(total_money * self.timeOfChase) / RateToInt] : [Utility formatStringFromDouble:(double)total_money / RateToInt];
    self.betMoney.text = [Utility addDotForMoneyString:betMoneyString];
    
    if (self.betMoney.text.floatValue == 0) {
        //如果投注金额＝0 ，重置默认值
        [self resumeOfDefaultValue];
    }
    
    [self.betMoney setFrame:betMoneyFrame];
    [self.balanceLabel setFrame:balanceLabelFrame];
    [self.yuanLabel setFrame:yuanLabelFrame];
    [self.balance_yuan setFrame:balance_yuanFrame];
    UILabel *tempLabel = [[UILabel alloc]init];
    tempLabel.font = self.betMoney.font;
    tempLabel.text = self.betMoney.text;
    [tempLabel sizeToFit];
    CGRect f = self.betMoney.frame;
    float offset = f.size.width - tempLabel.frame.size.width;
    if (offset > f.size.width/2) {
        offset = f.size.width/2;
    }
    f.size.width -= offset;
    [self.betMoney setFrame:f];
    CGRect r = self.yuanLabel.frame;
    r.origin.x -= offset;
    [self.yuanLabel setFrame:r];
    
    if (self.betMoney.frame.size.width > betMoneyFrame.size.width) {
        [self.betMoney setFrame:betMoneyFrame];
        [self.yuanLabel setFrame:yuanLabelFrame];
    }
    
    
    
    
    
    
////    if (self.betMoney.text.length >= 10) {
////        self.betMoney.font = [UIFont systemFontOfSize:11];
////    }else{
////        self.betMoney.font = [UIFont systemFontOfSize:15];
////    }
//    
////  [self.balanceLabel sizeToFit];
////    [self.balance_yuan sizeToFit];
//    [self.betMoney sizeToFit];
////    [self.yuanLabel sizeToFit];
//    
//    int zhu_totalWidth = self.balanceLabel.frame.size.width + self.balance_yuan.frame.size.width;
//    int money_totalWidth = self.betMoney.frame.size.width + self.yuanLabel.frame.size.width;
//    int screenWidth = ScreenSize.width;
//    
//    int zhu_origin = screenWidth * 0.5 - zhu_totalWidth*0.4;
//    int money_origin = screenWidth * 0.5 - money_totalWidth*0.4;
//    
//    self.balanceLabel.point = CGPointMake(zhu_origin+10, self.balanceLabel.point.y);
//    zhu_origin += self.balanceLabel.frame.size.width;
//    
//    if (betMoneyY < 0.2) {
//        betMoneyY = self.betMoney.point.y;
//    }
    
//    if (self.betMoney.text.length >= 10) {
//        self.betMoney.point = CGPointMake(money_origin+4, betMoneyY+3.5);
//    }else{
//        self.betMoney.point = CGPointMake(money_origin+4, betMoneyY+1.5);
//    }
////    self.betMoney.point = CGPointMake(money_origin, self.betMoney.point.y);
//    money_origin += self.betMoney.frame.size.width;
//    
//    self.balance_yuan.point = CGPointMake(zhu_origin+10, self.balance_yuan.point.y);
//    self.yuanLabel.point = CGPointMake(money_origin+8, self.yuanLabel.point.y);
}

- (NSArray *)getBettingInformationPropertyArray
{
    NSMutableArray *bettingInformationProperties = [NSMutableArray array];
    for (int i = 0; i < [SelectedNumber getInstance].infoArray.count; ++i) {
        LotteryInformation *lotteryInformation = [[SelectedNumber getInstance].infoArray objectAtIndex:i];
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
    //去除金额的逗号
    totalMoney = [totalMoney stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    KindOfLottery *kindOfLottery;
    if (!self.buyChooseViewController.kindOfLottery) {
        kindOfLottery=self.kindOfLottery;
    }else
    {
       kindOfLottery = self.buyChooseViewController.kindOfLottery;

    }
    
    LotteryInformation *lotteryInformation = [[SelectedNumber getInstance].infoArray objectAtIndex:0];
    //圆角分模式
    ModeObject *mode = lotteryInformation.mode;
    
    if (!self.beginChaseSelectButton.selected) {
        lotteryInformation.bettingInformation.times=lotteryInformation.bettingInformation.time_s;
    }
    
    NSString *currentJiangQi = self.kindOfLottery.currentJiangQi;
    if (self.beginChaseSelectButton.selected == YES) {
        
        NSString *lt_trace_count_input = [NSString stringWithFormat:@"%ld",(long)self.timeOfChase];
        NSString *lt_trace_stop = self.stopWhenWinSelectButton.selected ? @"yes" : nil;
        NSLog(@"%@",lt_trace_stop);
        NSArray *keZhuiHaoJiangQis = self.kindOfLottery.keZhuiHaoJiangQis;
        
        if (!keZhuiHaoJiangQis || keZhuiHaoJiangQis.count == 0) {
            [Utility showErrorWithMessage:@"当前未找到可追号奖期，请稍后重试"];
            return;
        }
        
        //投注追号接口
        [[AFAppAPIClient sharedClient]trace_with_kind:kindOfLottery lotteryid:kindOfLottery.lotteryId lt_issue_start:currentJiangQi bettingInformations:bettingInformationProperties lt_project_modes:mode.modeid lt_total_money:totalMoney lt_total_nums:totalNums  lt_trace_count_input:lt_trace_count_input lt_trace_diff:@"1" lt_trace_if:@"yes" lt_trace_margin:@"50"  lt_trace_money:totalMoney lt_trace_stop:lt_trace_stop lt_trace_times_diff:@"2" lt_trace_times_margin:@"1" lt_trace_times_same:self.timesTF.text keZhuiHaoJiangQis:keZhuiHaoJiangQis Block:^(id JSON, NSError *error) {
            
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
        [[AFAppAPIClient sharedClient]bet_with_kind:kindOfLottery lotteryid:kindOfLottery.lotteryId lt_issue_start:currentJiangQi bettingInformations:bettingInformationProperties lt_project_modes:mode.modeid lt_total_money:totalMoney lt_total_nums:totalNums block:^(id JSON, NSError *error) {
            
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
    
    buyFinshObject *bfObject =(buyFinshObject*)[codesArray objectAtIndex:indexPath.row];
   
    if (bfObject.isExpand==NO||(bfObject.isExpand==YES&&bfObject.detail.length<19)) {
        return 90;
    }else
    {
        return 120;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return [[SelectedNumber getInstance].infoArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *betNumberCell = @"BetNumberCell";
    
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

   
       LotteryInformation *lotteryInformation = [[SelectedNumber getInstance].infoArray objectAtIndex:indexPath.row];
        
        
        if (!self.beginChaseSelectButton.selected) {

            NSString *descString  =lotteryInformation.bettingInformation.showDesc;
            NSCharacterSet *set =  [NSCharacterSet characterSetWithCharactersInString:@"[]"];
            NSString *trimmedString = [descString stringByTrimmingCharactersInSet:set];
            trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            buyFinshObject *bfobject  =[codesArray objectAtIndex:indexPath.row];
            cell.bfObject=bfobject;
           
            cell.betNumberLabel.text = lotteryInformation.bettingInformation.showCodes;
            cell.descLabel.text = trimmedString;
            cell.timesLabel.text =[NSString stringWithFormat:@"%@", lotteryInformation.bettingInformation.time_s];
            cell.numberOfBetLabel.text = [NSString stringWithFormat:@"%@",lotteryInformation.bettingInformation.nums];
            cell.moneyModesLable.text = [moneyModes objectAtIndex:[lotteryInformation.bettingInformation.mode intValue]-1];
            [cell.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //使用NSDecimalNumber类处理金额乘法
            NSString *betN = [NSString stringWithFormat:@"%@",lotteryInformation.bettingInformation.nums];
            NSString *timeS = [NSString stringWithFormat:@"%@",lotteryInformation.bettingInformation.time_s];
            NSString *rateS = [NSString stringWithFormat:@"%@",lotteryInformation.mode.rate];
            NSString *moneyString = [Utility multiplyingDecimalNumberByMultiplicandAarray:@[@"2",betN,timeS,rateS]];
            
            //给金额加上都好分隔
            cell.priceLabel.text = [Utility addDotForMoneyString:moneyString];
            if (cell.priceLabel.text.length >= 11) {
                [cell.priceLabel setFont:[UIFont systemFontOfSize:12]];
            }else{
                [cell.priceLabel setFont:[UIFont systemFontOfSize:15]];
            }
        }else
        {
          
            cell.betNumberLabel.text = lotteryInformation.bettingInformation.showCodes;
            /* 格式化玩法名称去掉括号和下划线 begin */
            NSString *descString  =lotteryInformation.bettingInformation.showDesc;
            NSCharacterSet *set =  [NSCharacterSet characterSetWithCharactersInString:@"[]"];
            NSString *trimmedString = [descString stringByTrimmingCharactersInSet:set];
            trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            cell.descLabel.text = trimmedString;
             /* 格式化玩法名称去掉括号和下划线 end */
            cell.numberOfBetLabel.text = [NSString stringWithFormat:@"%@",lotteryInformation.bettingInformation.nums];
            cell.timesLabel.text =[NSString stringWithFormat:@"%@",self.timesTF.text];
            cell.moneyModesLable.text = [moneyModes objectAtIndex:[lotteryInformation.bettingInformation.mode intValue]-1];

            //改为使用NSDecimalNumber类处理金额乘法
            NSString *betN = [NSString stringWithFormat:@"%@",cell.numberOfBetLabel.text];
            NSString *timeS = [NSString stringWithFormat:@"%@",self.timesTF.text];
            NSString *rateS = [NSString stringWithFormat:@"%@",lotteryInformation.mode.rate];
            NSString *moneyString = [Utility multiplyingDecimalNumberByMultiplicandAarray:@[@"2",betN,timeS,rateS]];
            
            //给金额加上都好分隔
            cell.priceLabel.text = [Utility addDotForMoneyString:moneyString];
            if (cell.priceLabel.text.length >= 11) {
                [cell.priceLabel setFont:[UIFont systemFontOfSize:12]];
            }else{
                [cell.priceLabel setFont:[UIFont systemFontOfSize:15]];
            }
        }

        return cell;
        
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BetNumberCell *cell = (BetNumberCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    
    if (!codesArray) {
        codesArray = [NSMutableArray array];
     
        for (LotteryInformation *lotteryinfo in [SelectedNumber getInstance].infoArray) {
            buyFinshObject *bfobject = [[buyFinshObject alloc]init];
            bfobject.detail =lotteryinfo.bettingInformation.showCodes;
            bfobject.isExpand=NO;
            [codesArray addObject:bfobject];
 
        }
    }

  
//    NSArray *array = [[codesArray reverseObjectEnumerator]allObjects];
    buyFinshObject *item=(buyFinshObject*)[codesArray objectAtIndex:indexPath.row];
    item.isExpand=!item.isExpand;
    NSLog(@"%d",item.isExpand);
    cell.bfObject=item;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [tableView reloadData];
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
        if (kindOfLottery == self.kindOfLottery) {
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
