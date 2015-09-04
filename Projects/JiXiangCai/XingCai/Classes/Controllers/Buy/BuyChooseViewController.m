//
//  BuyChooseViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "BuyChooseViewController.h"
#import "BuyViewController.h"
#import "AppCacheManager.h"
#import "MenuObject.h"
#import "ChildMenuObject.h"
#import "PlayRulesDetailObject.h"
#import "LayoutObject.h"
#import "ModeObject.h"
#import "KeZhuiHaoJiangQiObject.h"
#import "PublicOfLotteryName.h"
#import "BettingInformation.h"
#import "LotteryInformation.h"
#import "InfoOfPlayMethodViewController.h"
#import "BuyFinishViewController.h"
#import "KindOfLottery.h"
#import "AMGCombinatorics.h"
#import "AppAPITest.h"
#import "AFAppAPIClient.h"
#import "DAKeyboardControl.h"
#import "SelectedNumber.h"
#import "PrizeObject.h"
//#import "FiveHistoryTableViewCell.h"
#define BallButtonPoolSize 50

#define MoneyOfEachBet 2

#define Key_LastVersion @"LastVersion"
#define Key_LastBuild @"LastBuild"

#define BetNumberExistErrorMessage  @"已有相同投注内容，请重新选择"
#define BetNumberFullErrorMessage   @"机选已达最大限制"

#define anim_time .5
#define downheight 100

@interface BuyChooseViewController ()<UINavigationControllerDelegate>
{
    //奖期倒数计时计时器
    NSTimer *countdownTimer;
    
    //第一级菜单面板选择号
//    NSInteger firstMenuIndex;
    //水平菜单选择号
//    NSInteger secondMenuIndex;
    
    //圆角分模式按钮
    IBOutletCollection(UIButton) NSArray *modeButtons;
    //可追号奖期
    NSMutableArray *keZhuiHaoJiangQis;
    
    NSMutableArray *jiangQiNumarray;
    NSMutableArray *kaiJiangNumarray;
    NSMutableArray *fiveArray;
    UIButton *jqButton;  //奖期button
    //号码球复用池
    NSArray *buttonPool;
    //池中可用号码球序号
    int availableIndex;
    
    //所有号码球，按place归类到不同的数组，key就是place，value就是相同place是号码球
    NSMutableDictionary *allBallsDictionry;
    
    //近五期历史奖期
//    NSMutableArray *fiveHistoryArray;
    //大小单双
    NSMutableArray *fuZhuButtonArray;
    NSArray *dxdsTagArray;
    //总注数
    unsigned long theNumberOfBets;
    
    BOOL isInputType;
    BOOL CleanSelected;
    
    NSInteger select_one;
    NSInteger select_two;
    
    NSString *titleString; //标题String
   
    PlayRulesObject *playRulesObject; //玩法对象
    
    NSString *jugmentStr;
    
    UIButton *doneButton;
    
    NSArray *nfdprizeArray;  //返点数组；
    float betMoneyY;
    
    CGRect betMoneyFrame;
    CGRect betNumberFrame;
    CGRect zhuLabelFrame;
    CGRect yuanLabelFrame;
}
@end

@implementation BuyChooseViewController
@synthesize xlTitle;
@synthesize headerV;
@synthesize hideKeyBoardBtn;

int a=100;
int b=200;

#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //创建初始化数组
        [self setUpArrays];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];

    [self setRightBarButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)addKeyboardHandler
{
    self.view.keyboardTriggerOffset = self.addView.bounds.size.height;
    
    UIView *toolBar = self.addView;
    float viewHeight = self.view.frame.size.height;
    float bottomHeight = self.bottomView.frame.size.height;
 
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView)
    {
          NSLog(@"%f---%f",viewHeight,keyboardFrameInView.origin.y);
        if (keyboardFrameInView.origin.y == viewHeight) {
            CGRect toolBarFrame = toolBar.frame;
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - bottomHeight - toolBarFrame.size.height;
//            if (SystemVersion >= 7.0) {
//                toolBarFrame.origin.y -= 20;
//            }
            toolBar.frame = toolBarFrame;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    if (!self.isChooseMore)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIndexs:) name:NotificationUpdateIndex object:nil];
    }
    
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = YES;
    [JiangQiManager sharedManager].kindOfLottery = self.kindOfLottery;
    
    [self addKeyboardHandler];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = NO;
    [self.view removeKeyboardControl];
    [doneButton removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [[NSUserDefaults standardUserDefaults] setObject:self.kindOfLottery.lotteryName forKey:@"judge"];
    [[NSUserDefaults standardUserDefaults] setObject:self.kindOfLottery.cnname forKey:@"JTITLE"];
    fiveArray = [NSMutableArray array];
    jiangQiNumarray = [NSMutableArray array];
    kaiJiangNumarray = [NSMutableArray array];
    //获取玩法
    [self getPlayRules];
    
    //初始化子view
    [self initSubviews];
  
    //刷新奖期Label
    [self updateJiangqiLB];
    
    [self adjustView];
    if (!self.isChooseMore)
    {
        [UserInfomation sharedInfomation].prizeType = PrizeTypeDefault;
        [self selectPrizePool:self.defaultPrizeButton];
    }

    if ([self.kindOfLottery.lotteryName isEqualToString:@"ssc"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"lotterID"];

    }else if ([self.kindOfLottery.lotteryName isEqualToString:@"rbssc"]){
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"lotterID"];
    }

   [self.navigationItem.titleView addSubview:self.hidebgImg];
    self.hidebgImg.frame  =CGRectMake(-57, -28, 320, 480+(IS_IPHONE5?88:0));
    if (!IS_IPHONE5) {
        [self.hidebgImg setImage:[UIImage imageNamed:@"hidebg-960"]];
    }
    BOOL alreadyShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"SHADEBG"];
    if (!alreadyShow) {
        self.hidebgImg.hidden = NO;
        self.ballScrollView.userInteractionEnabled = NO;
    }
    
    for (int i =0 ; i<5; i++) {
        UILabel *jqLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,30*i, 120, 30)];
        [jqLabel setFont:[UIFont systemFontOfSize:13]];
        jqLabel.textColor=[UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1];
        [self.jiangQiView addSubview:jqLabel];
        [jiangQiNumarray addObject:jqLabel];
        UILabel *numberlabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 30*i, 70, 30)];
        [numberlabel setFont:[UIFont systemFontOfSize:13]];
        [self.jiangQiView addSubview:numberlabel];
        [kaiJiangNumarray addObject:numberlabel];
        if (i!=0)
        {
            UIImageView *cellview = [[UIImageView alloc]initWithFrame:CGRectMake(10,29*i, 300, 1)];
            [cellview setImage:[UIImage imageNamed:@"Content-dividing-line"]];
            [self.jiangQiView addSubview:cellview];
        }
        


    }

    self.finishSelectNum.titleEdgeInsets = UIEdgeInsetsMake(5, 40, 5, 10);
    tagArray = [[NSArray alloc]initWithObjects:@"全",@"大",@"小",@"奇",@"偶",@"清", nil];
    dxdsTagArray = [[NSArray alloc]initWithObjects:@"全",@"清", nil];
    
    subArray = [[NSMutableArray alloc]init];
    [self.inpurBeishu resignFirstResponder];
    self.inpurBeishu.keyboardType = UIKeyboardTypeNumberPad;
    self.inpurBeishu.delegate=self;
    
    jqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jqButton.frame =CGRectMake(145, -10, 30, 30);
    jqButton.enabled=NO;
    jqButton.adjustsImageWhenDisabled=NO;
    [jqButton setImage:[UIImage imageNamed:@"Dropdown-nomal"] forState:UIControlStateNormal];
    [jqButton setImage:[UIImage imageNamed:@"Dropdown-pressed"] forState:UIControlStateSelected];

//    [self.jqButton addTarget:self action:@selector(jqButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    fastChooseArray=[[NSMutableArray alloc]init];
    fastChooseDictionry= [[NSMutableDictionary alloc]init];

    self.buyFinishViewController = [[BuyFinishViewController alloc]initWithNibName:@"BuyFinishViewController" bundle:nil];
    self.buyFinishViewController.buyChooseViewController = self;
    self.buyFinishViewController.kindOfLottery = self.kindOfLottery;
    
    [self updateMenuIndexs];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime:) name:NotificationUpdateTime object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
    
//    [self addKeyboardHandler];
    self.jiangQiView.frame = CGRectMake(0, -85+(IS_IPHONE5?0:88), 320, 150);
    self.showTimeView.frame = CGRectMake(0, 64+(IS_IPHONE5?0:88), 320, 32);

    self.ballScrollView.frame = CGRectMake(0, 8+(IS_IPHONE5?0:88), 320, 390);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBgImg)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBgImg)];
    singleTap.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tappedOnScroll)];
    [self.ballScrollView addGestureRecognizer:tap];
    
    [self resetSomeView];
    
    //默认选择第一级菜单第一个，生成水平第二级菜单
    [self updateHorizontalMenuAtIndex:2];
    
    //默认选择水平第二级菜单第一个，生成选号按钮面板
    [self updateNumbersAtIndex:0];
}

-(void)adjustView
{
    if (SystemVersion < 7.0)
    {
        self.contentView.point = CGPointZero;
        CGRect frame = self.contentView.frame;
        frame.size.height = 568;
        self.contentView.frame = frame;
    }
}

