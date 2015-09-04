//
//  BuyChooseViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "JiangQiManager.h"

#define NotificationUpdateIndex       @"NotificationUpdateIndex"

#define RateToInt 100

@class BuyFinishViewController;
@class KindOfLottery;
@interface BuyChooseViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate>
{
    //玩法选择,水平菜单scrollView
    UIScrollView *scrollViewForPlayMethod;
    UIScrollView *scrollviewForKinds;
    //玩法以及菜单数组
    NSArray *ruleAndMenuArray;
    //水平二级菜单
    NSMutableArray *verticalMenuItems;
    //水平二级菜单项
    NSMutableArray *verticalMenuButtons;
    
    UITextView *textview;//手动输入号码
    
    UIImageView *timeIV;
    UILabel *timerlabel;//倒计时
    UILabel *timerHMS;//倒计时
    UIImageView *lineIV;
    UIImageView *xlPicIV;
    
    //单式
    NSMutableArray *simpleArray;
    NSMutableArray *sameArray;
    
    //第一级菜单按钮数组
    NSMutableArray *secondBtnArr;
    AVAudioPlayer *player;
}

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIScrollView *ballScrollView;
@property(nonatomic,weak) IBOutlet UILabel *xlTitle;

@property (weak, nonatomic) IBOutlet UILabel *betMoney;//投注金额
@property (weak, nonatomic) IBOutlet UILabel *betNumber;//投入注数
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;

@property (weak, nonatomic) IBOutlet UIButton *finishSelectNum;
@property(nonatomic, weak) IBOutlet UIView *headerV;

@property (nonatomic, assign) BOOL isChooseMore;                //是否是增加手选号码模式
@property (nonatomic, weak) BuyFinishViewController *buyFinishViewController;
@property (nonatomic, strong) KindOfLottery *kindOfLottery;
@property (weak, nonatomic) IBOutlet UIView *lockV;

@property (strong, nonatomic) IBOutlet UIView *monyModeBoardView;
@property (strong, nonatomic) IBOutlet UIView *modeBoardView;
@property (weak, nonatomic) IBOutlet UIButton *defaultPrizeButton;  //奖金默认返点
@property (weak, nonatomic) IBOutlet UIButton *levsPrizeButton;     //奖金无返点
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIImageView *lotteryTypeImage;

- (IBAction)goToInfoOfPlayMethod:(id)sender;

//清空所选号码
- (IBAction)cleanNumber:(id)sender;
//选好了
- (IBAction)finishSelectNumber:(id)sender;
- (IBAction)returnBtnClk:(UIButton *)sender;
- (IBAction)selectGame:(id)sender;
- (IBAction)touchDownSelectGame:(id)sender;

- (void)cleanSelectNumber;
-(void)gotoShakeMyPhone;
- (void)addRandomNumber;
/**以下用于下注页增加手选号码跳转到选号页传参*/
- (NSMutableArray *)menuAndRule;
- (void)setMenuAndRule:(NSMutableArray *)aRuleAndMenuArray;

- (void)setFirstMenuIndex:(int)firstIndex secondMenuIndex:(int)secondIndex;
- (void)setBuyChooseViewControllerIndex:(BuyChooseViewController *)buyChooseViewController;
@end
