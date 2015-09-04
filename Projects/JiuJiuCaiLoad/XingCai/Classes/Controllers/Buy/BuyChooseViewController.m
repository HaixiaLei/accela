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
#import "SecondMenuObject.h"
#import "ThirdMenuObject.h"
#import "FourthMenuObject.h"
#import "SelectAreaObject.h"
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
#import "ChooseKindsViewController.h"
#import "AccelaUniversalDoneButton.h"

#define BallButtonPoolSize 50
#define MoneyOfEachBet 2
#define BetNumberExistErrorMessage  @"已有相同投注内容，请重新选择"
#define BetNumberFullErrorMessage   @"机选已达最大限制"

@interface BuyChooseViewController ()<UINavigationControllerDelegate>
{
    //奖期倒数计时计时器
    NSTimer *countdownTimer;
    
    //第一级菜单面板选择号
    int firstMenuIndex;
    //水平菜单选择号
    int secondMenuIndex;
    
    //第一级菜单面板
    UIView *firstMenuBoard;
    
    //圆角分模式按钮
    IBOutletCollection(UIButton) NSArray *modeButtons;
    //可追号奖期
    NSMutableArray *keZhuiHaoJiangQis;
    
    //号码球复用池
    NSArray *buttonPool;
    //池中可用号码球序号
    int availableIndex;
    
    //所有号码球，按place归类到不同的数组，key就是place，value就是相同place是号码球
    NSMutableDictionary *allBallsDictionry;
    
    //总注数
    int theNumberOfBets;
    
    BOOL isInputType;
    UIButton *doneButton;
}
@end

@implementation BuyChooseViewController
@synthesize xlTitle;
@synthesize headerV;
@synthesize lockV;
@synthesize arrowImg;

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
    arrowImg.frame = CGRectMake(190.0, 32.0, arrowImg.size.width, arrowImg.size.height);
    if ([UserInfomation sharedInfomation].prizeType)
    {
        [self updatePrizePool];
    }
    
    [self updateMode];
    
    //设置顶部图标
    if ([self.kindOfLottery.cnname isEqualToString:@"重庆时时彩"]) {
        [self.lotteryTypeImage setImage:[UIImage imageNamed:@"marker_cqing"]];
    }else if ([self.kindOfLottery.cnname isEqualToString:@"印尼五分彩"]) {
        [self.lotteryTypeImage setImage:[UIImage imageNamed:@"marker_quick"]];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    if (!self.isChooseMore)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIndexs:) name:NotificationUpdateIndex object:nil];
    }
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = YES;
    [JiangQiManager sharedManager].kindOfLottery = self.kindOfLottery;
    DDLogDebug(@"trace-#2848 shouldShowNextJiangQiAlert = YES,method:%@,class:%@",NSStringFromSelector(_cmd),NSStringFromClass([self class]));
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [JiangQiManager sharedManager].shouldShowNextJiangQiAlert = NO;
    DDLogDebug(@"trace-#2848 shouldShowNextJiangQiAlert = NO,method:%@,class:%@",NSStringFromSelector(_cmd),NSStringFromClass([self class]));
}
-(void)dealloc{
     [doneButton removeFromSuperview];
    if (!self.isChooseMore)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUpdateIndex object:nil];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //摇动开启
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    //获取玩法
    [self getMenuAndRule];
    
    //初始化子view
    [self initSubviews];
    
    //尝试获取奖期
    [self tryToGetJiangqi];
    
    if (!self.isChooseMore)
    {
        [UserInfomation sharedInfomation].prizeType = PrizeTypeLevs;
        [self selectPrizePool:self.levsPrizeButton];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime:) name:NotificationUpdateTime object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
    [AccelaUniversalDoneButton sharedSetupToNumberPadInView:self.view];
}


- (void)viewDidLayoutSubviews
{
    if (!self.isChooseMore)
    {
        //默认选择第一级菜单第一个，生成水平第二级菜单
        [self updateHorizontalMenuAtIndex:2];
        
        //默认选择水平第二级菜单第一个，生成选号按钮面板
        [self updateNumbersAtIndex:0];
    }
    else
    {
        [self updateMenuIndexs];
    }
    
    [self updatePrizePool];
}

- (void)updatePrizePool
{
    if ([UserInfomation sharedInfomation].prizeType == PrizeTypeDefault)
    {
        [self selectPrizePool:self.defaultPrizeButton];
    }
    else if ([UserInfomation sharedInfomation].prizeType == PrizeTypeLevs)
    {
        [self selectPrizePool:self.levsPrizeButton];
    }
}
-(void)playaudio:(NSString *)_path
{
    if (player) {
        [player stop];
    }
    NSLog(@"%@", [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_path] error:nil]);
  
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_path] error:nil];
    [player play];
}

#pragma mark - Init
-(void)setUpArrays
{
    simpleArray =[[NSMutableArray alloc]init];
    //三码

    secondBtnArr=[[NSMutableArray alloc]init];
}

