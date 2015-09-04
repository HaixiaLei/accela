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
#import "BuyViewController.h"
#define NotificationUpdateIndex       @"NotificationUpdateIndex"

#define RateToInt 100

@class BuyFinishViewController;
@class KindOfLottery;
@class LotteryPlayOne;
@interface BuyChooseViewController : DerivedViewController<UIScrollViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,buyViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //玩法选择,水平菜单scrollView
    UIScrollView *scrollViewForPlayMethod;
    UIView *viewForPlayMethod;
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
   
    
    UIImageView *leftPicIV;
    UIImageView *rightPicIV;
    
    //单式
    NSMutableArray *simpleArray;
    NSMutableArray *sameArray;
    
    //第一级菜单按钮数组
    NSMutableArray *secondBtnArr;
    AVAudioPlayer *player;
   
    int hegiht;
    NSArray *listArray;
    
    //吉祥彩
    UIButton *topbutton;
    UIButton *TopImg;
    UIButton *ArrowImg;
    UIView *topTitleView;

    NSMutableArray *subArray;
    NSMutableArray *fastChooseArray;
    NSMutableDictionary *fastChooseDictionry;
    NSArray *tagArray;
    BOOL hidden;
    BOOL isAnimating;
    CGFloat _lastPosition;
    
    int difference_Height;
    
    BOOL PickerScrollview_one;
    BOOL PickerScrollview_two;
}
//@property (strong ,nonatomic) UIView *firstMenuBoard;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIImageView *hidebgImg;
@property (weak, nonatomic) IBOutlet UIButton *playMethodS;
@property (weak, nonatomic) IBOutlet UIButton *choosePlayMethod;
@property (weak, nonatomic) IBOutlet UIView *disableChooseNumBG;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPickerView *choosePlays;
@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property (weak, nonatomic) IBOutlet UILabel *currentJQ;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLable;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;

- (IBAction)gotoHideShade:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak,nonatomic)UIButton *jqButton;
@property (weak, nonatomic) IBOutlet UIScrollView *ballScrollView;
@property(nonatomic,weak) IBOutlet UILabel *xlTitle;
@property (weak, nonatomic) IBOutlet UIButton *addLottery;

@property (weak, nonatomic) IBOutlet UILabel *betMoney;//投注金额
@property (weak, nonatomic) IBOutlet UILabel *betNumber;//投入注数
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuLabel;

@property (weak, nonatomic) IBOutlet UIButton *finishSelectNum;
@property(nonatomic, weak) IBOutlet UIView *headerV;

@property (nonatomic, assign) BOOL isChooseMore;                //是否是增加手选号码模式
@property (nonatomic, strong) BuyFinishViewController *buyFinishViewController;
@property (nonatomic, strong) NSMutableArray *fiveHistoryArray;
@property (nonatomic, strong) KindOfLottery *kindOfLottery;
@property (weak, nonatomic) IBOutlet UIView *showTimeView;
@property (weak, nonatomic) IBOutlet UIView *jiangQiView;

@property (weak, nonatomic) IBOutlet UIView *ChooseMoneyView;
@property (weak, nonatomic) IBOutlet UIView *choosePrizeView;
@property (weak, nonatomic) IBOutlet UITableView *JiangQiTableView;

//@property (strong, nonatomic) IBOutlet UIView *monyModeBoardView;
//@property (strong, nonatomic) IBOutlet UIView *modeBoardView;
@property (weak, nonatomic) IBOutlet UIButton *defaultPrizeButton;  //奖金默认返点
@property (weak, nonatomic) IBOutlet UIButton *levsPrizeButton;     //奖金无返点
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIButton *jiangjinChooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyModes;
@property (weak, nonatomic) IBOutlet UITextField *inpurBeishu;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIButton *hideKeyBoardBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnHideShade;

- (IBAction)gotoChooseMoneyModes:(id)sender;
- (IBAction)gotoChooseJiangJinModes:(id)sender;

- (IBAction)gotoPlayMethods:(id)sender;
- (IBAction)choosePlayMethods:(id)sender;
- (IBAction)confirmToChoosePlays:(id)sender;

- (IBAction)goToInfoOfPlayMethod:(id)sender;

- (IBAction)addSelectedNumber:(id)sender;
-(void)jumpToNextVC;
//选好了
- (IBAction)finishSelectNumber:(id)sender;
- (IBAction)returnBtnClk:(UIButton *)sender;
- (IBAction)selectGame:(id)sender;

- (void)cleanSelectNumber;
-(void)gotoShakeMyPhone;
- (void)addRandomNumber;
/**以下用于下注页增加手选号码跳转到选号页传参*/
- (NSMutableArray *)menuAndRule;
- (void)setMenuAndRule:(NSMutableArray *)aRuleAndMenuArray;

- (void)setFirstMenuIndex:(NSInteger)firstIndex secondMenuIndex:(NSInteger)secondIndex;
- (void)setBuyChooseViewControllerIndex:(BuyChooseViewController *)buyChooseViewController;
- (IBAction)touchBlank:(id)sender;
@end