- (void)resetSomeView
{
    //自动滚动到顶部
    [self.ballScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    if ([UserInfomation sharedInfomation].prizeType) {
        [self updatePrizePool];
    }
    [self cleanSelectNumber];
    [self updateMode];
    self.inpurBeishu.text = @"1";
    [self.inpurBeishu resignFirstResponder];
    if ([SelectedNumber getInstance].infoArray.count>0) {
        [self.finishSelectNum setEnabled:YES];
    }else{
        [self.finishSelectNum setEnabled:NO];
    }
    
    for (UIButton *btn in modeButtons) {
        if (btn.selected) {
            [self.moneyModes setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        }
    }
}

- (void)updatePrizePool
{
    if ([UserInfomation sharedInfomation].prizeType == PrizeTypeDefault)
    {
        [self selectPrizePool:self.defaultPrizeButton];
    }
    else if ([UserInfomation sharedInfomation].prizeType == PrizeTypeRebates)
    {
        [self selectPrizePool:self.levsPrizeButton];
    }
}
-(void)playaudio:(NSString *)_path
{
    if (player!=nil)
    {
        [player stop];
        player = nil; 
    }
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_path] error:nil];
    [player play];
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
    hideKeyBoardBtn.hidden = YES;
    topbutton.enabled = true;
    [doneButton removeFromSuperview];
}
- (void)doneButton:(id)sender
{
    [self.view endEditing:YES];
    [self updateBetMoneyAndBetNumber];
}
#pragma mark - Init
-(void)setUpArrays
{
    simpleArray =[[NSMutableArray alloc]init];
}
-(void)getFiveHistoryJQ
{
   
    [[AFAppAPIClient sharedClient] historyOfTheWinningNumbers_with_lotteryId:self.kindOfLottery.lotteryId type:@"1" block:^(id JSON, NSError *error)
     {
         NSMutableArray *array  =[JSON objectForKey:@"results"];
         if (!error)
         {
             fiveArray =array;
         }
     }];
   
    [self updateHistoryJiangQi];
}
-(void)updateHistoryJiangQi
{
    if (fiveArray.count>0) {
        for (int i=0; i<fiveArray.count; i++)
        {
            NSDictionary *jiangqi = [fiveArray objectAtIndex:i];
            NSString *numberStr = [jiangqi objectForKey:@"code"];
            
            UILabel *jqLabel = [jiangQiNumarray objectAtIndex:i];
            NSString *jqStr = [[jiangqi objectForKey:@"issue"] stringByAppendingString:@"期"];
            jqLabel.text =jqStr;
            
            
            UILabel *numberlabel = [kaiJiangNumarray objectAtIndex:i];
            
            
            if ([numberStr isEqualToString:@""]||(numberStr.length<5))
            {
                numberlabel.text =@"等待开奖";
                numberlabel.textColor=[UIColor colorWithRed:251/255.0 green:151/255.0 blue:98/255.0 alpha:1];
            }else
            {
                numberlabel.text =[jiangqi objectForKey:@"code"];
                numberlabel.textColor=[UIColor colorWithRed:162/255.0 green:11/255.0 blue:42/255.0 alpha:1];
            }
            
        }

    }

}
- (void)initSubviews
{
    //近5期开奖号码

    if (IS_IPHONE5){}
//    self.showTimeView.point =CGPointMake(0, self.showTimeView.frame.origin.y+IS_IPHONE5 ? -24 : 0);
//    self.bottomView.point =CGPointMake(0, self.bottomView.frame.origin.y+IS_IPHONE5 ? 348 : 0);
//    self.addView.point =CGPointMake(0, self.addView.frame.origin.y+IS_IPHONE5 ? 310 : 0);
//    self.ballScrollView.size =CGSizeMake(320,300);
    timerlabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 160, 17)];
    timerlabel.font = [UIFont systemFontOfSize:13];
    timerlabel.textColor = [UIColor colorWithRed:(162/255.0) green:(11/255.0) blue:(42/255.0) alpha:1];
    timerlabel.textAlignment = NSTextAlignmentLeft;
    timerlabel.backgroundColor = [UIColor clearColor];
    [self.showTimeView addSubview:timerlabel];
    
    timerHMS= [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 80, 17)];
    timerHMS.font = [UIFont systemFontOfSize:12];
    timerHMS.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    timerHMS.textAlignment = NSTextAlignmentLeft;
    timerHMS.backgroundColor = [UIColor clearColor];
    [self.showTimeView addSubview:timerHMS];
    
    topTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    [topTitleView setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView =topTitleView;
    
    topbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topbutton setTitle:@"后三码复式" forState:UIControlStateNormal];
    [topbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    topbutton.frame = CGRectMake(30, 0, 140, 44);
    [topbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [topbutton addTarget:self action:@selector(gotoChoosePlayMethods) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:topbutton];
    
    
    TopImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [TopImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    TopImg.frame = CGRectMake(20, 0, 44, 44);
    if ([self.kindOfLottery.lotteryId isEqualToString:@"1"]&&[self.kindOfLottery.lotteryName isEqualToString:@"ssc"])
    {
        [TopImg setImage:[UIImage imageNamed:@"CQ-Lottery-icon"] forState:UIControlStateNormal];
    }
    else if ([self.kindOfLottery.lotteryId isEqualToString:@"15"]&&[self.kindOfLottery.lotteryName isEqualToString:@"rbssc"])
    {
        [TopImg setImage:[UIImage imageNamed:@"JP-Lottery-icon"] forState:UIControlStateNormal];
    }
    
    
    [topTitleView addSubview:TopImg];
    
    ArrowImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [ArrowImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ArrowImg.frame = CGRectMake(140, 18, 16, 12);
    [ArrowImg addTarget:self action:@selector(gotoChoosePlayMethods) forControlEvents:UIControlEventTouchUpInside];
    [ArrowImg setImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
    [topTitleView addSubview:ArrowImg];
    
    float chooseHeight = SystemVersion >= 7.0 ? 117 : 97;
    viewForPlayMethod =[[UIView alloc]initWithFrame:CGRectMake(0, chooseHeight, 320, 244)];
    [viewForPlayMethod setBackgroundColor:[UIColor colorWithRed:27/255.0 green:21/255.0 blue:22/255.0 alpha:1]];
    viewForPlayMethod.hidden=YES;
    [self.view addSubview:viewForPlayMethod];
  
    
    //创建号码球缓存池
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < BallButtonPoolSize; ++i) {
        UIButton *ball =[UIButton buttonWithType: UIButtonTypeCustom];
        [ball addTarget:self action:@selector(selectBallNumber:) forControlEvents:UIControlEventTouchUpInside];
        [ball.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [ball setTitleColor:[UIColor colorWithRed:143/255.0 green:0/255.0 blue:32/255.0 alpha:1.0] forState:UIControlStateNormal];
        [ball setBackgroundImage:[UIImage imageNamed:@"open-No-No"] forState:UIControlStateNormal];
        [ball setBackgroundImage:[UIImage imageNamed:@"open-No-Yes"] forState:UIControlStateSelected];
        [ball setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [mutableArray addObject:ball];
    }
    
    buttonPool = mutableArray;
    availableIndex = 0;
    
    [self.choosePlays selectRow:2 inComponent:0 animated:YES];
}
-(void)gotoChoosePlayMethods
{
    self.hideKeyBoardBtn.hidden=!self.hideKeyBoardBtn.hidden;
    self.chooseView.hidden=!self.chooseView.hidden;
}
#pragma mark - 奖期
//更新奖期label
- (void)updateJiangqiLB
{
    timerlabel.text = [NSString stringWithFormat:@"%@期",self.kindOfLottery.currentJiangQi];
}

- (void)updateTime:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[KindOfLottery class]]) {
        KindOfLottery *kindOfLottery = (KindOfLottery *)object;
        if (kindOfLottery == self.kindOfLottery) {
            NSArray *components = [kindOfLottery.timeString componentsSeparatedByString:@"_"];
            if (components.count == 3) {
                self.hourLabel.text = [NSString stringWithFormat:@"%.2ld",(long)[((NSString *)[components objectAtIndex:0]) integerValue]];
                self.minLable.text = [NSString stringWithFormat:@"%.2ld",(long)[((NSString *)[components objectAtIndex:1]) integerValue]];
                self.secondLable.text = [NSString stringWithFormat:@"%.2ld",(long)[((NSString *)[components objectAtIndex:2]) integerValue]];
            }
        }
    }
}

- (void)updateJiangQi:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[KindOfLottery class]]) {
        KindOfLottery *kindOfLottery = (KindOfLottery *)object;
        if (kindOfLottery == self.kindOfLottery) {
            timerlabel.text = [NSString stringWithFormat:@"%@期:",kindOfLottery.currentJiangQi];
        }
    }
}
#pragma mark - 获取玩法
- (void)getPlayRules
{
    playRulesObject = [[AppCacheManager sharedManager] getPlayRulesObjectWithKindOfLottery:self.kindOfLottery];
    ruleAndMenuArray = playRulesObject.results;
}

//#pragma mark - Get & Set Menthods
- (NSArray *)menuAndRule
{
    return ruleAndMenuArray;
}
- (void)setMenuAndRule:(NSArray *)aRuleAndMenuArray
{
    ruleAndMenuArray = aRuleAndMenuArray;
}

#pragma mark - 按钮事件

-(void)tappedOnScroll{
    [self.inpurBeishu resignFirstResponder];
    if ([self.moneyModes isSelected]) {
        self.moneyModes.selected = NO;
        self.ChooseMoneyView.hidden = YES;
    }
    
    if ([self.jiangjinChooseBtn isSelected]) {
        self.jiangjinChooseBtn.selected = NO;
        self.choosePrizeView.hidden = YES;
    }
}

//-(void)jqButtonPressed:(UIButton *)btn{
//    if (self.ballScrollView.contentOffset.y == 0 && !hidden) {
//        [self.ballScrollView setContentOffset:CGPointMake(0, -26) animated:YES];
//    }else{
//        [self.ballScrollView setContentOffset:CGPointMake(0, 26) animated:YES];
//    }
//    [self scrollViewDidScroll:self.ballScrollView];
//}

- (IBAction)gotoChooseMoneyModes:(id)sender {
    
    [self.inpurBeishu resignFirstResponder];
    if ([self.jiangjinChooseBtn isSelected]) {
        self.jiangjinChooseBtn.selected = NO;
        self.choosePrizeView.hidden = YES;
    }
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    
    if (button.selected) {
        self.ChooseMoneyView.hidden=NO;
    }else
    {
        self.ChooseMoneyView.hidden=YES;
    }

}

- (IBAction)gotoChooseJiangJinModes:(id)sender {
    
    [self.inpurBeishu resignFirstResponder];
    if ([self.moneyModes isSelected]) {
        self.moneyModes.selected = NO;
        self.ChooseMoneyView.hidden = YES;
    }
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    
    if (button.selected) {
        self.choosePrizeView.hidden=NO;
    }else
    {
        self.choosePrizeView.hidden=YES;
    }

}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   
    if(component==0){
        return [ruleAndMenuArray count];
    }else{
        return [subArray count];
    }
}


#pragma mark -
#pragma mark Picker Delegate Protocol
//设置当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component==0){
        MenuObject *menuObject = [ruleAndMenuArray objectAtIndex:row];
        return menuObject.title;
    }
    else{
        return [subArray objectAtIndex:row];
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0)
    {
        PickerScrollview_one=YES;

        select_one=row;
        select_two=0;
        [self updateHorizontalMenuAtIndex:row];
        self.playLabel.text=[subArray objectAtIndex:select_two];

    }
    else
    {
        PickerScrollview_two=YES;
        self.playLabel.text=[subArray objectAtIndex:row];
        select_two=row;
    }

    if (PickerScrollview_one==NO&&PickerScrollview_one==NO){}
    else if (PickerScrollview_one==YES&&PickerScrollview_two==NO)
    {
        select_two=0;
    }
    else if (PickerScrollview_one==YES&&PickerScrollview_two==NO)
    {
        select_one=2;
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumFontSize = 13.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:19]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (IBAction)goToInfoOfPlayMethod:(id)sender
{
    InfoOfPlayMethodViewController *infoViewController= [[InfoOfPlayMethodViewController alloc] initWithNibName:@"InfoOfPlayMethodViewController" bundle:nil];
    infoViewController.infoType = InfoTypePlayMethod;
    infoViewController.tagName = @"时时彩";
    [self.navigationController pushViewController:infoViewController animated:YES];
}

//水平菜单按钮事件
-(void)enterIntoSelectNumber:(id)sender
{
    if (self.choosePlayMethod.selected==YES)
    {
        self.choosePlayMethod.selected=NO;
    }

    UIButton *button = (UIButton *)sender;
    [self.choosePlayMethod setTitle:button.titleLabel.text forState:UIControlStateNormal];
     viewForPlayMethod.hidden=YES;
    [self updateNumbersAtIndex:button.tag];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.moneyModes isSelected]) {
        self.moneyModes.selected = NO;
        self.ChooseMoneyView.hidden = YES;
    }
    
    if ([self.jiangjinChooseBtn isSelected]) {
        self.jiangjinChooseBtn.selected = NO;
        self.choosePrizeView.hidden = YES;
    }
    
    topbutton.enabled = false;
    hideKeyBoardBtn.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.inpurBeishu && [textField.text intValue] <= 0) {
        self.inpurBeishu.text = @"1";
    }
    
    //选择倍数后，更新投注数和投注金额
    [self updateBetMoneyAndBetNumber];
    
//    self.inpurBeishu.text=textField.text;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *nowText = textField.text;
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //不允许首个数字0
    if (newText.length == 1 && [newText isEqualToString:@"0"] && [nowText isEqualToString:@""]) {
        return NO;
    }

    if (textField == self.inpurBeishu && [newText integerValue] > 1000000 ) {
        self.inpurBeishu.text = [NSString stringWithFormat:@"%d",1000000];
        return NO;
    }
    else if (textField == self.inpurBeishu && [newText integerValue] > 99999) {
        self.inpurBeishu.text = [NSString stringWithFormat:@"%d",99999];
        return NO;
    }
    return YES;

}
//self.view单击手势事件
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [textview resignFirstResponder];
}