//view init
- (void)initSubviews
{
    //倒计时Label
    int timeIVHeight = 0;
    int timerlabelHeight = 0;
    int timerHMSHeight = 0;
    int secMenuScrollViewHeight = 0;
    if (SystemVersion >= 7.0)
    {
        timeIVHeight = 117;
        timerlabelHeight = 115;
        timerHMSHeight = 115;
        secMenuScrollViewHeight = 64;
    }
    else
    {
        timeIVHeight = 97;
        timerlabelHeight = 96;
        timerHMSHeight = 96;
        secMenuScrollViewHeight = 44;
    }
    
    scrollViewForPlayMethod = [[UIScrollView alloc] initWithFrame:CGRectMake(0, secMenuScrollViewHeight, 320, 41)];
    scrollViewForPlayMethod.delegate = self;

    scrollViewForPlayMethod.pagingEnabled=NO;

    scrollViewForPlayMethod.showsHorizontalScrollIndicator = NO;
    scrollViewForPlayMethod.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollViewForPlayMethod];
    
    [self setFinishButtonEnable:NO];
    
    //创建号码球缓存池
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < BallButtonPoolSize; ++i) {
        UIButton *ball =[UIButton buttonWithType: UIButtonTypeCustom];
        [ball addTarget:self action:@selector(selectBallNumber:) forControlEvents:UIControlEventTouchUpInside];
        [ball setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ball setBackgroundImage:[UIImage imageNamed:@"tag_ball_normal"] forState:UIControlStateNormal];
        [ball setBackgroundImage:[UIImage imageNamed:@"tag_ball_click"] forState:UIControlStateSelected];
        [ball setTitleColor:[UIColor colorWithRed:(135/255.0) green:(95/255.0) blue:(10/255.0) alpha:1] forState:UIControlStateSelected];
        [mutableArray addObject:ball];
    }
    buttonPool = mutableArray;
    availableIndex = 0;
    
    //第一级菜单
    firstMenuBoard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    firstMenuBoard.backgroundColor = [UIColor redColor];
    scrollviewForKinds =[[UIScrollView alloc]init];
    
    UIImageView *backimg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [backimg setImage:[UIImage imageNamed:@"bk_login"]];
    [firstMenuBoard addSubview:backimg];
    UIImageView *Navigekimg =[[UIImageView alloc]init];
    [Navigekimg setImage:[UIImage imageNamed:@"Top_bar.png"]];
    [firstMenuBoard addSubview:Navigekimg];
    UILabel *kindLable =[[UILabel alloc]init];
    kindLable.text=@"玩法选择";
    [kindLable setBackgroundColor:[UIColor clearColor]];
    kindLable.font = [UIFont systemFontOfSize:17];
    kindLable.textAlignment=UITextAlignmentCenter;
    kindLable.textColor=[UIColor whiteColor];
    [firstMenuBoard addSubview:kindLable];
    
    UIButton *backtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [backtn setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [firstMenuBoard addSubview:backtn];
    [backtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    if (SystemVersion>=7.0)
    {
        Navigekimg.frame=CGRectMake(0, 0, 320, 64);
        kindLable.frame=CGRectMake(60, 27, 200, 30);
        backtn.frame = CGRectMake(0, 22, 40, 40);
        scrollviewForKinds.frame=CGRectMake(0, 64, 320, IS_IPHONE5?498:411);
       
    }
    else
    {
        Navigekimg.frame=CGRectMake(0, 0, 320, 44);
        kindLable.frame=CGRectMake(60, 7, 200, 30);
        backtn.frame = CGRectMake(0, 2, 40, 40);
        scrollviewForKinds.frame=CGRectMake(0, 44, 320, IS_IPHONE5?498:411);
    }
   
    [scrollviewForKinds setBackgroundColor:[UIColor clearColor]];
    scrollviewForKinds.showsVerticalScrollIndicator=NO;
    scrollviewForKinds.showsHorizontalScrollIndicator=NO;
    [firstMenuBoard addSubview:scrollviewForKinds];
    

    for (int i = 0; i < ruleAndMenuArray.count; ++i)
    {
        SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:i];
        //往页面上放菜单
        UIButton *secMenuBtn =[UIButton buttonWithType:UIButtonTypeCustom];
       [secMenuBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_methtype"]]];
        NSString *str=[NSString stringWithFormat:@"%@", smo.title];
       
        [secMenuBtn.titleLabel  setFont:[UIFont systemFontOfSize:14]];
        [secMenuBtn setTitle:str forState:UIControlStateNormal];
        [secMenuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [secMenuBtn setTitleColor:[UIColor colorWithRed:(255/255.0) green:(168/255.0) blue:(3/255.0) alpha:1] forState:UIControlStateSelected];
        
//        [secMenuBtn setBackgroundImage:[UIImage imageNamed:@"tag_ball_normal"] forState:UIControlStateNormal];
//        [secMenuBtn setBackgroundImage:[UIImage imageNamed:@"tag_ball_click"] forState:UIControlStateSelected];
        secMenuBtn.tag = i;
        [secondBtnArr addObject:secMenuBtn];
        [secMenuBtn addTarget:self action:@selector(secMenuClk:) forControlEvents:UIControlEventTouchUpInside];
     
        
            secMenuBtn.frame = CGRectMake(49, 30+56*i, 222, 38);
        if (IS_IPHONE5) {
             scrollviewForKinds.contentSize=CGSizeMake(320, 600);
        }else{
         scrollviewForKinds.contentSize=CGSizeMake(320, 600);
        }
       
        [scrollviewForKinds addSubview:secMenuBtn];
    }
    [self.view addSubview:firstMenuBoard];
    firstMenuBoard.hidden = YES;
}
-(void)gotoBack
{
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.5;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    transition.type = kCATransitionPush; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //将动画添加在视图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    firstMenuBoard.hidden=YES;
}
#pragma mark - 奖期
//获取奖期
- (void)tryToGetJiangqi
{
    timerlabel.text = [NSString stringWithFormat:@"距离%@期",self.kindOfLottery.currentJiangQi];
    timerHMS.text = self.kindOfLottery.timeString;
}

- (void)updateTime:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[KindOfLottery class]]) {
        KindOfLottery *kindOfLottery = (KindOfLottery *)object;
        if ([kindOfLottery.cnname isEqualToString:self.kindOfLottery.cnname]) {
            timerHMS.text = kindOfLottery.timeString;
        }
    }
}

- (void)updateJiangQi:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[KindOfLottery class]]) {
        KindOfLottery *kindOfLottery = (KindOfLottery *)object;
        if (kindOfLottery == self.kindOfLottery) {
            timerlabel.text = [NSString stringWithFormat:@"距离%@期",kindOfLottery.currentJiangQi];
        }
    }
}
#pragma mark - 菜单和玩法
- (void)getMenuAndRule
{
    if (self.isChooseMore) {
        return;
    }
    
    ruleAndMenuArray = [[AppCacheManager sharedManager] getMenuAndRuleWithKindOfLottery:self.kindOfLottery];
    
    NSLog(@"kindOfLottery.cnname=%@\nruleAndMenuArray=%@\nlotteryID=%@,nav=%@",self.kindOfLottery.cnname,ruleAndMenuArray,self.kindOfLottery.lotteryId,self.kindOfLottery.nav);
}
#pragma mark - Get & Set Menthods
- (NSArray *)menuAndRule
{
    return ruleAndMenuArray;
}
- (void)setMenuAndRule:(NSArray *)aRuleAndMenuArray
{
    ruleAndMenuArray = aRuleAndMenuArray;
}

#pragma mark - 按钮事件
//返回按钮
- (IBAction)returnBtnClk:(UIButton *)sender
{
    [self cleanUpAndPop];
}
//帮助按钮
- (IBAction)goToInfoOfPlayMethod:(id)sender {
    InfoOfPlayMethodViewController *infoViewController= [[InfoOfPlayMethodViewController alloc] initWithNibName:@"InfoOfPlayMethodViewController" bundle:nil];
    infoViewController.infoType = InfoTypePlayMethod;
    infoViewController.tagName = @"时时彩";
    [self.navigationController pushViewController:infoViewController animated:YES];
}
//顶部标题按钮事件
- (IBAction)selectGame:(id)sender
{
    arrowImg.image = [UIImage imageNamed:@"btn_arrow_click"];
    firstMenuBoard.hidden = !firstMenuBoard.hidden;
    [xlPicIV setImage:[UIImage imageNamed:@"btn_down"]];
    lockV.hidden = YES;

//    if (!firstMenuBoard.hidden)
//    {
//        [xlPicIV setImage:[UIImage imageNamed:@"btn_up"]];
//        lockV.hidden = NO;
//    }
//    else
//    {
//        [xlPicIV setImage:[UIImage imageNamed:@"btn_down"]];
//        lockV.hidden = YES;
//    }
//    
}
- (IBAction)touchDownSelectGame:(id)sender
{
    arrowImg.image = [UIImage imageNamed:@"btn_arrow_normal"];
}

//第一级菜单面板选择事件
- (void)secMenuClk:(UIButton *)sender
{
    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:sender.tag];
    //判断是否有具体玩法
    if (smo.label && smo.label.count > 0)
    {
        if (smo.title.length == 2)
        {
            arrowImg.frame = CGRectMake(181.0, 32.0, arrowImg.size.width, arrowImg.size.height);
        }
        else if (smo.title.length == 3)
        {
            arrowImg.frame = CGRectMake(190.0, 32.0, arrowImg.size.width, arrowImg.size.height);
        }
        else if (smo.title.length == 4)
        {
            arrowImg.frame = CGRectMake(198.0, 32.0, arrowImg.size.width, arrowImg.size.height);
        }
        //更新水平菜单项
        [self updateHorizontalMenuAtIndex:sender.tag];
        //默认选择第一种
        UIButton *button = [verticalMenuButtons objectAtIndex:0];
        [self enterIntoSelectNumber:button];
    }
    else
    {
        [Utility showErrorWithMessage:@"即将推出，敬请期待"];
    }
}