// 元角分模式选择按钮事件
-(IBAction)selectMoneyModes:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    for (UIButton *modeButton in modeButtons)
    {
        modeButton.selected = NO;
    }
    button.selected = YES;
   
    self.ChooseMoneyView.hidden=YES;
    self.moneyModes.selected=NO;
   
    [UserInfomation sharedInfomation].modeIndex = button.tag;
    
    [self.moneyModes setTitle:button.titleLabel.text forState:UIControlStateNormal];
    
    [self updateBetMoneyAndBetNumber];
}

//奖池按钮事件
-(IBAction)selectPrizePool:(UIButton *)sender
{
    [UserInfomation sharedInfomation].prizeType = sender.tag;
    [UserInfomation sharedInfomation].prePrizeType = sender.tag;
    
    [self updatePrizePoolWithType:sender.tag];
    self.choosePrizeView.hidden=YES;
    self.jiangjinChooseBtn.selected=NO;
}
- (void)updatePrizePoolWithType:(PrizeType)type
{
    [self.jiangjinChooseBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    self.jiangjinChooseBtn.titleEdgeInsets = UIEdgeInsetsMake(7,-3, 5, 12);
    if (type == PrizeTypeDefault)
    {
        self.defaultPrizeButton.selected = YES;
        self.levsPrizeButton.selected = NO;
        [[self.defaultPrizeButton superview] bringSubviewToFront:self.defaultPrizeButton];
        NSString*str=self.defaultPrizeButton.titleLabel.text;
 
        [self.jiangjinChooseBtn setTitle:str forState:UIControlStateNormal];
    }
    else if(type == PrizeTypeRebates)
    {
        self.defaultPrizeButton.selected = NO;
        self.levsPrizeButton.selected = YES;
        [[self.levsPrizeButton superview] bringSubviewToFront:self.levsPrizeButton];
        NSString*str=self.levsPrizeButton.titleLabel.text;
        [self.jiangjinChooseBtn setTitle:str forState:UIControlStateNormal];
      
    }
}
//清空按钮事件
-(void)jumpToNextVC
{
    BuyFinishViewController*buyFinshV = [[BuyFinishViewController alloc]initWithNibName:@"BuyFinishViewController" bundle:nil];

    [self.navigationController pushViewController:buyFinshV animated:YES];

}
#pragma mark - 确认按钮事件
- (IBAction)finishSelectNumber:(id)sender
{
    [self tappedOnScroll];
    if (!self.isChooseMore) {
//        buyFinshVC = [[BuyFinishViewController alloc]initWithNibName:@"BuyFinishViewController" bundle:nil];
//        self.buyFinishViewController = buyFinshVC;
//        buyFinshVC.buyChooseViewController = self;
//        buyFinshVC.kindOfLottery = self.kindOfLottery;
//       
//        NSString *codes = isInputType ? [self getSingleCurrentSelectedCodes] : [self getCurrentSelectedCodes];
//        LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%lu",theNumberOfBets]];
//       
//       
//      
//       NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"|"];
//        NSString *trimmedString = [codes stringByTrimmingCharactersInSet:set];
//         
//        if (![trimmedString isEqualToString:@""]) {
//             [buyFinshVC addLotteryInformation:lotteryInfomation];
//            [[SelectedNumber getInstance].infoArray addObject:lotteryInfomation];
//        }
//        buyFinshVC.titleLabelText = self.kindOfLottery.cnname;
      
//        if (buyFinshVC.lotteryInformations.count) {
//            
//        }
        [self resetSomeView];
        [self.navigationController pushViewController:self.buyFinishViewController animated:YES];
    }
    else
    {
//        MenuObject *smo = [ruleAndMenuArray objectAtIndex:select_one];
//        NSString *title = smo.title;
//        
//        PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
//        NSString *name = fouMo.name;
//        
//        NSString *codes = isInputType ? [self getSingleCurrentSelectedCodes] : [self getCurrentSelectedCodes];
//        
//        if (![self.buyFinishViewController betNumberExist:codes title:title name:name]) {
//            LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%lu",theNumberOfBets]];
//            [self.buyFinishViewController addLotteryInformation:lotteryInfomation];
//            
//            [self cleanUpAndPop];
//        }
//        else
//        {
//            [Utility showErrorWithMessage:BetNumberExistErrorMessage delegate:self tag:AlertViewTypeBetNumberExist];
//        }
    }
}

//获取当前选中号码code串
- (NSString *)getCurrentSelectedCodes
{
    NSMutableString *codesString = [NSMutableString string];

    NSArray *allKeys = allBallsDictionry.allKeys;
    allKeys = [self sortedArray:allKeys];
    
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *key = [allKeys objectAtIndex:i];
        NSArray *selectedArray = [self getSelectedBallsByPlace:key];
        for (int j = 0; j < selectedArray.count; ++j) {
            UIButton *button = [selectedArray objectAtIndex:j];
            [codesString appendString:[button titleForState:UIControlStateNormal]];
            if (j != selectedArray.count - 1) {
                [codesString appendString:@"&"];
            }
        }
        if (i != allKeys.count - 1) {
            [codesString appendString:@"|"];
        }
    }

    return (NSString *)codesString;
}

- (NSString *)getSingleCurrentSelectedCodes
{
    NSMutableString *codesString = [NSMutableString string];
    
    for (int j = 0; j < simpleArray.count; ++j) {
        NSString *oneCode = [simpleArray objectAtIndex:j];
        [codesString appendString:oneCode];
        if (j != simpleArray.count - 1) {
            [codesString appendString:@"&"];
        }
    }
    return (NSString *)codesString;
}

////三码混合或二码组选单式 需要排序
- (NSString *)sortedOneCode:(NSString *)oneCode
{
    MenuObject *smo = [ruleAndMenuArray objectAtIndex:select_one];
    NSString *secMenuName = smo.title;
    
    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
    NSString *markString = fouMo.name;
    
    if ((([secMenuName isEqualToString:HouSanMa] || [secMenuName isEqualToString:QianSanMa] || [secMenuName isEqualToString:ZhongSanMa]) && [markString isEqualToString:HunHe]) ||
        ([secMenuName isEqualToString:ErMa] && ([markString isEqualToString:HouErZuXuanDanShi] || [markString isEqualToString:QianErZuXuanDanShi])))//三码混合或二码组选单式
    {
        NSMutableArray *charArray = [NSMutableArray array];
        for (int i = 0; i < oneCode.length; ++i) {
            NSString *charStr = [oneCode substringWithRange:NSMakeRange(i, 1)];
            [charArray addObject:charStr];
        }
        [charArray sortUsingComparator:^(NSString *a, NSString *b){
            return [a compare:b];
        }];
        
        NSMutableString *sortedOneCode = [NSMutableString string];
        for (int i = 0; i < charArray.count; ++i) {
            [sortedOneCode appendFormat:@"%@",[charArray objectAtIndex:i]];
        }
        return sortedOneCode;
    }
    else
    {
        return oneCode;
    }
}
#pragma mark - 数据刷新 滑动菜单设置

//更新水平菜单项
-(void)updateHorizontalMenuAtIndex:(NSInteger)index
{
    NSLog(@"%@",subArray);
    select_one=index;
    if (subArray.count>0) {
        [subArray removeAllObjects];
    }
    
    select_one = index;
    
    for (UIView *view in verticalMenuButtons)
    {
        [view removeFromSuperview];
    }
    
    if(!verticalMenuButtons)
    {
        verticalMenuButtons = [[NSMutableArray alloc] init];
    }
    else
    {
        [verticalMenuButtons removeAllObjects];
    }

    MenuObject *smo = [ruleAndMenuArray objectAtIndex:index];
    
    [self.playMethodS setTitle:smo.title forState:UIControlStateNormal];
    
    titleString =smo.title;
//    self.playMethodS.text = smo.title;
    //air-25-7--------------------------------------------------------------------------------------------------------begin
//    unsigned long charLength = xlTitle.text.length * 15;
//    unsigned long xlPicLocation = ((320 - charLength) / 2) + charLength;
   
    //air-25-7--------------------------------------------------------------------------------------------------------end
    //取4级菜
    if (!verticalMenuItems)
    {
        verticalMenuItems = [NSMutableArray array];
    }
    else
    {
        [verticalMenuItems removeAllObjects];
    }
    for (int i = 0; i < smo.label.count; ++i)
    {
        ChildMenuObject *thirdMenuObject = [smo.label objectAtIndex:i];
        [verticalMenuItems addObjectsFromArray:thirdMenuObject.label];
    }
    
    //设置滑动的菜单scrollViewForPlayMethod
    for (int k=0; k<verticalMenuItems.count; k++)
    {
        PlayRulesDetailObject *fmo = [verticalMenuItems objectAtIndex:k];
//        scrollViewForPlayMethod.contentSize = CGSizeMake(120+104*k, 40);
        
        UIButton *hdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        hdBtn.tag=k;
        NSString *title = [NSString stringWithFormat:@"%@", fmo.name];
        [hdBtn setTitle:title forState:UIControlStateNormal];
        [hdBtn setBackgroundImage:[UIImage imageNamed:@"btn_method_normal"] forState:UIControlStateNormal];
        [hdBtn setBackgroundImage:[UIImage imageNamed:@"btn_method_click"] forState:UIControlStateSelected];
        [hdBtn setTitleColor:[UIColor colorWithRed:(214/255.0) green:(14/255.0) blue:(24/255.0) alpha:1] forState:UIControlStateSelected];
        [hdBtn setTitleColor:[UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1] forState:UIControlStateNormal];

       
        if (fmo.name.length>6) {
            [hdBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        }else{
        
             [hdBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        }
        
        [hdBtn addTarget:self action:@selector(enterIntoSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
       
        int x=k%3;
        int y=k/3;
        if (verticalMenuItems.count== 1)
        {
            hdBtn.frame = CGRectMake(110, 15, 80, 40);
        }
        else
        {
            hdBtn.frame = CGRectMake(20+100*x, 15+45*y, 80, 34);
        }
      
        [verticalMenuButtons addObject:hdBtn];
        [subArray addObject:fmo.name];
        [viewForPlayMethod addSubview:hdBtn];
    }
    self.choosePlays.dataSource=self;
    [self.choosePlays selectRow:select_two inComponent:1 animated:YES];
}
- (IBAction)confirmToChoosePlays:(id)sender
{
    for (UIButton *btn in fastChooseArray)
    {
        if (btn.selected==YES)
        {
            btn.selected=NO;
            [btn setBackgroundColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1]];
            [btn setTitleColor:[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    [fastChooseArray removeAllObjects];
    
    [self updateHorizontalMenuAtIndex:select_one];
    [self updateNumbersAtIndex:select_two];
    
    self.hideKeyBoardBtn.hidden=YES;
    topbutton.enabled = true;
    self.chooseView.hidden=YES;

    PickerScrollview_one=NO;
}
#pragma 设置号码球
//设置选号球
-(void)updateNumbersAtIndex:(NSInteger)index
{
    select_two = index;
    
    self.ballScrollView.contentOffset =CGPointMake(0, 395);
    
    [self cleanAllBallsDictionry];
    
    fuZhuButtonArray =[[NSMutableArray alloc]init];
    
    for (UIView *view in self.ballScrollView.subviews)
    {
        [view removeFromSuperview];
    }
  
    [self setFinishButtonEnable:NO];
    
    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:index];
    
    if (![titleString isEqualToString:@"不定胆"])
    {
          titleString =[titleString stringByAppendingString:fouMo.name];
    }
    else
    {
        titleString = fouMo.name;
    }
    
    //调整UI
    CGPoint center = topbutton.center;
    [topbutton setTitle:titleString forState:UIControlStateNormal];
    [topbutton sizeToFit];
    topbutton.center = center;
    TopImg.point = CGPointMake(topbutton.point.x - TopImg.frame.size.width + 5, TopImg.point.y);
    ArrowImg.point = CGPointMake(topbutton.point.x + topbutton.frame.size.width + 5, ArrowImg.point.y);

//    NSArray *layout = fouMo.selectarea.orderlylayout;
    NSArray *layout = fouMo.selectarea.layout;
    
    float moneyModesHight = 0;
    
    if (layout && [layout respondsToSelector:@selector(count)] && layout.count > 0)
    {
        //ballScrollView总高度
        float totalHeight = 8;
        for (int i = 0; i < layout.count; i++)
        {
            LayoutObject *layoutObject = [layout objectAtIndex:i];
//            NSMutableDictionary *selectedDictionary = [NSMutableDictionary dictionary];
//             NSString* str_key =[NSString stringWithFormat:@"%d",i];
            NSString *title = layoutObject.title;
            NSInteger place = [layoutObject.place integerValue];
            
            NSArray *ballArray = [layoutObject.no componentsSeparatedByString:@"|"];
            
            //计算背景高度
            unsigned long selectAreaHeigth = ((ballArray.count - 1) / 5 + 1) * 45+60;
           
            totalHeight = (selectAreaHeigth + 1)*place ;
            
            //灰色背景view
        
            UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, totalHeight, 320, selectAreaHeigth)];
            [bgview setBackgroundColor:[UIColor whiteColor]];
            [self.ballScrollView addSubview:bgview];
        

            //下拉箭头
            if (i==0)
            {
                [bgview addSubview:jqButton];
            }
          
            if (i<layout.count-1)
            {
                UIImageView *lineIMGV = [[UIImageView alloc] initWithFrame:CGRectMake(0,selectAreaHeigth, 320,1)];
                [lineIMGV setImage:[UIImage imageNamed:@"Content-dividing-line"]];
                [bgview addSubview:lineIMGV];
            }
            
            moneyModesHight = (selectAreaHeigth)*layout.count;
            
            hegiht=moneyModesHight;
            //位数标签
            if (![title isEqualToString:@""])
            {
                UIImageView *weiFlagBg;
                UILabel *ballTitle;
                if (title.length < 3)
                {
                    ballTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,25, 40, 18)];
                     ballTitle.font = [UIFont boldSystemFontOfSize:16];
                }
                else
                {
                     ballTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 80, 18)];
                     ballTitle.font = [UIFont boldSystemFontOfSize:15];
                }
                [ballTitle setBackgroundColor:[UIColor clearColor]];
               
                ballTitle.textColor = [UIColor colorWithRed:146/255.0 green:0/255.0 blue:37/255.0 alpha:1];
                ballTitle.text = title;
                if (title.length == 2)
                {
                    ballTitle.textAlignment = NSTextAlignmentCenter;
                }
                [bgview addSubview:weiFlagBg];
                [bgview addSubview:ballTitle];
                
                
            }
            NSLog(@"%@",title);
            //生成小球
            for (int i = 0; i < ballArray.count; i++)
            {
                NSString *numStr =[ballArray objectAtIndex:i];
                UIButton *ball = [self getButtonFromPool];

                ball.tag = i;
                
                int col = i % 5;
                int row = i / 5;
                
                [ball setTitle:numStr forState:UIControlStateNormal];
                
                ball.frame = CGRectMake(30 + 55 * col, 46 * row+55, 45, 45);
                [bgview addSubview:ball];
                
                [self addBallToDictionary:ball place:layoutObject.place];
            }
            
            //大小单双
            //全大小单双清
            NSLog(@"fouMo.selectarea.isButton=%@",fouMo.selectarea.isButton);
            if ([fouMo.selectarea.isButton intValue]==0) {
                NSMutableArray *tagMutableArray=[[NSMutableArray alloc]init];
                
                for (int a=0; a<tagArray.count; a++) {
                    
                    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake(60+40*a, 18, 35, 35);
                    [btn.layer setCornerRadius:5.0];
                    [bgview addSubview:btn];
                    btn.tag=a;
                    
                    UIImage *image_n = [UIImage imageNamed:@"bet_btn_function_n"];
                    UIImage *image_h = [UIImage imageNamed:@"bet_btn_function_h"];
                    [btn setBackgroundImage:image_n forState:UIControlStateNormal];
                    [btn setBackgroundImage:image_h forState:UIControlStateHighlighted];
                    
                    [btn setTitle:[tagArray objectAtIndex:a] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    [btn setTitleColor:[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    [tagMutableArray addObject:btn];
                    [btn addTarget:self action:@selector(gotoChooseNumber:) forControlEvents:UIControlEventTouchUpInside];
                    
                    NSString *tag_str =[NSString stringWithFormat:@"%ld",(long)btn.tag];
                    
                    objc_setAssociatedObject(btn, "oneobj", layoutObject.place, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    objc_setAssociatedObject(btn, "twoobj", tag_str, OBJC_ASSOCIATION_COPY_NONATOMIC);
                }
                
                [fuZhuButtonArray addObject:tagMutableArray];
            }else if ([fouMo.selectarea.isButton intValue]==2){
                NSLog(@"[fouMo.selectarea.isButton intValue]==2");
                NSMutableArray *tagMutableArray=[[NSMutableArray alloc]init];
                
                for (int a=0; a<dxdsTagArray.count; a++) {
                    
                    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake(60+40*a, 18, 35, 35);
                    [btn.layer setCornerRadius:5.0];
                    [bgview addSubview:btn];
                    if (a==0) {
                       btn.tag=0;
                    }else if (a==1){
                    btn.tag=5;
                    }
                    
                    
                    UIImage *image_n = [UIImage imageNamed:@"bet_btn_function_n"];
                    UIImage *image_h = [UIImage imageNamed:@"bet_btn_function_h"];
                    [btn setBackgroundImage:image_n forState:UIControlStateNormal];
                    [btn setBackgroundImage:image_h forState:UIControlStateHighlighted];
                    
                    [btn setTitle:[dxdsTagArray objectAtIndex:a] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    [btn setTitleColor:[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    [tagMutableArray addObject:btn];
                    [btn addTarget:self action:@selector(gotoChooseNumber:) forControlEvents:UIControlEventTouchUpInside];
                    
                    NSString *tag_str =[NSString stringWithFormat:@"%ld",(long)btn.tag];
                    
                    objc_setAssociatedObject(btn, "oneobj", layoutObject.place, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    objc_setAssociatedObject(btn, "twoobj", tag_str, OBJC_ASSOCIATION_COPY_NONATOMIC);
                }
                
                [fuZhuButtonArray addObject:tagMutableArray];
            
            }
            
        }
        
        [self setUpMoneyModeWithHeight:moneyModesHight fouMo:fouMo];
        
        if (self.ballScrollView.frame.size.height>=moneyModesHight)
        {
            
            moneyModesHight=self.ballScrollView.frame.size.height+1;
            
        }else if (self.ballScrollView.frame.size.height<moneyModesHight)
        {
        difference_Height= moneyModesHight-self.ballScrollView.frame.size.height;
        
        }
        
        self.ballScrollView.contentSize =CGSizeMake(320, moneyModesHight+(IS_IPHONE5?20:100));
        
    }
    
    //自动滚动到顶部
    [self.ballScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)gotoChooseNumber:(UIButton*)sender
{
    NSLog(@"%@",fuZhuButtonArray);

    UIButton *button = (UIButton *)sender;
//    button.selected=YES;
    [fastChooseArray addObject:button];

    id first = objc_getAssociatedObject(button, "oneobj");
    id second = objc_getAssociatedObject(button, "twoobj");

    
    NSString *str_one =[NSString stringWithFormat:@"%@",first];
    NSString *str_two = [NSString stringWithFormat:@"%@",second];
   
    
    NSArray *allKeys = allBallsDictionry.allKeys;
    allKeys = [self sortedArray:allKeys];
    
    NSArray *allBalls = [self getBallArrayByPlace:str_one];
//    int mark_one = [str_one intValue];
    int mark_two=[str_two intValue];
   
  

    for (int i = 0; i < allBalls.count; ++i) {
        UIButton *ball = [allBalls objectAtIndex:i];
        if (ball.selected==YES) {
            ball.selected=NO;
        }
    }
    
    if (mark_two==0) {
        for (int i = 0; i < allBalls.count; ++i) {
            UIButton *ball = [allBalls objectAtIndex:i];
            [self selectBallNumber:ball];
        }
        
    }else if (mark_two==1)
    {
        for (int i = 0; i < allBalls.count; ++i) {
            if (4<i) {
                UIButton *ball = [allBalls objectAtIndex:i];
                [self selectBallNumber:ball];
            }
        }
        
    }else if (mark_two==2)
    {
        for (int i = 0; i < allBalls.count; ++i) {
            if (i<5) {
                UIButton *ball = [allBalls objectAtIndex:i];
                [self selectBallNumber:ball];
            }
        }
        
    }else if (mark_two==3)
    {
        for (int i = 0; i < allBalls.count; ++i) {
            if (i%2!=0) {
                UIButton *ball = [allBalls objectAtIndex:i];
                [self selectBallNumber:ball];
            }
        }
        
    }else if (mark_two==4)
    {
        for (int i = 0; i < allBalls.count; ++i) {
            
            if (i%2==0) {
                UIButton *ball = [allBalls objectAtIndex:i];
                [self selectBallNumber:ball];
            }
        }
        
    }else if (mark_two==5)
    {
        for (int i = 0; i < allBalls.count; ++i) {
            UIButton *ball = [allBalls objectAtIndex:i];
            CleanSelected=YES;
            [self selectBallNumber:ball];
        }
        
    }
//    objc_removeAssociatedObjects(first);
//    objc_removeAssociatedObjects(second);

}

- (void)setUpMoneyModeWithHeight:(float)moneyModesHight fouMo:(PlayRulesDetailObject *)fouMo
{
    if ([fouMo.nfdprize performSelector:@selector(count)] && fouMo.nfdprize.count > 0)
    {
        nfdprizeArray = fouMo.nfdprize;
        float modeBoardBottomLenghtInSuperView = self.ballScrollView.frame.origin.y + moneyModesHight  + self.ballScrollView.superview.frame.origin.y;
        
        if (modeBoardBottomLenghtInSuperView < self.bottomView.frame.origin.y) {
            moneyModesHight = self.bottomView.frame.origin.y - self.ballScrollView.frame.origin.y - self.ballScrollView.superview.frame.origin.y;
           
        }
        PrizeObject *defaultPrize;
        PrizeObject *rebatesPrize;
        
        for(PrizeObject *prizeObject in nfdprizeArray)
        {
            if ([prizeObject.key integerValue] != 0) {
                rebatesPrize = prizeObject;
            }
            else
            {
                defaultPrize = prizeObject;
            }
        }
        
        NSString *rateOneStr = [NSString stringWithFormat:@"%@-%@\%%",defaultPrize.value,defaultPrize.key];
        NSString *rateTwoStr = [NSString stringWithFormat:@"%@-%@\%%",rebatesPrize.value,rebatesPrize.key];
     
        [self.defaultPrizeButton setTitle:rateOneStr forState:UIControlStateNormal];
        [self.defaultPrizeButton setTitle:rateOneStr forState:UIControlStateSelected];
        [self.defaultPrizeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.defaultPrizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.defaultPrizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.levsPrizeButton setTitle:rateTwoStr forState:UIControlStateNormal];
        [self.levsPrizeButton setTitle:rateTwoStr forState:UIControlStateSelected];
        [self.levsPrizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.levsPrizeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.levsPrizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [self.jiangjinChooseBtn setTitle:rateOneStr forState:UIControlStateSelected];

        [UserInfomation sharedInfomation].prizeType = [UserInfomation sharedInfomation].prePrizeType;
        [self updatePrizePoolWithType:[UserInfomation sharedInfomation].prizeType];
        
        self.defaultPrizeButton.hidden = NO;
        self.levsPrizeButton.hidden = NO;
        self.jiangjinChooseBtn.hidden = NO;
    }
    else
    {
        nfdprizeArray = nil;
        [UserInfomation sharedInfomation].prizeType = PrizeTypeDefault;
        [self updatePrizePoolWithType:[UserInfomation sharedInfomation].prizeType];
        
        self.defaultPrizeButton.hidden = YES;
        self.levsPrizeButton.hidden = YES;
        self.jiangjinChooseBtn.hidden = YES;
    }
}

- (void)updateMode
{
    //元角分模式选择
    for (UIButton *modeButton in modeButtons) {
        modeButton.selected = modeButton.tag == [UserInfomation sharedInfomation].modeIndex ? YES : NO;
    }
}

//号码球选中事件
-(void)selectBallNumber:(id)sender
{
    [self tappedOnScroll];
    UIButton *button = (UIButton *)sender;
    if (CleanSelected==YES) {
        button.selected=NO;
    }else
    {
        button.selected=!button.selected;
    }


    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
    NSString *name = fouMo.name;
        if ([name isEqualToString:BaoDan])
    {
        NSArray *baoDanButtonArray = [self getSelectedBallsByPlace:@"0"];
        if (baoDanButtonArray.count > 1) {
            [Utility showErrorWithMessage:@"最多选择一个号码"];
            button.selected = NO;
        }
    }
    CleanSelected=NO;
    [self calculateNumberAndPrice];
}

#pragma mark - 公共计算方法

//获取描述字段
- (NSString *)getDescriptionWithCodes:(NSString *)codes showStr:(NSString *)showStr
{
    NSString *description = @"";
    if ([codes rangeOfString:@"|"].location != NSNotFound)
    {
        description = [codes stringByReplacingOccurrencesOfString:@"&" withString:@""];
        NSArray *components = [description componentsSeparatedByString:@"|"];
        
        unsigned long times = [[showStr componentsSeparatedByString:@"X"] count] - 1;
        
        if (components.count == times) {
            for (int i = 0; i < times; ++i) {
                NSRange range = [showStr rangeOfString:@"X"];
                showStr = [showStr stringByReplacingCharactersInRange:range withString:[components objectAtIndex:i]];
            }
            description = showStr;
        }
        else
        {
            description = [description stringByReplacingOccurrencesOfString:@"|" withString:@","];
        }
    }
    else
    {
        description = [codes stringByReplacingOccurrencesOfString:@"&" withString:@" "];
    }
    return description;
}

- (NSString *)getSingleDescription
{
    NSMutableString *codesString = [NSMutableString string];
    
    for (int j = 0; j < simpleArray.count; ++j) {
        NSString *oneCode = [simpleArray objectAtIndex:j];
        [codesString appendString:oneCode];
        if (j != simpleArray.count - 1) {
            [codesString appendString:@" "];
        }
    }
    return (NSString *)codesString;
}
-(void)getAddDictory:(NSArray *)array withPlace:(NSString*)place
{
    
    NSLog(@"%@---%@",array,place);
     NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setValue:array forKey:place];
   
    [fuZhuButtonArray addObject:array];
    
    NSLog(@"fuZhuButtonArray====%@",fuZhuButtonArray);
}
//从池中获取一个按钮
- (UIButton *)getButtonFromPool
{
    if (availableIndex >= BallButtonPoolSize) {
        availableIndex = 0;
    }
    UIButton *ball = [buttonPool objectAtIndex:availableIndex++];
    ball.selected = NO;
    return ball;
}

#pragma mark - 状态变更
//设置确定按钮是否可以点击
- (void)setFinishButtonEnable:(BOOL)enabled
{
    if (enabled)
    {
//        [self.finishSelectNum setEnabled:YES];
        [self.addLottery setEnabled:YES];
    }
    else
    {    
//        [self.finishSelectNum setEnabled:NO];
         [self.addLottery setEnabled:NO];
        theNumberOfBets = 0;
        [self updateBetMoneyAndBetNumber];
    }
}

//更新总价
- (void)updateBetMoneyAndBetNumber
{
    if (betMoneyFrame.size.width == 0) {
        betMoneyFrame = self.betMoney.frame;
        betNumberFrame = self.betNumber.frame;
        zhuLabelFrame = self.zhuLabel.frame;
        yuanLabelFrame = self.yuanLabel.frame;
    }
    

    
    PlayRulesDetailObject *rule =[verticalMenuItems objectAtIndex:select_two];
    ModeObject *mode = [rule.modes objectAtIndex:[UserInfomation sharedInfomation].modeIndex];
    
    //使用NSDecimalNumber类处理金额乘除法
    NSString *bets = [NSString stringWithFormat:@"%lu",theNumberOfBets ];
    NSString *eachBet = [NSString stringWithFormat:@"%i",MoneyOfEachBet];
    NSString *beishu = [NSString stringWithFormat:@"%@",self.inpurBeishu.text];
    NSString *rateStr = [NSString stringWithFormat:@"%@",mode.rate];
    NSString *moneyString = [Utility multiplyingDecimalNumberByMultiplicandAarray:@[bets,eachBet,beishu,rateStr]];
  
    self.betMoney.text = [Utility addDotForMoneyString:moneyString]; //总投注金额
    self.betNumber.text = [NSString stringWithFormat:@"%ld",theNumberOfBets]; //注数
    
    [self.betMoney setFrame:betMoneyFrame];
    [self.betNumber setFrame:betNumberFrame];
    [self.zhuLabel setFrame:zhuLabelFrame];
    [self.yuanLabel setFrame:yuanLabelFrame];
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
    
    tempLabel.text = self.betNumber.text;
    tempLabel.font = self.betNumber.font;
    [tempLabel sizeToFit];
    f = self.betNumber.frame;
    offset = f.size.width - tempLabel.frame.size.width;
    if (offset > f.size.width/2) {
        offset = f.size.width/2;
    }
    f.size.width -= offset;
    [self.betNumber setFrame:f];
    r = self.zhuLabel.frame;
    r.origin.x -= offset;
    [self.zhuLabel setFrame:r];
    
    if (self.betMoney.frame.size.width > betMoneyFrame.size.width) {
        [self.betMoney setFrame:betMoneyFrame];
        [self.yuanLabel setFrame:yuanLabelFrame];
    }
    
    
//    //如果betMoney的长度大于等于10位，则把字号从15改为13
//    if (self.betMoney.text.length >= 10) {
//        [self.betMoney setFont:[UIFont systemFontOfSize:13]];
//    }else{
//        [self.betMoney setFont:[UIFont systemFontOfSize:15]];
//    }
//  
//      NSLog(@"theNumberOfBets---%lu",theNumberOfBets);
//    [self.betNumber sizeToFit];
//    [self.betMoney sizeToFit];
//    [self.yuanLabel sizeToFit];
//    [self.zhuLabel sizeToFit];
//    
//    int zhu_totalWidth = self.betNumber.frame.size.width + self.zhuLabel.frame.size.width;
//     int money_totalWidth = self.betMoney.frame.size.width + self.yuanLabel.frame.size.width;
//    int screenWidth = ScreenSize.width;
//    
//    int zhu_origin = screenWidth * 0.25 - zhu_totalWidth*0.4;
//    int money_origin = screenWidth * 0.25 - money_totalWidth*0.4;
//    
//
//    self.betNumber.point = CGPointMake(zhu_origin, self.betNumber.point.y);
//    zhu_origin += self.betNumber.frame.size.width;
//    
//    if (betMoneyY<1) {
//        betMoneyY = self.betMoney.point.y;
//    }
//    if (self.betMoney.text.length >= 10) {
//        self.betMoney.point = CGPointMake(money_origin+4, betMoneyY+2);
//    }else{
//        self.betMoney.point = CGPointMake(money_origin, betMoneyY);
//    }
//    
//    money_origin += self.betMoney.frame.size.width;
//    
//    self.zhuLabel.point = CGPointMake(zhu_origin+10, self.zhuLabel.point.y);
//    self.yuanLabel.point = CGPointMake(money_origin+7, self.yuanLabel.point.y);
}

#pragma mark - 下拉、隐藏效果

-(void) showView{
    NSLog( @"---->showView");
    hidden = YES;
    isAnimating = YES;
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:anim_time];
    [UIView animateWithDuration:anim_time animations:^(void){
        [self.ballScrollView setFrame:CGRectMake(0, self.ballScrollView.frame.origin.y+150, 320, self.ballScrollView.frame.size.height)];
        [self.jiangQiView setFrame:CGRectMake(0, self.jiangQiView.frame.origin.y+181, 320, self.jiangQiView.frame.size.height)];
    }];
    
    jqButton.selected=YES;
}

-(void) hideView{
    NSLog( @"---->hideView");
    hidden = NO;
    isAnimating = YES;
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:anim_time];
    [UIView animateWithDuration:anim_time animations:^(void){
        [self.ballScrollView  setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.ballScrollView setFrame:CGRectMake(0, self.ballScrollView.frame.origin.y-150, 320, self.ballScrollView.frame.size.height)];
        [self.jiangQiView setFrame:CGRectMake(0, self.jiangQiView.frame.origin.y-181, 320, self.jiangQiView.frame.size.height)];
    } completion:^(BOOL finished){
        //滚动到顶部
     
            [self.ballScrollView  setContentOffset:CGPointMake(0, 0) animated:YES];
       
    }];
   jqButton.selected=NO;
}

-(void)endAnimation:(id)sender {
    @synchronized(self){
        isAnimating = NO;
    }
}

#pragma mark - scroll

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"0=====Scroll-->%f",scrollView.contentOffset.y);
    [self getFiveHistoryJQ];
    [self.inpurBeishu resignFirstResponder];
    if ([self.moneyModes isSelected]) {
        self.moneyModes.selected = NO;
        self.ChooseMoneyView.hidden = YES;
    }
    
    if ([self.jiangjinChooseBtn isSelected]) {
        self.jiangjinChooseBtn.selected = NO;
        self.choosePrizeView.hidden = YES;
    }
    
    
   
    CGFloat currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 50 ) {
        NSLog(@"ScrollUp now");
        _lastPosition = currentPostion;
        
        if (isAnimating) {
            return;
        }
        if (hidden) {
            [self hideView];
        }
        
    } else if (_lastPosition - currentPostion > 50) {
        NSLog(@"ScrollDown now");
        _lastPosition = currentPostion;
        
        if (isAnimating) {
            return;
        }
        if (scrollView.contentOffset.y < 0 && !hidden) {
            [self showView];
        }
        
    }
    
}

#pragma mark - 清空数据
//清空所有数据
-(void)cleanSelectNumber
{
    for (UIButton *btn in fastChooseArray) {
        if (btn.selected==YES) {
            btn.selected=NO;
            [btn setBackgroundColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1]];
            [btn setTitleColor:[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
    }
    [fastChooseArray removeAllObjects];
    [simpleArray removeAllObjects];
    NSLog(@"%@",simpleArray);
    //取消undo事件,防止ios7crash
    [textview.undoManager removeAllActions];
    textview.text = @"";

    NSArray *allKeys = allBallsDictionry.allKeys;
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *key = [allKeys objectAtIndex:i];
        NSArray *selectedArray = [self getSelectedBallsByPlace:key];
        for (int j = 0; j < selectedArray.count; ++j) {
            UIButton *button = [selectedArray objectAtIndex:j];
            button.selected = NO;
        }
    }
    
    [self setTheNumberOfBets:0];
}
//清理以及Pop
- (void)cleanUpAndPop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [countdownTimer invalidate];
    countdownTimer = nil; 
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cleanUpAndPopToRoot
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [countdownTimer invalidate];
    countdownTimer = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark 下注提交前数据处理
//获取投注信息对象
/*
 codes  投注号码。比如:3&6|4&5&7
 nums   注数
*/
- (LotteryInformation *)getLotteryInformationWithCodes:(NSString *)codes nums:(NSString *)nums
{
    MenuObject *smo = [ruleAndMenuArray objectAtIndex:select_one];
    PlayRulesDetailObject *rule =[verticalMenuItems objectAtIndex:select_two];
    ModeObject *mode = [rule.modes objectAtIndex:[UserInfomation sharedInfomation].modeIndex];
    
    BettingInformation *bettingInformation = [[BettingInformation alloc] init];
    bettingInformation.type = rule.selectarea.type;
    bettingInformation.methodid = rule.methodid;
    bettingInformation.mode = mode.modeid;
    
    bettingInformation.codes = codes;
    bettingInformation.nums = nums;
    
    bettingInformation.times =
    bettingInformation.time_s = self.inpurBeishu.text;
    
    NSString *currentOmodel = @"0";
    if (nfdprizeArray) {
        NSString *nfdprize = @"0";
        for(PrizeObject *prizeObject in nfdprizeArray)
        {
            if ([prizeObject.key integerValue] != 0) {
                nfdprize = prizeObject.key;
            }
        }
        
        if ([UserInfomation sharedInfomation].prizeType == PrizeTypeRebates)
        {
            currentOmodel = nfdprize;
        }
    }
    bettingInformation.omodel = currentOmodel;
 
    DDLogDebug(@"omodel:%@",bettingInformation.omodel);
    NSString *lastDescStr = isInputType ? [self getSingleDescription] : [self getDescriptionWithCodes:codes showStr:rule.show_str];
    bettingInformation.desc = [NSString stringWithFormat:@"[%@_%@] %@",smo.title,rule.name,lastDescStr];
    
    bettingInformation.showCodes = lastDescStr;
    bettingInformation.showDesc = [NSString stringWithFormat:@"[%@_%@]",smo.title,rule.name];
    
    LotteryInformation *lotteryInfomation = [[LotteryInformation alloc] init];
    lotteryInfomation.bettingInformation = bettingInformation;
    lotteryInfomation.mode = mode;
    
    return lotteryInfomation;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertViewTypeErrorIssueEmpty || alertView.tag == AlertViewTypeErrorIssueNotEnough) {
        [self cleanUpAndPopToRoot];
    }
    else if (alertView.tag == AlertViewTypeBetNumberExist)
    {
        [self cleanSelectNumber];
    }
}

#pragma mark - 优化注数计算
//清空选号球资源字典
- (void)cleanAllBallsDictionry
{
    [allBallsDictionry removeAllObjects];
}

//增加某一类place的小球
- (void)addBallToDictionary:(UIButton *)ball place:(id)place
{
    if (![place isKindOfClass:[NSString class]]) {
        place = [place stringValue];
    }
    
    if (!allBallsDictionry) {
        allBallsDictionry = [NSMutableDictionary dictionary];
    }
    NSMutableArray *array = [allBallsDictionry objectForKey:place];
    if (!array) {
        array = [NSMutableArray array];
    }
    
    if (![array containsObject:ball]) {
        [array addObject:ball];
        [allBallsDictionry setObject:array forKey:place];
    }
}

//小球种类数
- (unsigned long)numberOfBallKind
{
    return allBallsDictionry.allKeys.count;
}

//根据place获取小球按钮数组
- (NSArray *)getBallArrayByPlace:(NSString *)place
{
    return [allBallsDictionry objectForKey:place];
}

//根据place获取选中小球按钮数组
- (NSArray *)getSelectedBallsByPlace:(NSString *)place
{
    
    NSArray *allBalls = [self getBallArrayByPlace:place];
   
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < allBalls.count; ++i) {
        UIButton *ball = [allBalls objectAtIndex:i];
        if (ball.selected) {
            [mutableArray addObject:ball];
        }
    }
    NSLog(@"mutableArray－－－%@",mutableArray);
    return mutableArray;
}

//根据place获取未选中小球按钮数组
- (NSArray *)getUnselectedBallsByPlace:(NSString *)place
{
    NSArray *allBalls = [self getBallArrayByPlace:place];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < allBalls.count; ++i) {
        UIButton *ball = [allBalls objectAtIndex:i];
        if (!ball.selected) {
            [mutableArray addObject:ball];
        }
    }
    return mutableArray;
}
//根据place获取未选中小球的数组，且未在第二个place中出现
- (NSArray *)getUnselectedBallsAtPlace:(NSString *)place andPlace:(NSString *)secondPlace
{
    NSArray *allBalls = [self getBallArrayByPlace:place];
    NSArray *secondAllBalls = [self getBallArrayByPlace:secondPlace];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < allBalls.count; ++i) {
        UIButton *ball = [allBalls objectAtIndex:i];
        UIButton *secondBall = [secondAllBalls objectAtIndex:i];
        if (!ball.selected && !secondBall.selected) {
            [mutableArray addObject:ball];
        }
    }
    return mutableArray;
}
//根据place获取选中小球的数组
- (NSArray *)getSelectedBallNumbersByPlace:(NSString *)place
{
    NSLog(@"place---%@",place);
    NSArray *allBalls = [self getBallArrayByPlace:place];
    NSLog(@"allBalls---%@",allBalls);
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < allBalls.count; ++i) {
        UIButton *ball = [allBalls objectAtIndex:i];
     
        if (ball.selected) {
             NSLog(@"ball.tag---%ld",(long)ball.tag);
            [mutableArray addObject:[NSString stringWithFormat:@"%ld",(long)ball.tag]];
        }
    }
  
    return mutableArray;
}
//每一类号码所选数量之积
- (int)valueOfMultiplyEach
{
    int value = 1;
    NSArray *allKeys = allBallsDictionry.allKeys;
    NSLog(@"allKeys%@",allKeys);
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *key = [allKeys objectAtIndex:i];
        NSArray *selectedBalls = [self getSelectedBallsByPlace:key];
        value *= selectedBalls.count;
    }
    NSLog(@"%d",value);
    return value;
    
}