//水平菜单按钮事件
-(void)enterIntoSelectNumber:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [xlPicIV setImage:[UIImage imageNamed:@"btn_down"]];
    lockV.hidden = YES;
    
    [self updateNumbersAtIndex:button.tag];
}

//self.view单击手势事件
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [textview resignFirstResponder];
}

// 元角分模式选择按钮事件
-(IBAction)selectMoneyModes:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    for (UIButton *modeButton in modeButtons) {
        modeButton.selected = NO;
    }
    button.selected = YES;
    [UserInfomation sharedInfomation].modeIndex = button.tag;
    
    [self updateBetMoneyAndBetNumber];
}

//奖池按钮事件
-(IBAction)selectPrizePool:(UIButton *)sender
{
    [UserInfomation sharedInfomation].prizeType = sender.tag;
    [UserInfomation sharedInfomation].prePrizeType = sender.tag;
    
    [self updatePrizePoolWithType:sender.tag];
}
- (void)updatePrizePoolWithType:(PrizeType)type
{
    if (type == PrizeTypeDefault) {
        self.defaultPrizeButton.selected = YES;
        self.levsPrizeButton.selected = NO;
        [[self.defaultPrizeButton superview] bringSubviewToFront:self.defaultPrizeButton];
    }
    else if(type == PrizeTypeLevs)
    {
        self.defaultPrizeButton.selected = NO;
        self.levsPrizeButton.selected = YES;
        [[self.levsPrizeButton superview] bringSubviewToFront:self.levsPrizeButton];
    }
}
//清空按钮事件
- (IBAction)cleanNumber:(id)sender
{
    [self cleanSelectNumber];
}