//每一类号码所选数量之和
- (int)valueOfPlusEach
{
    int value = 0;
    NSArray *allKeys = allBallsDictionry.allKeys;
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *key = [allKeys objectAtIndex:i];
        NSArray *selectedBalls = [self getSelectedBallsByPlace:key];
        value += selectedBalls.count;
    }
    return value;
}

//计算注数（排列组合），默认同一注两排数字不可以出现相同
/**
 first  第一排号码需要选择的个数
 second 第二排号码需要选择的个数
 */
- (unsigned long)getNumberOfBetsWithFirst:(int)first second:(int)second
{
    unsigned long numberOfBets = 0;
    if (first > 0 && second > 0)
    {
        if (allBallsDictionry.allKeys.count == 2 && [allBallsDictionry objectForKey:@"0"] && [allBallsDictionry objectForKey:@"1"])
        {
            NSArray *firstArray = [self getSelectedBallNumbersByPlace:@"0"];
            NSArray *secondArray = [self getSelectedBallNumbersByPlace:@"1"];
            if (firstArray.count >= first && secondArray.count >= second) {
                NSSet *firstArrayCombination = [AMGCombinatorics combinationsWithoutRepetitionFromElements:firstArray taking:first];
                NSSet *secondArrayCombination = [AMGCombinatorics combinationsWithoutRepetitionFromElements:secondArray taking:second];
//                DLog(@"first:%@,second:%@",firstArrayCombination,secondArrayCombination);
                NSSet *singleSet;
                NSSet *theOtherSet;
                if (((NSArray *)[firstArrayCombination anyObject]).count == 1) {
                    singleSet = firstArrayCombination;
                    theOtherSet = secondArrayCombination;
                }
                else if (((NSArray *)[secondArrayCombination anyObject]).count == 1) {
                    singleSet = secondArrayCombination;
                    theOtherSet = firstArrayCombination;
                }
                if (singleSet && singleSet.count > 0) {
                    for (NSArray *firstArray in singleSet) {
                        int number = [[firstArray firstObject] intValue];
                        for (NSArray *secondArray in theOtherSet) {
                            BOOL findSame = NO;
                            for (NSString *secondNumber in secondArray) {
                                if ([secondNumber intValue] == number) {
                                    findSame = YES;
                                    break;
                                }
                            }
                            if (!findSame) {
                                numberOfBets++;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            DDLogError(@"不符合条件，方法:%@",NSStringFromSelector(_cmd));
        }
    }
    else if (first > 0 && second == 0)
    {
        if (allBallsDictionry.allKeys.count == 1 && [allBallsDictionry objectForKey:@"0"])
        {
            NSArray *firstArray = [self getSelectedBallNumbersByPlace:@"0"];
            NSLog(@"----%@",firstArray);
            if (firstArray.count >= first) {
                NSSet *firstArrayCombination = [AMGCombinatorics combinationsWithoutRepetitionFromElements:firstArray taking:first];
                numberOfBets = firstArrayCombination.count;
                NSLog(@"%lu",numberOfBets);
            }
        }
        else
        {
            DDLogError(@"不符合条件，方法:%@",NSStringFromSelector(_cmd));
        }
    }
    else
    {
        DDLogError(@"参数不符合要求，方法:%@",NSStringFromSelector(_cmd));
    }
    
    return numberOfBets;
}

//更新底部投注数和金额，以及下注按钮可用状态
- (void)setTheNumberOfBets:(unsigned long)numberOfBets
{
    if (numberOfBets > 0) {
        [self setFinishButtonEnable:YES];
        theNumberOfBets = numberOfBets;
        [self updateBetMoneyAndBetNumber];
    }
    else
    {
        [self setFinishButtonEnable:NO];
    }
}

//计算直选和值注数
- (int)getNumberOfBetsOfZhiXuanHeZhi:(int)count
{
    
    int numberOfBets = 0;
    NSArray *selectedArray = [self getSelectedBallNumbersByPlace:@"0"];
    
    for (NSString *selectedNumber in selectedArray) {
        int number = [selectedNumber intValue];
        if (count == 3) {
            for (int i = 0; i <= 9; i++) {
                for (int j = 0; j <= 9; j++) {
                    for (int k = 0; k<= 9; k++) {
                        int sum = i + j + k;
                        if (sum == number) {
                            numberOfBets++;
                        }
                    }
                }
            }
        }
        else if (count == 2)
        {
            for (int i = 0; i <= 9; i++) {
                for (int j = 0; j <= 9; j++) {
                    int sum = i + j;
                    if (sum == number) {
                        numberOfBets++;
                    }
                }
            }
        }
    }
    return numberOfBets;
}

//计算组选和值注数
- (int)getNumberOfBetsOfZuXuanHeZhi:(int)count
{
    int numberOfBets = 0;
    NSArray *selectedArray = [self getSelectedBallNumbersByPlace:@"0"];
    
    for (NSString *selectedNumber in selectedArray) {
        int number = [selectedNumber intValue] + 1;
        if (count == 3) {
            for (int i = 0; i <= 9; i++) {
                for (int j = i; j <= 9; j++) {
                    for (int k = j; k <= 9; k++) {
                        int sum = i + j + k;
                        if (sum == number && !(i == j && j == k)) {
                            numberOfBets++;
                        }
                    }
                }
            }
        }
        else if (count == 2)
        {
            for (int i = 0; i <= 9; i++)
            {
                for (int j = i; j <= 9; j++)
                {
                    int sum = i + j;
                    if (sum == number && i != j)
                    {
                        numberOfBets++;
                    }
                }
            }
        }
    }
    return numberOfBets;
}

//计算投注金额
- (void)calculateNumberAndPrice
{
    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
    NSString *name = fouMo.name;
    
    //五星
    if ([name isEqualToString:FuShi] || [name isEqualToString:HouErZhiXuanFuShi] || [name isEqualToString:QianErZhiXuanFuShi] || [name isEqualToString:HouEr] || [name isEqualToString:QianEr]) {
        int numberOfBets = [self valueOfMultiplyEach];;
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuHe])
    {
        unsigned long numberOfBets = [self numberOfBallKind] * [self valueOfMultiplyEach];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan120])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:5 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan60])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:1 second:3];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan30])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:2 second:1];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan20]  || [name isEqualToString:ZuXuan12])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:1 second:2];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan10] || [name isEqualToString:ZuXuan5] || [name isEqualToString:ZuXuan4])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:1 second:1];
        [self setTheNumberOfBets:numberOfBets];
    }
    //四星
    else if ([name isEqualToString:ZuXuan24])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:4 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan6] || [name isEqualToString:HouSanErMaBuDingDan] || [name isEqualToString:QianSanErMaBuDingDan] || [name isEqualToString:HouErZuXuanFuShi] || [name isEqualToString:QianErZuXuanFuShi])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:2 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    //后三码,前三码,中三码
    else if ([name isEqualToString:ZuSan])
    {
        unsigned long numberOfBets = 2 * [self getNumberOfBetsWithFirst:2 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZhiXuanHeZhi])
    {
        unsigned long numberOfBets = [self getNumberOfBetsOfZhiXuanHeZhi:3];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuLiu])
    {
        unsigned long numberOfBets = [self getNumberOfBetsWithFirst:3 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuanHeZhi])
    {
        unsigned long numberOfBets = [self getNumberOfBetsOfZuXuanHeZhi:3];
        [self setTheNumberOfBets:numberOfBets];
    }
    //二码
    //后二直选
     else if ([name isEqualToString:HouErZhiXuanHeZhi] || [name isEqualToString:QianErZhiXuanHeZhi])
    {
        int numberOfBets = [self getNumberOfBetsOfZhiXuanHeZhi:2];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:HouErZuXuanHeZhi] || [name isEqualToString:QianErZuXuanHeZhi])
    {
        int numberOfBets = [self getNumberOfBetsOfZuXuanHeZhi:2];
        [self setTheNumberOfBets:numberOfBets];
    }
    //前二组选
    //定位胆
    else if ([name isEqualToString:DingWeiDan] || [name isEqualToString:BaoDan] || [name isEqualToString:HouSanYiMaBuDingDan] || [name isEqualToString:QianSanYiMaBuDingDan] || [name isEqualToString:YiFangFengShun] || [name isEqualToString:HaoShiChengShuang] || [name isEqualToString:SanXingBaoXi] || [name isEqualToString:SiJiFaCai])
    {
        int numberOfBets = [self valueOfPlusEach];
        [self setTheNumberOfBets:numberOfBets];
    }
}

#pragma mark - 摇一摇随机选号码
//摇一摇
//- (void)gotoShakeMyPhone
//{
//    [self cleanSelectNumber];
//    
//    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
//    NSString *name = fouMo.name;
//    
//    if ([name isEqualToString:FuShi] ||
//        [name isEqualToString:ZuHe] ||
//        [name isEqualToString:HouErZhiXuanFuShi] ||
//        [name isEqualToString:QianErZhiXuanFuShi] ||
//        [name isEqualToString:YiFangFengShun] ||
//        [name isEqualToString:HaoShiChengShuang] ||
//        [name isEqualToString:SanXingBaoXi] ||
//        [name isEqualToString:SiJiFaCai] ||
//        [name isEqualToString:BaoDan] ||
//        [name isEqualToString:HouSanYiMaBuDingDan] ||
//        [name isEqualToString:QianSanYiMaBuDingDan]||
//        [name isEqualToString:ZhiXuanHeZhi] ||
//        [name isEqualToString:ZuXuanHeZhi] ||
//        [name isEqualToString:HouErZhiXuanHeZhi] ||
//        [name isEqualToString:QianErZhiXuanHeZhi] ||
//        [name isEqualToString:HouErZuXuanHeZhi] ||
//        [name isEqualToString:QianErZuXuanHeZhi] ||
//        [name isEqualToString:HouEr] ||
//        [name isEqualToString:QianEr])
//    {
//        [self randomSelectEach:1];
//    }
//    else if ([name isEqualToString:ZuXuan60])
//    {
//        [self randomSelectFirst:1 second:3];
//    }
//    else if ([name isEqualToString:ZuXuan30])
//    {
//        [self randomSelectFirst:2 second:1];
//    }
//    else if ([name isEqualToString:ZuXuan20]||[name isEqualToString:ZuXuan12])
//    {
//        [self randomSelectFirst:1 second:2];
//    }
//    else if ([name isEqualToString:ZuXuan10]||[name isEqualToString:ZuXuan5]||[name isEqualToString:ZuXuan4])
//    {
//        [self randomSelectFirst:1 second:1];
//    }
//    else if ([name isEqualToString:ZuXuan120])
//    {
//        [self randomSelectEach:5];
//    
//    }
//    else if ([name isEqualToString:ZuXuan24])
//    {
//        [self randomSelectEach:4];
//        
//    }
//    else if ([name isEqualToString:ZuXuan6]||[name isEqualToString:ZuSan]||[name isEqualToString:ZuXuan]||[name isEqualToString:HouErZuXuanFuShi]||[name isEqualToString:QianErZuXuanFuShi]||[name isEqualToString:HouSanErMaBuDingDan]||[name isEqualToString:QianSanErMaBuDingDan])
//    {
//        [self randomSelectEach:2];
//    }
//    else if ([name isEqualToString:ZuLiu])
//    {
//        [self randomSelectEach:3];
//    }
//    else if ([name isEqualToString:DingWeiDan])
//    {
//        [self randomSelectOne];
//    }
//
//    [self calculateNumberAndPrice];
//}