#pragma mark - 确认按钮事件
- (IBAction)finishSelectNumber:(id)sender
{
    if (!self.isChooseMore) {
        BuyFinishViewController *buyFinshVC = [[BuyFinishViewController alloc]initWithNibName:@"BuyFinishViewController" bundle:nil];
        self.buyFinishViewController = buyFinshVC;
        buyFinshVC.buyChooseViewController = self;
        
        NSString *codes = isInputType ? [self getSingleCurrentSelectedCodes] : [self getCurrentSelectedCodes];
        LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%d",theNumberOfBets]];
        [buyFinshVC addLotteryInformation:lotteryInfomation];
        
        SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
        buyFinshVC.lotteryid = smo.lotteryid;
        buyFinshVC.titleLabelText = self.kindOfLottery.cnname;
        [self.navigationController pushViewController:buyFinshVC animated:YES];
    }
    else
    {
        SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
        NSString *title = smo.title;
        
        FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
        NSString *name = fouMo.name;

        NSString *codes = isInputType ? [self getSingleCurrentSelectedCodes] : [self getCurrentSelectedCodes];
        
        if (![self.buyFinishViewController betNumberExist:codes title:title name:name]) {
            LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%d",theNumberOfBets]];
            [self.buyFinishViewController addLotteryInformation:lotteryInfomation];
            
            [self cleanUpAndPop];
        }
        else
        {
            [Utility showErrorWithMessage:BetNumberExistErrorMessage delegate:self tag:AlertViewTypeBetNumberExist];
        }
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
    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
    NSString *secMenuName = smo.title;
    
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
    NSString *markString = fouMo.name;
    
    if ((([secMenuName isEqualToString:HouSanMa] || [secMenuName isEqualToString:QianSanMa] || [secMenuName isEqualToString:ZhongSanMa]) && ([markString isEqualToString:HunHe] || [markString isEqualToString:HunHeZuXuan])) ||
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
-(void)updateHorizontalMenuAtIndex:(int)index
{
    for (UIButton *btn in secondBtnArr)
    {
        btn.selected = NO;
    }
    
    //防止index越界
    if (index >= secondBtnArr.count) {
        return;
    }
    
    UIButton *button = [secondBtnArr objectAtIndex:index];
    button.selected = YES;
    
    firstMenuIndex = index;
    
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

    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:index];
   
    xlTitle.text = smo.title;
    //air-25-7--------------------------------------------------------------------------------------------------------begin
    int charLength = xlTitle.text.length * 15;
    int xlPicLocation = ((320 - charLength) / 2) + charLength;
    xlPicIV.frame = CGRectMake(xlPicLocation+5, 17, 16, 12);
    //air-25-7--------------------------------------------------------------------------------------------------------end
    
    //取4级菜
    if (!verticalMenuItems) {
        verticalMenuItems = [NSMutableArray array];
    }
    else
    {
        [verticalMenuItems removeAllObjects];
    }
    for (int i = 0; i < smo.label.count; ++i) {
        ThirdMenuObject *thirdMenuObject = [smo.label objectAtIndex:i];
        [verticalMenuItems addObjectsFromArray:thirdMenuObject.label];
    }
    
    //设置滑动的菜单
    for (int k=0; k<verticalMenuItems.count; k++)
    {
        FourthMenuObject *fmo = [verticalMenuItems objectAtIndex:k];
        scrollViewForPlayMethod.contentSize = CGSizeMake(120+104*k, 41);
        
        UIButton *hdBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        hdBtn.tag=k;
        NSString *title = [NSString stringWithFormat:@"%@", fmo.name];
        [hdBtn setTitle:title forState:UIControlStateNormal];
//        [hdBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
//        [hdBtn setBackgroundImage:[UIImage imageNamed:@"bk_choose_normal"] forState:UIControlStateNormal];
        [hdBtn setBackgroundImage:[UIImage imageNamed:@"tag_remark"] forState:UIControlStateSelected];
        [hdBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
         [hdBtn setTitleColor:[UIColor colorWithRed:(200/255.0) green:(197/255.0) blue:(196/255.0) alpha:1] forState:UIControlStateNormal];
         [hdBtn setTitleColor:[UIColor colorWithRed:(255/255.0) green:(168/255.0) blue:(3/255.0) alpha:1] forState:UIControlStateSelected];
        //air-27-8--------------------------------------------------------------------------------------------------------begin
//        hdBtn.titleLabel.shadowColor =[UIColor redColor];
//        hdBtn.titleLabel.shadowOffset = CGSizeMake(10, 4.0);
        //air-27-8--------------------------------------------------------------------------------------------------------end
        if ([smo.title isEqualToString:ErMa]||[smo.title isEqualToString:BuDingDan]) {
              [hdBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        }else
        {
          [hdBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        }
      
        [hdBtn addTarget:self action:@selector(enterIntoSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
        if (verticalMenuItems.count == 1)
        {
            hdBtn.frame = CGRectMake(110, 0, 108,41);
        }
        else if (verticalMenuItems.count == 2)
        {
            hdBtn.frame = CGRectMake(60+105*k, 0, 108, 41);
        }
        else
        {
            hdBtn.frame = CGRectMake(6+105*k, 0, 108, 41);
        }
       
        [verticalMenuButtons addObject:hdBtn];
        [scrollViewForPlayMethod addSubview:hdBtn];
        button.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    
}

#pragma 设置号码球x
//设置选号球
-(void)updateNumbersAtIndex:(int)index
{
    self.ballScrollView.contentOffset =CGPointMake(0, 395);
    
//设置水平菜单项选中状态
    for (UIButton *btn in verticalMenuButtons)
    {
        btn.selected = NO;
    }
    UIButton *button = [verticalMenuButtons objectAtIndex:index];
    button.selected = YES;
    
    secondMenuIndex = index;
//    preFirstMenuIndex = firstMenuIndex;
    if (self.isChooseMore) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateIndex object:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",firstMenuIndex],[NSString stringWithFormat:@"%d",secondMenuIndex],nil]];
    }
    
    firstMenuBoard.hidden = YES;
    
    [self cleanAllBallsDictionry];
    
    for (UIView *view in self.ballScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [self setFinishButtonEnable:NO];
    
    timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 34)];
    [timeIV setImage:[UIImage imageNamed:@"tag_ingor_nav"]];
    [self.ballScrollView addSubview:timeIV];
    
    timerlabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 180, 24)];
    timerlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    timerlabel.textColor = [UIColor whiteColor];
    timerlabel.textAlignment = UITextAlignmentLeft;
    timerlabel.backgroundColor = [UIColor clearColor];
    timerlabel.text = @"距离：";
    [self.ballScrollView addSubview:timerlabel];
    
     UIImageView*timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(190,4, 27, 26)];
    [timeImg setImage:[UIImage imageNamed:@"tag_deadline"]];
    [self.ballScrollView addSubview:timeImg];
    
    timerHMS= [[UILabel alloc] initWithFrame:CGRectMake(220,5, 100, 24)];
    timerHMS.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    timerHMS.textColor = [UIColor colorWithRed:255.0/255 green:198.0/255 blue:5.0/255 alpha:1];
    timerHMS.textAlignment = UITextAlignmentCenter;
    timerHMS.backgroundColor = [UIColor clearColor];
    [self.ballScrollView addSubview:timerHMS];
    //尝试获取奖期
    [self tryToGetJiangqi];

    //更新标题
    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:index];
    //xlTitle.text = [NSString stringWithFormat:@"%@●%@",smo.title,fouMo.name];
    xlTitle.text = [NSString stringWithFormat:@"%@",smo.title];
//    NSLog(@"%@--",fouMo.name);
    //判断是否是手动输入
    isInputType = [fouMo.selectarea.type isEqualToString:@"input"] ? YES : NO;

    if (!isInputType) {
        UIImageView* shakeimg = [[UIImageView alloc] initWithFrame:CGRectMake(280,36, 29,21.5)];
        [shakeimg setImage:[UIImage imageNamed:@"tag_shakeit"]];
        [self.ballScrollView addSubview:shakeimg];
    }
    
    //提示玩法
    
    UILabel*tipsLable = [[UILabel alloc] init];

    if (isInputType) {
        tipsLable.frame=CGRectMake(20, 40, 280, 28.5);
         tipsLable.font = [UIFont systemFontOfSize:12];
    }else{
        tipsLable.frame=CGRectMake(10,37, 260, 30);
        if (fouMo.methoddesc.length<28) {
            tipsLable.font = [UIFont systemFontOfSize:12];
        }else{
            tipsLable.font = [UIFont systemFontOfSize:11];
           
        }

    }
    tipsLable.textColor = [UIColor  whiteColor];
    tipsLable.textAlignment = UITextAlignmentLeft;
    tipsLable.backgroundColor = [UIColor clearColor];
    tipsLable.lineBreakMode=UILineBreakModeWordWrap;
    tipsLable.numberOfLines=0;
    tipsLable.text=fouMo.methoddesc;
   
    
    tipsLable.adjustsFontSizeToFitWidth=YES;
    [self.ballScrollView addSubview:tipsLable];
   
//    lotteryName=fouMo.name;
    int charLength = xlTitle.text.length * 15;
    int xlPicLocation = ((320 - charLength) / 2) + charLength;
    if (xlPicIV == nil)
    {
        xlPicIV = [[UIImageView alloc] initWithFrame:CGRectMake(xlPicLocation+5, 35, 16, 12)];
        [xlPicIV setImage:[UIImage imageNamed:@"btn_down"]];
        [self.headerV addSubview:xlPicIV];
    }
    else
    {
        xlPicIV.frame = CGRectMake(xlPicLocation+5, 35, 16, 12);
    }
    
    self.ballScrollView.scrollEnabled = YES;
    
    NSArray *layout = fouMo.selectarea.orderlylayout;
     
    float moneyModesHight = 0;
    
    if (layout && [layout respondsToSelector:@selector(count)] && layout.count > 0)
    {
        //ballScrollView总高度
        float totalHeight = 8;
        for (int i = 0; i < layout.count; i++)
        {
            LayoutObject *layoutObject = [layout objectAtIndex:i];
            
            NSString *title = layoutObject.title;
            NSInteger place = [layoutObject.place integerValue];
            
            NSArray *ballArray = layoutObject.numbers;
            
            //计算背景高度
            int selectAreaHeigth = ((ballArray.count - 1) / 5 + 1) * 48;
            totalHeight = (selectAreaHeigth+8)*place + 8;
            //灰色背景view
            UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, totalHeight+60, 320, selectAreaHeigth+10)];
            [bgview setBackgroundColor:[UIColor clearColor]];
            [self.ballScrollView addSubview:bgview];
            
            
//            lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(0,selectAreaHeigth, 320,1)];
//            [lineIV setImage:[UIImage imageNamed:@"bk_line"]];
//            [bgview addSubview:lineIV];

            
            moneyModesHight = (selectAreaHeigth + 10)*layout.count + 8;
          
            //位数标签
            if (![title isEqualToString:@""])
            {
                UIImageView *weiFlagBg =[[UIImageView alloc] initWithFrame:CGRectMake(1, 5,44 , 17)];
                 [weiFlagBg setImage:[UIImage imageNamed:@"tag_places"]];
                UILabel *ballTitle =[[UILabel alloc] initWithFrame:CGRectMake(3, 5, 40, 18)];
                 ballTitle.textAlignment = UITextAlignmentCenter;
                  [ballTitle setBackgroundColor:[UIColor clearColor]];
                ballTitle.textColor = [UIColor colorWithRed:(42/255.0) green:(42/255.0) blue:(42/255.0) alpha:1];
                ballTitle.text = title;

                if (title.length < 4)
                {
                     ballTitle.textAlignment = UITextAlignmentCenter;
                     ballTitle.font = [UIFont systemFontOfSize:12];
                }
                else
                {
                   
                     ballTitle.font = [UIFont systemFontOfSize:10];
                }
              
                
              
                [bgview addSubview:weiFlagBg];
                [bgview addSubview:ballTitle];
            }
            
            //生成小球
            for (int i = 0; i < ballArray.count; i++)
            {
                NSString *numStr =[ballArray objectAtIndex:i];
                UIButton *ball = [self getButtonFromPool];

                ball.tag = i;
                
                int col = i % 5;
                int row = i / 5;
                
                [ball setTitle:numStr forState:UIControlStateNormal];
                [ball.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
                ball.frame = CGRectMake(58 + 52 * col, 50 * row, 45, 45);
                [bgview addSubview:ball];
                
                [self addBallToDictionary:ball place:layoutObject.place];
            }
        }
        
        moneyModesHight += 70;
        [self setUpMoneyModeWithHeight:moneyModesHight fouMo:fouMo];
        moneyModesHight += self.monyModeBoardView.frame.size.height+10;
        
        [self setUpModeWithHeight:moneyModesHight];
        moneyModesHight += self.modeBoardView.frame.size.height-20;
        
        if (SystemVersion >= 7.0) {
            moneyModesHight += 20;
               self.ballScrollView.contentSize =CGSizeMake(320, moneyModesHight+2);
        }else{
           self.ballScrollView.contentSize =CGSizeMake(320, moneyModesHight+22);
        }
     
    }
    else
    {
        self.ballScrollView.scrollEnabled = NO;
        textview = [[UITextView alloc]initWithFrame:CGRectMake(10,75 , 300, 80)];
        [textview setBackgroundColor:[UIColor clearColor]];
        textview.layer.borderColor=UIColor.lightGrayColor.CGColor;
        textview.layer.borderWidth = 1;
        [textview.layer setCornerRadius:10];
        textview.delegate = self;
        
        textview.font=[UIFont systemFontOfSize:16];
        textview.keyboardType = UIKeyboardTypeNumberPad;
        textview.returnKeyType = UIReturnKeyDone;
        [self.ballScrollView addSubview:textview];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapGr];
        
        moneyModesHight += textview.frame.size.height + 20;
        
        [self setUpMoneyModeWithHeight:moneyModesHight fouMo:fouMo];
        moneyModesHight += self.monyModeBoardView.frame.size.height;
        
        [self setUpModeWithHeight:moneyModesHight];
    }
    
    //自动滚动到顶部
    [self.ballScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)setUpMoneyModeWithHeight:(float)moneyModesHight fouMo:(FourthMenuObject *)fouMo
{
    if (fouMo.prize.allValues && [fouMo.prize.allValues performSelector:@selector(count)] && fouMo.prize.allValues.count > 0 && fouMo.nfdprize.levs.length > 0)
    {
        float modeBoardBottomLenghtInSuperView = self.ballScrollView.frame.origin.y + moneyModesHight + self.monyModeBoardView.frame.size.height + self.ballScrollView.superview.frame.origin.y + self.modeBoardView.frame.size.height;
        
        if (modeBoardBottomLenghtInSuperView < self.bottomView.frame.origin.y) {
            moneyModesHight = self.bottomView.frame.origin.y - self.ballScrollView.frame.origin.y - self.monyModeBoardView.frame.size.height - self.ballScrollView.superview.frame.origin.y - self.modeBoardView.frame.size.height;
            self.ballScrollView.scrollEnabled = NO;
        }
        
        self.monyModeBoardView.point = CGPointMake(0, moneyModesHight);
        [self.ballScrollView addSubview:self.monyModeBoardView];
        
        NSString *rateOneStr = [NSString stringWithFormat:@"奖金%@-%@\%%",fouMo.nfdprize.defaultprize,fouMo.nfdprize.userdiffpoint];
        NSString *rateTwoStr = [NSString stringWithFormat:@"奖金%@-0%%",fouMo.nfdprize.levs];
        [self.defaultPrizeButton setTitle:rateOneStr forState:UIControlStateNormal];
        [self.defaultPrizeButton setTitle:rateOneStr forState:UIControlStateSelected];
        [self.defaultPrizeButton setTitleColor:[UIColor colorWithRed:190.0/255 green:169.0/255 blue:106.0/255 alpha:1] forState:UIControlStateNormal];
        [self.defaultPrizeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.defaultPrizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.levsPrizeButton setTitle:rateTwoStr forState:UIControlStateNormal];
        [self.levsPrizeButton setTitle:rateTwoStr forState:UIControlStateSelected];
        [self.levsPrizeButton setTitleColor:[UIColor colorWithRed:190.0/255 green:169.0/255 blue:106.0/255 alpha:1] forState:UIControlStateNormal];
         [self.levsPrizeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.levsPrizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [UserInfomation sharedInfomation].prizeType = [UserInfomation sharedInfomation].prePrizeType;
        [self updatePrizePoolWithType:[UserInfomation sharedInfomation].prizeType];
    }
    else
    {
        [UserInfomation sharedInfomation].prizeType = PrizeTypeDefault;
        [self updatePrizePoolWithType:[UserInfomation sharedInfomation].prizeType];
    }
}
- (void)setUpModeWithHeight:(float)moneyModesHight
{
    float modeBoardBottomLenghtInSuperView = self.ballScrollView.frame.origin.y + moneyModesHight + self.ballScrollView.superview.frame.origin.y + self.modeBoardView.frame.size.height;
    
    if (modeBoardBottomLenghtInSuperView < self.bottomView.frame.origin.y) {
        moneyModesHight = self.bottomView.frame.origin.y - self.ballScrollView.frame.origin.y - self.ballScrollView.superview.frame.origin.y - self.modeBoardView.frame.size.height;
        self.ballScrollView.scrollEnabled = NO;
    }
    self.modeBoardView.point = CGPointMake(0, moneyModesHight);
    [self.ballScrollView addSubview:self.modeBoardView];
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
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
    NSString *name = fouMo.name;
        if ([name isEqualToString:BaoDan])
    {
        NSArray *baoDanButtonArray = [self getSelectedBallsByPlace:@"0"];
        if (baoDanButtonArray.count > 1) {
            [Utility showErrorWithMessage:@"最多选择一个号码"];
            button.selected = NO;
        }
    }
    
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
        
        int times = [[showStr componentsSeparatedByString:@"X"] count] - 1;
        
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
        [self.finishSelectNum setEnabled:YES];
        [self.finishSelectNum setTitleColor:[UIColor colorWithRed:255.0/255 green:169.0/255 blue:3.0/255 alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        [self.finishSelectNum setEnabled:NO];
        [self.finishSelectNum setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        theNumberOfBets = 0;
        [self updateBetMoneyAndBetNumber];
    }
}

//更新总价
- (void)updateBetMoneyAndBetNumber
{
    FourthMenuObject *rule =[verticalMenuItems objectAtIndex:secondMenuIndex];
    ModeObject *mode = [rule.modes objectAtIndex:[UserInfomation sharedInfomation].modeIndex];
    int rate = [mode.rate floatValue] * RateToInt;
    long long money = theNumberOfBets * MoneyOfEachBet * rate;
    
    self.betNumber.text = [NSString stringWithFormat:@"%@元x%i注=",[Utility formatStringFromDouble:2 * [mode.rate floatValue]],theNumberOfBets];
    self.betMoney.text = [Utility formatStringFromDouble:(double)money / RateToInt];
  
    [self.betNumber sizeToFit];
    [self.betMoney sizeToFit];
    [self.yuanLabel sizeToFit];
    
    int totalWidth = self.betNumber.frame.size.width + self.betMoney.frame.size.width + self.yuanLabel.frame.size.width;
    int screenWidth = ScreenSize.width;
    
    int origin = screenWidth * 0.5 - totalWidth * 0.5;
    
    self.betNumber.point = CGPointMake(origin, self.betNumber.point.y);
    origin += self.betNumber.frame.size.width;
    
    self.betMoney.point = CGPointMake(origin, self.betMoney.point.y);
    origin += self.betMoney.frame.size.width;
    
    self.yuanLabel.point = CGPointMake(origin, self.yuanLabel.point.y);
}

#pragma mark - UITextViewDelegate
//单式
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
    NSString *secMenuName = smo.title;
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
    NSString *markString = fouMo.name;
    
    int eachLength = 0;
    if ([secMenuName isEqualToString:WuXing] && [markString isEqualToString:DanShi])//五星
    {
        eachLength = 5;
    }
    else if ([secMenuName isEqualToString:SiXing] && [markString isEqualToString:DanShi])//四星
    {
        eachLength = 4;
    }
    else if ([secMenuName isEqualToString:ZuXuan])//混合组选
    {
        eachLength = 3;
    }
    else if (([secMenuName isEqualToString:HouSanMa] || [secMenuName isEqualToString:QianSanMa] || [secMenuName isEqualToString:ZhongSanMa]) && ([markString isEqualToString:DanShi] || ([markString isEqualToString:HunHe] || [markString isEqualToString:HunHeZuXuan])))//三码
    {
        eachLength = 3;
    }
    else if ([secMenuName isEqualToString:ErMa] && ([markString isEqualToString:HouErZhiXuanDanShi] || [markString isEqualToString:QianErZhiXuanDanShi] || [markString isEqualToString:HouErZuXuanDanShi] || [markString isEqualToString:QianErZuXuanDanShi]))//二码
    {
        eachLength = 2;
    }
    
    if (eachLength > 0) {
        if (textView.text.length == range.location)
        {
            NSString *textStr = textView.text;
            NSArray *separatedStr = [textStr componentsSeparatedByString:@","];
            
            NSString *lastSeparatedStr = [separatedStr lastObject];
            if (lastSeparatedStr.length == eachLength)
            {
                NSString *tempStr = [textView.text stringByAppendingString:@","];
                
                //取消undo事件,防止ios7crash
                [textView.undoManager removeAllActions];
                textView.text = tempStr;
            }
        }
    }
    
    return YES;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //提取数字，滤掉其他字符
    if (textView.text.length > 0) {
        NSMutableString *string = [NSMutableString string];
        NSString *text = textView.text;
        
        //逐个找到数字
        for (int i = 0; i < text.length; i++) {
            NSString *temp = [text substringWithRange:NSMakeRange(i, 1)];
            if ([self isPureInt:temp]) {
                [string appendString:[NSString stringWithFormat:@"%i",temp.intValue]];
            }else if (string.length > 0 && ![[string substringWithRange:NSMakeRange(string.length-1, 1)] isEqualToString:@" "]){
                [string appendString:@" "];
            }
        }
        
        //去除多余的空格
        NSString *fString = string;
        while ([fString rangeOfString:@" "].location == 0 && fString.length > 1) {
            fString = [fString substringFromIndex:1];
        }
        while ([fString rangeOfString:@" " options:NSBackwardsSearch].location == fString.length-1 && fString.length > 1) {
            fString = [fString substringToIndex:fString.length-1];
        }
        
        if ([fString isEqualToString:@" "]) {
            fString = @"";
        }
        textView.text = fString;
        
        NSLog(@"string===%@",string);
        
    }
    
    NSMutableString *alertMsg = [NSMutableString string];
    //把空格(如果有)，替换成逗号
    NSRange range = [textView.text rangeOfString:@" "];
    if(range.location != NSNotFound)
    {
        textView.text = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@","];
    }

    if (textView.text.length > 0)
    {
        [simpleArray removeAllObjects];
        SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
        NSString *secMenuName = smo.title;
        
        FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
        NSString *markString = fouMo.name;
        
        if (([secMenuName isEqualToString:WuXing] ||
             [secMenuName isEqualToString:SiXing] ||
             [secMenuName isEqualToString:HouSanMa] ||
             [secMenuName isEqualToString:QianSanMa] ||
             [secMenuName isEqualToString:ZhongSanMa] ||
             [secMenuName isEqualToString:ErMa]) &&
            ([markString isEqualToString:DanShi] ||
             ([markString isEqualToString:HunHe] || [markString isEqualToString:HunHeZuXuan]) ||
             [markString isEqualToString:HouErZhiXuanDanShi] ||
             [markString isEqualToString:QianErZhiXuanDanShi] ||
             [markString isEqualToString:HouErZuXuanDanShi] ||
             [markString isEqualToString:QianErZuXuanDanShi]))
        {
            //NSString *tvStr = [textview.text stringByReplacingOccurrencesOfString:@" " withString:@"&"];
            NSString *ruleNo = @"";
            NSString *notRuleNo = @"";
            NSString *sameNo = @"";
            NSArray *arr = [textview.text componentsSeparatedByString:@","];
            //五星长度－5；四星长度－4
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
            
            for (NSString *str in arr)
            {
                if (str.length == noLength)
                {
                    NSString *sortedString = [self sortedOneCode:str];
                    [simpleArray addObject:sortedString];
                    
                    //把合法的组装成一个字符串
                 
                    if (ruleNo.length > 0) {
                        ruleNo = [[ruleNo stringByAppendingString:@","] stringByAppendingString:sortedString];
                    }
                    else
                    {
                        ruleNo = [ruleNo stringByAppendingString:sortedString];
                    }
                }
                else
                {
                    //把不合法的组装成一个字符串
                    if (notRuleNo.length > 0)
                    {
                        notRuleNo = [[notRuleNo stringByAppendingString:@","] stringByAppendingString:str];
                    }
                    else
                    {
                        notRuleNo = [notRuleNo stringByAppendingString:str];
                    }
                }
            }
            //air-0304-2-----------------单式不能有相同的两组号码---------------------------------begin
            //组装sameArray,这个地方比较麻烦
            NSMutableArray *theSameArray = [NSMutableArray array];
            for (int i = 0; i < simpleArray.count; ++i)
            {
                NSString *str = [simpleArray objectAtIndex:i];
                for (int j = i; j < simpleArray.count; ++j)
                {
                    if (j + 1 < simpleArray.count)
                    {
                        NSString *str1 = [simpleArray objectAtIndex:j + 1];
                        if ([str isEqualToString:str1])
                        {
                            [theSameArray addObject:str];
                        }
                    }
                }
            }
            sameArray = theSameArray;
            //-------------------这几行代码重新组装simpleArray-------------begin
            NSMutableArray *tempSimArray = [NSMutableArray array];
            for (int i = 0; i < simpleArray.count; ++i)
            {
                NSString *str = [simpleArray objectAtIndex:i];
                BOOL findSame = NO;
                for (int j = i; j < simpleArray.count; ++j)
                {
                    if (j + 1 < simpleArray.count)
                    {
                        NSString *str1 = [simpleArray objectAtIndex:j + 1];
                        if ([str isEqualToString:str1])
                        {
                            findSame = YES;
                        }
                    }
                }
                if (!findSame)
                {
                    [tempSimArray addObject:str];
                }
            }
            simpleArray = tempSimArray;
            //-------------------这几行代码重新组装simpleArray-------------end
            //非法号码的判断---begin
            if ((notRuleNo.length > 0) && (sameArray.count > 0))
            {
                NSString *errMsg1 = [@"错误号码:" stringByAppendingString:notRuleNo];
                
                for (NSString *str in sameArray)
                {
                    sameNo = [[sameNo stringByAppendingString:@","] stringByAppendingString:str];
                }
                NSString *errMsg2 = [@";重复号码:" stringByAppendingString:[sameNo substringFromIndex:1]];
                
                NSString *errMsg = [[errMsg1 stringByAppendingString:errMsg2] stringByAppendingString:@",已被自动过滤!\n"];
                [alertMsg appendString:errMsg];
                
                //以下代码的目的是textview里，只显示一次重复的号码
                NSString *tvStr = @"";
                for (int i = 0; i < simpleArray.count; ++i)
                {
                    NSString *str = [simpleArray objectAtIndex:i];
                    tvStr = [[tvStr stringByAppendingString:@","] stringByAppendingString:str];
                }
                
                //取消undo事件,防止ios7crash
                [textView.undoManager removeAllActions];
                textView.text = [tvStr substringFromIndex:1];
            }
            else if (notRuleNo.length > 0)
            {
                [alertMsg appendString:[[@"错误号码:" stringByAppendingString:notRuleNo] stringByAppendingString:@",已被自动过滤!\n"]];
                
                [textView.undoManager removeAllActions];
                textview.text = ruleNo;
            }
            else if (sameArray.count > 0)
            {
                //提示，重复号码过滤掉
                for (NSString *str in sameArray)
                {
                    sameNo = [[sameNo stringByAppendingString:@","] stringByAppendingString:str];
                }
                [alertMsg appendString:[[@"重复号码:" stringByAppendingString:[sameNo substringFromIndex:1]] stringByAppendingString:@",已被自动过滤!\n"]];
                
                //以下代码的目的是textview里，只显示一次重复的号码
                NSString *tvStr = @"";
                for (int i = 0; i < simpleArray.count; ++i)
                {
                    NSString *str = [simpleArray objectAtIndex:i];
                    tvStr = [[tvStr stringByAppendingString:@","] stringByAppendingString:str];
                }
                
                //取消undo事件,防止ios7crash
                [textView.undoManager removeAllActions];
                textView.text = [tvStr substringFromIndex:1];
            }
            //处理二码组选(单)-比较特殊－两个号码不能完全一样11------------------begin
            if ([markString isEqualToString:HouErZuXuanDanShi] || [markString isEqualToString:QianErZuXuanDanShi])
            {
                NSString *equalStr = @"";
                NSMutableArray *tempSimArray2 = [NSMutableArray array];
                for (int i = 0; i < simpleArray.count; ++i)
                {
                    NSString *str = [simpleArray objectAtIndex:i];
                    NSString *str1 = [str substringToIndex:1];
                    NSString *str2 = [str substringFromIndex:1];
                    if ([str1 isEqualToString:str2])
                    {
                        equalStr = [[equalStr stringByAppendingString:@","] stringByAppendingString:str];
                    }
                    else
                    {
                        [tempSimArray2 addObject:str];
                    }
                }
                if (![equalStr isEqualToString:@""])
                {
                    [alertMsg appendString:[[@"非法的号码:" stringByAppendingString:[equalStr substringFromIndex:1]] stringByAppendingString:@",已被自动过滤!\n"]];
                }
                [simpleArray removeAllObjects];
                simpleArray = tempSimArray2;
                //以下代码的目的是textview里，只显示一次重复的号码
                if (simpleArray.count > 0)
                {
                    NSString *tvStr = @"";
                    for (int i = 0; i < simpleArray.count; ++i)
                    {
                        NSString *str = [simpleArray objectAtIndex:i];
                        tvStr = [[tvStr stringByAppendingString:@","] stringByAppendingString:str];
                    }
                    
                    //取消undo事件,防止ios7crash
                    [textView.undoManager removeAllActions];
                    textView.text = [tvStr substringFromIndex:1];
                }
                else
                {
                    //取消undo事件,防止ios7crash
                    [textView.undoManager removeAllActions];
                    textView.text = @"";
                }
            }
            //处理二码组选(单)-比较特殊－两个号码不能完全一样99------------------end
            //处理三码(混合)-比较特殊－两个号码不能完全一样111------------------begin
            if ([markString isEqualToString:HunHe] || [markString isEqualToString:HunHeZuXuan])
            {
                NSString *equalStr = @"";
                NSMutableArray *tempSimArray2 = [NSMutableArray array];
                for (int i = 0; i < simpleArray.count; ++i)
                {
                    NSString *str = [simpleArray objectAtIndex:i];
                    NSString *str1 = [str substringToIndex:1];
                    NSString *str2 = [str substringWithRange:NSMakeRange(1, 1)];
                    NSString *str3 = [str substringFromIndex:2];
                    if ([str1 isEqualToString:str2] && [str2 isEqualToString:str3])
                    {
                        equalStr = [[equalStr stringByAppendingString:@","] stringByAppendingString:str];
                    }
                    else
                    {
                        [tempSimArray2 addObject:str];
                    }
                }
                if (![equalStr isEqualToString:@""])
                {
                    [alertMsg appendString:[[@"非法的号码:" stringByAppendingString:[equalStr substringFromIndex:1]] stringByAppendingString:@",已被自动过滤!"]];
                }
                [simpleArray removeAllObjects];
                simpleArray = tempSimArray2;
                //以下代码的目的是textview里，只显示一次重复的号码
                if (simpleArray.count > 0)
                {
                    NSString *tvStr = @"";
                    for (int i = 0; i < simpleArray.count; ++i)
                    {
                        NSString *str = [simpleArray objectAtIndex:i];
                        tvStr = [[tvStr stringByAppendingString:@","] stringByAppendingString:str];
                    }
                    
                    //取消undo事件,防止ios7crash
                    [textView.undoManager removeAllActions];
                    textView.text = [tvStr substringFromIndex:1];
                }
                else
                {
                    //取消undo事件,防止ios7crash
                    [textView.undoManager removeAllActions];
                    textView.text = @"";
                }
            }
            //处理三码(混合)-比较特殊－两个号码不能完全一样999------------------end
            //非法号码的判断---end
            //air-0304-2-----------------单式不能有相同的两组号码---------------------------------end
            if (simpleArray.count > 0)
            {
                //设置"选好了"按钮 可点
                [self setFinishButtonEnable:YES];
                int quantity = simpleArray.count;
                //设置底部的多少元，多少注
                [self setTheNumberOfBets:quantity];
            }
            else
            {
                [self setFinishButtonEnable:NO];
            }
            
            if (alertMsg.length > 0)
            {
                [Utility showErrorWithMessage:alertMsg];
            }
        }
    }
}

#pragma mark - 清空数据
//清空所有数据
-(void)cleanSelectNumber
{
    [simpleArray removeAllObjects];
    
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
    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
    FourthMenuObject *rule =[verticalMenuItems objectAtIndex:secondMenuIndex];
    ModeObject *mode = [rule.modes objectAtIndex:[UserInfomation sharedInfomation].modeIndex];
    
    BettingInformation *bettingInformation = [[BettingInformation alloc] init];
    bettingInformation.type = rule.selectarea.type;
    bettingInformation.methodid = rule.methodid;
    bettingInformation.mode = mode.modeid;
    
    bettingInformation.codes = codes;
    bettingInformation.nums = nums;
    
    bettingInformation.omodel = [NSString stringWithFormat:@"%d",[UserInfomation sharedInfomation].prizeType];
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
- (int)numberOfBallKind
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
    NSArray *allBalls = [self getBallArrayByPlace:place];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < allBalls.count; ++i) {
        UIButton *ball = [allBalls objectAtIndex:i];
        if (ball.selected) {
            [mutableArray addObject:[NSString stringWithFormat:@"%d",ball.tag]];
        }
    }
    return mutableArray;
}

//每一类号码所选数量之积
- (int)valueOfMultiplyEach
{
    int value = 1;
    NSArray *allKeys = allBallsDictionry.allKeys;
    for (int i = 0; i < allKeys.count; ++i) {
        NSString *key = [allKeys objectAtIndex:i];
        NSArray *selectedBalls = [self getSelectedBallsByPlace:key];
        value *= selectedBalls.count;
    }
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
- (int)getNumberOfBetsWithFirst:(int)first second:(int)second
{
    int numberOfBets = 0;
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
            if (firstArray.count >= first) {
                NSSet *firstArrayCombination = [AMGCombinatorics combinationsWithoutRepetitionFromElements:firstArray taking:first];
                numberOfBets = firstArrayCombination.count;
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
- (void)setTheNumberOfBets:(int)numberOfBets
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
            for (int i = 0; i <= 9; i++) {
                for (int j = i; j <= 9; j++) {
                    int sum = i + j;
                    if (sum == number && i != j) {
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
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
    NSString *name = fouMo.name;
    
    //五星
    if ([name isEqualToString:FuShi] || [name isEqualToString:HouErZhiXuanFuShi] || [name isEqualToString:QianErZhiXuanFuShi] || [name isEqualToString:HouEr] || [name isEqualToString:QianEr]) {
        int numberOfBets = [self valueOfMultiplyEach];;
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuHe])
    {
        int numberOfBets = [self numberOfBallKind] * [self valueOfMultiplyEach];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan120])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:5 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan60])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:1 second:3];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan30])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:2 second:1];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan20]  || [name isEqualToString:ZuXuan12])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:1 second:2];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan10] || [name isEqualToString:ZuXuan5] || [name isEqualToString:ZuXuan4])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:1 second:1];
        [self setTheNumberOfBets:numberOfBets];
    }
    //四星
    else if ([name isEqualToString:ZuXuan24])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:4 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuan6] || [name isEqualToString:HouSanErMaBuDingDan] || [name isEqualToString:QianSanErMaBuDingDan] || [name isEqualToString:HouErZuXuanFuShi] || [name isEqualToString:QianErZuXuanFuShi])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:2 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    //后三码,前三码,中三码
    else if ([name isEqualToString:ZuSan])
    {
        int numberOfBets = 2 * [self getNumberOfBetsWithFirst:2 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZhiXuanHeZhi])
    {
        int numberOfBets = [self getNumberOfBetsOfZhiXuanHeZhi:3];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuLiu])
    {
        int numberOfBets = [self getNumberOfBetsWithFirst:3 second:0];
        [self setTheNumberOfBets:numberOfBets];
    }
    else if ([name isEqualToString:ZuXuanHeZhi])
    {
        int numberOfBets = [self getNumberOfBetsOfZuXuanHeZhi:3];
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
- (void)gotoShakeMyPhone
{
    [self cleanSelectNumber];
    
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
    NSString *name = fouMo.name;
    
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
        [self randomSelectEach:1];
    }
    else if ([name isEqualToString:ZuXuan60])
    {
        [self randomSelectFirst:1 second:3];
    }
    else if ([name isEqualToString:ZuXuan30])
    {
        [self randomSelectFirst:2 second:1];
    }
    else if ([name isEqualToString:ZuXuan20]||[name isEqualToString:ZuXuan12])
    {
        [self randomSelectFirst:1 second:2];
    }
    else if ([name isEqualToString:ZuXuan10]||[name isEqualToString:ZuXuan5]||[name isEqualToString:ZuXuan4])
    {
        [self randomSelectFirst:1 second:1];
    }
    else if ([name isEqualToString:ZuXuan120])
    {
        [self randomSelectEach:5];
    
    }
    else if ([name isEqualToString:ZuXuan24])
    {
        [self randomSelectEach:4];
        
    }
    else if ([name isEqualToString:ZuXuan6]||[name isEqualToString:ZuSan]||[name isEqualToString:ZuXuan]||[name isEqualToString:HouErZuXuanFuShi]||[name isEqualToString:QianErZuXuanFuShi]||[name isEqualToString:HouSanErMaBuDingDan]||[name isEqualToString:QianSanErMaBuDingDan])
    {
        [self randomSelectEach:2];
        
    }
    else if ([name isEqualToString:ZuLiu])
    {
        [self randomSelectEach:3];
        
    }
    else if ([name isEqualToString:DingWeiDan])
    {
        [self randomSelectOne];
    }

    [self calculateNumberAndPrice];
}

//随机每位选取一个
- (void)randomSelectEach:(int)count
{
    NSArray *allKeys = allBallsDictionry.allKeys;
   
    //排序
    allKeys = [self sortedArray:allKeys];
    
    for (int i = 0; i < allKeys.count; ++i) {
        
        for (int j = 0; j <count; ++j) {
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
        for (int i = 0; i < first; ++i) {
            NSArray *firstBalls = [self getUnselectedBallsByPlace:[allKeys objectAtIndex:0]];
            int randomNumber = arc4random() % firstBalls.count;
            UIButton *ball = [firstBalls objectAtIndex:randomNumber];
            ball.selected = YES;
        }
        for (int i = 0; i < second; ++i) {
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

#pragma 摇一摇
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (!isInputType) {
        NSString *fimp3 = [[NSBundle mainBundle] pathForResource:@"yyy1" ofType:@"mp3"];
        [self playaudio:fimp3];
        
        [self gotoShakeMyPhone];
    }
}

#pragma mark - 增加随机号码
- (void)addRandomNumber
{
    if ([self checkIfReachMaxRandomNumber]) {
        [Utility showErrorWithMessage:BetNumberFullErrorMessage];
        return;
    }

    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
    NSString *title = smo.title;
    
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
    NSString *name = fouMo.name;

    if (isInputType)
    {
        [self getSingleRandom];
        
        NSString *codes = [self getSingleCurrentSelectedCodes];
        if (![self.buyFinishViewController betNumberExist:codes title:title name:name]) {
            LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%d",theNumberOfBets]];
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
            LotteryInformation *lotteryInfomation = [self getLotteryInformationWithCodes:codes nums:[NSString stringWithFormat:@"%d",theNumberOfBets]];
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
    
    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
    NSString *secMenuName = smo.title;
    
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
    NSString *markString = fouMo.name;
    
    NSMutableString *randomNumber = [NSMutableString string];
    if (([secMenuName isEqualToString:WuXing] ||
         [secMenuName isEqualToString:SiXing] ||
         [secMenuName isEqualToString:HouSanMa] ||
         [secMenuName isEqualToString:QianSanMa] ||
         [secMenuName isEqualToString:ZhongSanMa] ||
         [secMenuName isEqualToString:ErMa]) &&
        ([markString isEqualToString:DanShi] ||
         ([markString isEqualToString:HunHe] || [markString isEqualToString:HunHeZuXuan]) ||
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
        
        if (([markString isEqualToString:HunHe] || [markString isEqualToString:HunHeZuXuan]) || [markString isEqualToString:HouErZuXuanDanShi] || [markString isEqualToString:QianErZuXuanDanShi]) {
            
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

- (void)updateIndexs:(NSNotification *)notification
{
    NSArray *array = notification.object;
    firstMenuIndex = [[array firstObject] intValue];
    secondMenuIndex = [[array lastObject] intValue];
    
    [self updateMenuIndexs];
}

- (void)setFirstMenuIndex:(int)firstIndex secondMenuIndex:(int)secondIndex
{
    firstMenuIndex = firstIndex;
    secondMenuIndex = secondIndex;
}

#pragma mark - 检查是否达到最大随机注数
- (BOOL)checkIfReachMaxRandomNumber
{
    NSInteger maxNumber = 0;
    
    SecondMenuObject *smo = [ruleAndMenuArray objectAtIndex:firstMenuIndex];
    NSString *title = smo.title;
    
    FourthMenuObject *fouMo =[verticalMenuItems objectAtIndex:secondMenuIndex];
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
            else if([name isEqualToString:HunHe] || [name isEqualToString:HunHeZuXuan])
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

- (void)updateMenuIndexs
{
    [self updateHorizontalMenuAtIndex:firstMenuIndex];
    [self updateNumbersAtIndex:secondMenuIndex];
}

- (void)setBuyChooseViewControllerIndex:(BuyChooseViewController *)buyChooseViewController
{
    [buyChooseViewController setFirstMenuIndex:firstMenuIndex secondMenuIndex:secondMenuIndex];
}
@end