//随机每位选取一个
- (void)randomSelectEach:(int)count
{
    NSArray *allKeys = allBallsDictionry.allKeys;
   
    //排序
    allKeys = [self sortedArray:allKeys];
    
    for (int i = 0; i < allKeys.count; ++i)
    {
        for (int j = 0; j <count; ++j)
        {
            NSArray *ballArray = [self getUnselectedBallsByPlace:[allKeys objectAtIndex:i]];
            int randomNumber = arc4random() % ballArray.count;
            UIButton *ball = [ballArray objectAtIndex:randomNumber];
            ball.selected=YES;
        }
    }
}

//随机从某位选取一个
- (void)randomSelectOne
{
    NSArray *allKeys = allBallsDictionry.allKeys;
    
    int randomPlace = arc4random() % allKeys.count;
    
    NSArray *ballArray = [self getUnselectedBallsByPlace:[allKeys objectAtIndex:randomPlace]];
    
    int randomNumber = arc4random() % ballArray.count;
    UIButton *ball = [ballArray objectAtIndex:randomNumber];
    
    ball.selected=YES;
}

//随机从第一位选取first个，从第二位选取second个
- (void)randomSelectFirst:(int)first second:(int)second
{
    NSArray *allKeys = allBallsDictionry.allKeys;
    allKeys = [self sortedArray:allKeys];
    
    if (first > 0 && second > 0)
    {
        for (int i = 0; i < first; ++i)
        {
            NSArray *firstBalls = [self getUnselectedBallsByPlace:[allKeys objectAtIndex:0]];
            int randomNumber = arc4random() % firstBalls.count;
            UIButton *ball = [firstBalls objectAtIndex:randomNumber];
            ball.selected = YES;
        }
        for (int i = 0; i < second; ++i)
        {
            NSArray *secondBalls = [self getUnselectedBallsAtPlace:[allKeys objectAtIndex:1] andPlace:[allKeys objectAtIndex:0]];
            int randomNumber = arc4random() % secondBalls.count;
            UIButton *ball = [secondBalls objectAtIndex:randomNumber];
            ball.selected = YES;
        }
    }
    else
    {
        DDLogError(@"条件不满足");
    }
}
//按数字排序
- (NSArray *)sortedArray:(NSArray *)oneArray
{
    NSArray *sortedArray = [oneArray sortedArrayUsingComparator:^(id obj1,id obj2)
               {
                   int first = [obj1 intValue];
                   int second = [obj2 intValue];
                   if (first < second)
                   {
                       return (NSComparisonResult)NSOrderedAscending;
                   }
                   else if (first > second)
                   {
                       return (NSComparisonResult)NSOrderedDescending;
                   }
                   else
                   {
                       return (NSComparisonResult)NSOrderedSame;
                   }
               }];
    
    return sortedArray;
}
//获取最多共有几种不同号码
- (NSInteger)maxNumWithRandomSelectEach:(int)count
{
    NSInteger maxNumber = 1;
    
    NSArray *allKeys = allBallsDictionry.allKeys;
    
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *place = [allKeys objectAtIndex:i];
        NSArray *allBalls = [self getBallArrayByPlace:place];
        
        NSSet *set = [AMGCombinatorics combinationsWithoutRepetitionFromElements:allBalls taking:count];
        maxNumber *= set.count;
    }
    
    return maxNumber;
}
//从两个place中获取最多共有几种不同号码
- (NSInteger)maxNumWithRandomSelectFirst:(int)first second:(int)second
{
    NSArray *allKeys = allBallsDictionry.allKeys;
    allKeys = [self sortedArray:allKeys];
    
    NSInteger maxNumber = 1;
    
    NSAssert(first > 0 && second > 0, @"条件不满足: first > 0 && second > 0");
    
    NSArray *allBalls = [self getBallArrayByPlace:[allKeys objectAtIndex:0]];
    NSSet *set = [AMGCombinatorics combinationsWithoutRepetitionFromElements:allBalls taking:first];
    maxNumber *= set.count;
    
    NSArray *secondBalls = [self getUnselectedBallsAtPlace:[allKeys objectAtIndex:1] andPlace:[allKeys objectAtIndex:0]];
    set = [AMGCombinatorics combinationsWithoutRepetitionFromElements:secondBalls taking:second];
    maxNumber *= set.count;
    
    return maxNumber;
}
//#pragma 摇一摇
//-(BOOL)canBecomeFirstResponder{
//    return YES;
//}
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    if (!isInputType) {
//        NSString *fimp3 = [[NSBundle mainBundle] pathForResource:@"yyy1" ofType:@"mp3"];
//        [self playaudio:fimp3];
//        
//        [self gotoShakeMyPhone];
//    }
//}
#pragma mark - 增加随机号码
- (void)addRandomNumber
{
    if ([self checkIfReachMaxRandomNumber]) {
        [Utility showErrorWithMessage:BetNumberFullErrorMessage];
        return;
    }
    
    MenuObject *smo = [ruleAndMenuArray objectAtIndex:select_one];
    NSString *title = smo.title;
    
    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
    NSString *name = fouMo.name;
    
    if (isInputType)
    {
        [self getSingleRandom];
        
        NSString *codes = [self getSingleCurrentSelectedCodes];
        if (![self.buyFinishViewController betNumberExist:codes title:title name:name]) {
            LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%lu",theNumberOfBets]];
            [self.buyFinishViewController addLotteryInformation:lotteryInfomation];
        }
        else
        {
            [self addRandomNumber];
        }
    }
    else
    {
        [self gotoShakeMyPhone];
        
        NSString *codes = [self getCurrentSelectedCodes];
        if (![self.buyFinishViewController betNumberExist:codes title:title name:name]) {
            LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%lu",theNumberOfBets]];
            [self.buyFinishViewController addLotteryInformation:lotteryInfomation];
        }
        else
        {
            [self addRandomNumber];
        }
    }
}

//获取单式随机号码
- (void)getSingleRandom
{
    [self cleanSelectNumber];
    
    MenuObject *smo = [ruleAndMenuArray objectAtIndex:select_one];
    NSString *secMenuName = smo.title;
    
    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
    NSString *markString = fouMo.name;
    
    NSMutableString *randomNumber = [NSMutableString string];
    if (([secMenuName isEqualToString:WuXing] ||
         [secMenuName isEqualToString:SiXing] ||
         [secMenuName isEqualToString:HouSanMa] ||
         [secMenuName isEqualToString:QianSanMa] ||
         [secMenuName isEqualToString:ZhongSanMa] ||
         [secMenuName isEqualToString:ErMa]) &&
        ([markString isEqualToString:DanShi] ||
         [markString isEqualToString:HunHe] ||
         [markString isEqualToString:HouErZhiXuanDanShi] ||
         [markString isEqualToString:QianErZhiXuanDanShi] ||
         [markString isEqualToString:HouErZuXuanDanShi] ||
         [markString isEqualToString:QianErZuXuanDanShi]))
    {
        int noLength = 0;
        if ([secMenuName isEqualToString:WuXing])
        {
            noLength = 5;
        }
        else if ([secMenuName isEqualToString:SiXing])
        {
            noLength = 4;
        }
        else if ([secMenuName isEqualToString:HouSanMa] || [secMenuName isEqualToString:QianSanMa] || [secMenuName isEqualToString:ZhongSanMa])
        {
            noLength = 3;
        }
        else if ([secMenuName isEqualToString:ErMa])
        {
            noLength = 2;
        }
        
        if ([markString isEqualToString:HunHe] || [markString isEqualToString:HouErZuXuanDanShi] || [markString isEqualToString:QianErZuXuanDanShi])
        {
            //不能全部都是同一个号码
            BOOL isNotAllSame = NO;
            do {
                randomNumber = [NSMutableString string];
                for (int i = 0; i < noLength; ++i) {
                    int number = arc4random() % 10;
                    [randomNumber appendFormat:@"%d",number];
                };
                
                char aChar = [randomNumber characterAtIndex:0];
                if (randomNumber.length > 1) {
                    for (int i = 1; i < randomNumber.length; ++i) {
                        char anotherChar = [randomNumber characterAtIndex:i];
                        if (aChar != anotherChar) {
                            isNotAllSame = YES;
                            break;
                        }
                    }
                }
                
            } while (!isNotAllSame);
        }
        else
        {
            for (int i = 0; i < noLength; ++i) {
                int number = arc4random() % 10;
                [randomNumber appendFormat:@"%d",number];
            }
        }
    }
    
    //三码混合或二码组选单式 需要排序
    NSString *sortedNumber =  [self sortedOneCode:randomNumber];
    [simpleArray addObject:sortedNumber];
    
    [self setTheNumberOfBets:1];
}

#pragma mark - 检查是否达到最大随机注数
- (BOOL)checkIfReachMaxRandomNumber
{
    NSInteger maxNumber = 0;
    
    MenuObject *smo = [ruleAndMenuArray objectAtIndex:select_one];
    NSString *title = smo.title;
    
    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
    NSString *name = fouMo.name;
    
    //手动输入类型
    if (isInputType)
    {
        if ([title isEqualToString:WuXing] && [name isEqualToString:DanShi])
        {
            maxNumber = 10 * 10 * 10 * 10 * 10;
        }
        else if ([title isEqualToString:SiXing] && [name isEqualToString:DanShi])
        {
            maxNumber = 10 * 10 * 10 * 10;
        }
        else if ([title isEqualToString:HouSanMa] || [title isEqualToString:QianSanMa] || [title isEqualToString:ZhongSanMa])
        {
            if ([name isEqualToString:DanShi]) {
                maxNumber = 10 * 10 * 10;
            }
            //不许3个号码一样且要从小到大
            else if([name isEqualToString:HunHe])
            {
                NSInteger total = 0;
                for (int i = 0; i < 10; ++i) {
                    for (int j = i; j < 10; ++j) {
                        for (int k = j; k < 10; ++k) {
                            total++;
                        }
                    }
                }
                //减去全都一样的情况
                total -= 10;
                maxNumber = total;
            }
        }
        else if ([title isEqualToString:ErMa])
        {
            if ([name isEqualToString:HouErZhiXuanDanShi] || [name isEqualToString:QianErZhiXuanDanShi])
            {
                maxNumber = 10 * 10;
            }
            //不许2个号码一样且要从小到大
            else if ([name isEqualToString:HouErZuXuanDanShi] || [name isEqualToString:QianErZuXuanDanShi])
            {
                NSInteger total = 0;
                for (int i = 0; i < 10; ++i) {
                    for (int j = i; j < 10; ++j) {
                        total++;
                    }
                }
                //减去全都一样的情况
                total -= 10;
                maxNumber = total;
            }
        }
    }
    else
    {
        if ([name isEqualToString:FuShi] ||
            [name isEqualToString:ZuHe] ||
            [name isEqualToString:HouErZhiXuanFuShi] ||
            [name isEqualToString:QianErZhiXuanFuShi] ||
            [name isEqualToString:YiFangFengShun] ||
            [name isEqualToString:HaoShiChengShuang] ||
            [name isEqualToString:SanXingBaoXi] ||
            [name isEqualToString:SiJiFaCai] ||
            [name isEqualToString:BaoDan] ||
            [name isEqualToString:HouSanYiMaBuDingDan] ||
            [name isEqualToString:QianSanYiMaBuDingDan]||
            [name isEqualToString:ZhiXuanHeZhi] ||
            [name isEqualToString:ZuXuanHeZhi] ||
            [name isEqualToString:HouErZhiXuanHeZhi] ||
            [name isEqualToString:QianErZhiXuanHeZhi] ||
            [name isEqualToString:HouErZuXuanHeZhi] ||
            [name isEqualToString:QianErZuXuanHeZhi] ||
            [name isEqualToString:HouEr] ||
            [name isEqualToString:QianEr])
        {
            maxNumber = [self maxNumWithRandomSelectEach:1];
        }
        else if ([name isEqualToString:ZuXuan60])
        {
            maxNumber = [self maxNumWithRandomSelectFirst:1 second:3];
        }
        else if ([name isEqualToString:ZuXuan30])
        {
            maxNumber = [self maxNumWithRandomSelectFirst:2 second:1];
        }
        else if ([name isEqualToString:ZuXuan20]||[name isEqualToString:ZuXuan12])
        {
            maxNumber = [self maxNumWithRandomSelectFirst:1 second:2];
        }
        else if ([name isEqualToString:ZuXuan10]||[name isEqualToString:ZuXuan5]||[name isEqualToString:ZuXuan4])
        {
            maxNumber = [self maxNumWithRandomSelectFirst:1 second:1];
        }
        else if ([name isEqualToString:ZuXuan120])
        {
            maxNumber = [self maxNumWithRandomSelectEach:5];
            
        }
        else if ([name isEqualToString:ZuXuan24])
        {
            maxNumber = [self maxNumWithRandomSelectEach:4];
            
        }
        else if ([name isEqualToString:ZuXuan6]||[name isEqualToString:ZuSan]||[name isEqualToString:ZuXuan]||[name isEqualToString:HouErZuXuanFuShi]||[name isEqualToString:QianErZuXuanFuShi]||[name isEqualToString:HouSanErMaBuDingDan]||[name isEqualToString:QianSanErMaBuDingDan])
        {
            maxNumber = [self maxNumWithRandomSelectEach:2];
            
        }
        else if ([name isEqualToString:ZuLiu])
        {
            maxNumber = [self maxNumWithRandomSelectEach:3];
            
        }
        else if ([name isEqualToString:DingWeiDan])
        {
            maxNumber = 50;
        }
    }
    
    NSInteger totalBetNumber = [self.buyFinishViewController totalBetNumberWithTitle:title name:name];
    DDLogDebug(@"maxNumber:%li",(long)maxNumber);
    DDLogDebug(@"totalBetNumber:%li",(long)totalBetNumber);
    
    BOOL reachMaxRandomNumber = totalBetNumber >= maxNumber;
    
    return reachMaxRandomNumber;
}

- (void)updateIndexs:(NSNotification *)notification
{
    NSArray *array = notification.object;
    select_one = [[array firstObject] intValue];
    select_two = [[array lastObject] intValue];
    
    [self updateMenuIndexs];
}

- (void)setFirstMenuIndex:(NSInteger)firstIndex secondMenuIndex:(NSInteger)secondIndex
{
    select_one = firstIndex;
    select_two = secondIndex;
}
- (void)updateMenuIndexs
{
    [self updateHorizontalMenuAtIndex:select_one];

    [self updateNumbersAtIndex:select_two];
}

- (void)setBuyChooseViewControllerIndex:(BuyChooseViewController *)buyChooseViewController
{
    [buyChooseViewController setFirstMenuIndex:select_one secondMenuIndex:select_two];
}
- (IBAction)addSelectedNumber:(id)sender
{
    [self tappedOnScroll];
    hideKeyBoardBtn.hidden = YES;
    topbutton.enabled = true;
    [self.inpurBeishu resignFirstResponder];
  
    NSString *codes = isInputType ? [self getSingleCurrentSelectedCodes] : [self getCurrentSelectedCodes];
    MenuObject *smo = [ruleAndMenuArray objectAtIndex:select_one];
    NSString *title = smo.title;
    
    PlayRulesDetailObject *fouMo =[verticalMenuItems objectAtIndex:select_two];
    NSString *name = fouMo.name;
    
    if (![self.buyFinishViewController betNumberExist:codes title:title name:name]) {
        LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%lu",theNumberOfBets]];
        NSLog(@"omodel---%@",lotteryInfomation.bettingInformation.omodel
              );
        [self.buyFinishViewController addLotteryInformation:lotteryInfomation];

        }
        else
        {
        [Utility showErrorWithMessage:BetNumberExistErrorMessage delegate:self tag:AlertViewTypeBetNumberExist];
        }
    
    [self cleanSelectNumber];
    [self.finishSelectNum setEnabled:YES];
}
- (IBAction)touchBlank:(id)sender
{
    hideKeyBoardBtn.hidden = YES;
    topbutton.enabled = true;
    self.chooseView.hidden = YES;
    [self.inpurBeishu resignFirstResponder];
}

- (void)dealloc
{
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self.view removeKeyboardControl];
    [doneButton removeFromSuperview];
    
    self.choosePlays.dataSource = nil;
    self.choosePlays.delegate = nil;
    
    [self.JiangQiTableView removeFromSuperview];
}
- (IBAction)gotoHideShade:(id)sender
{
    self.btnHideShade.hidden=YES;
}

- (void)hideBgImg
{
    self.hidebgImg.hidden = YES;
    self.ballScrollView.userInteractionEnabled = YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SHADEBG"];
}
- (void)backButtonClicked:(UIButton *)sender
{
    [self hideBgImg];
    if (SystemVersion >= 7.0) {
        UIImage *image = [UIImage imageNamed:@"navgationbar_bg_64"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.image = image;
        imageView.point = CGPointMake(0, -imageView.frame.size.height);
        [self.view addSubview:imageView];
    }
    
    UIImage *image = [UIImage imageWithView:self.navigationController.navigationBar];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.point = CGPointMake(0, -imageView.frame.size.height);
    [self.view addSubview:imageView];
//    for (UIButton *btn in modeButtons) {
//        if (modeButtons) {
//            
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
