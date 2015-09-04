//
//  BuyViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "BuyViewController.h"
#import "BuyChooseViewController.h"
#import "OpenLotteryObject.h"
#import "OpenLotteryDetailViewController.h"
#import "KindOfLottery.h"
#import "AppCacheManager.h"
#import "LoginViewController.h"
#import "RecordsViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "UIViewController+CustomNavigationBar.h"
#import "NSString+Extension.h"

#define BASETAG1    1024
#define FIRST_CELL_HEIGHT 130
#define SECOND_CELL_HEIGHT 78
#define LOTTER_YTYPE_CELL_HEIGHT 78

#define CURRENT_JIANG_QI_DEFAULT @"暂无"

@implementation BuyViewController
{
    NSString *timeString;
    NSString *currentJiangQi;
    
    UIButton *refreshButton;
    
    SGFocusImageFrame *imageFrame;
    UIRefreshControl *_refreshCtrl;
    
    KindOfLottery *currentChooseKindOfLottery;
}


#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getWinningNumber];
    [imageFrame resetFocusImageItems];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self performSelector:@selector(hidingLoadingView) withObject:nil afterDelay:3];
}
-(void)hidingLoadingView
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    timeString = @"暂无";
    currentJiangQi =CURRENT_JIANG_QI_DEFAULT ;
    [self setupUI];
    //登陆后刷新彩种列表
    [self addObserver];

}
-(void)dealloc{
    [self removeObserver];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupUI
{
    [self  setupNavigationBarTitle:@"购彩大厅" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO];
    _refreshCtrl=[[UIRefreshControl alloc]init];
    [_refreshCtrl addTarget:self action:@selector(getWinningNumber) forControlEvents:UIControlEventValueChanged];
    _refreshCtrl.tintColor=GUI_COLOR__viRed_Bar;
    [self.tableView addSubview:_refreshCtrl];
    
}
#pragma mark - 获取数据
- (void)getLotteryList
{
    kindOfLotteries = [[AppCacheManager sharedManager] getLotteryList];

    [self.tableView reloadData];
    
    if (kindOfLotteries.count == 0) {
        if (!refreshButton) {
            refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            [refreshButton setTitle:@"点击刷新" forState:UIControlStateNormal];
            [refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [refreshButton addTarget:self action:@selector(updateLotteryList) forControlEvents:UIControlEventTouchUpInside];
            refreshButton.center = self.view.center;
//            [self.view addSubview:refreshButton];
        }
        refreshButton.hidden = NO;
    }
    else
    {
        refreshButton.hidden = YES;
        [self tryToGetJiangqi];
    }
}
- (void)updateLotteryList
{
    refreshButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppCacheManager sharedManager] updateLotteryListWithBlock:^(NSError *error){
        //如果没有错，或者错误不是LotteryList报的（可能是玩法获取报错）
        if (!error || (error && ![error.domain isEqualToString:AppCacheManagerErrorDomain])) {
            [self getLotteryList];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        refreshButton.enabled = YES;
    }];
}
- (void)getWinningNumber{
    [_refreshCtrl beginRefreshing];
    [[AppHttpManager sharedManager] getLotteryInfomationWithBlock:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 id object = [JSON objectForKey:@"issueNumbers"];
                 if ([object isKindOfClass:[NSDictionary class]]) {
                     NSDictionary *issueNumbersDict = (NSDictionary *)object;
                     if([issueNumbersDict.allKeys containsObject:@"1"])
                     {
                         object = [issueNumbersDict objectForKey:@"1"];
                         if ([object isKindOfClass:[NSArray class]])
                         {
                             NSArray *array = (NSArray *)object;
                             if (array.count > 0) {
                                 object = [array objectAtIndex:0];
                                 if ([object isKindOfClass:[NSDictionary class]]) {
                                     NSDictionary *issueNumberDict = (NSDictionary *)object;
                                     if ([issueNumberDict.allKeys containsObject:@"code"] && [issueNumberDict.allKeys containsObject:@"issue"]) {
                                         [self updateWinningNumber:issueNumberDict[@"code"] withIssue:issueNumberDict[@"issue"]]; //modified by cage for bug #6770 2014-11-24
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
             else
             {
                 DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         [_refreshCtrl endRefreshing];
     }];

}
#pragma mark - UI数据刷新
-(void)showKindOfLotteryInTopCell:(UITableViewCell*)topCell WithIndexRow:(NSInteger)indexPath
{
    UIImageView *bgimgView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 96)];
    [bgimgView setImage:[UIImage imageNamed:@"bk_content"]];
    [topCell addSubview:bgimgView];
    KindOfLottery *kindlottery = [kindOfLotteries objectAtIndex:indexPath-1];
    NSLog(@"%@",kindlottery.cnname);
    UIButton *caiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    caiBtn.frame = CGRectMake(10 ,14, 68.5, 68.5);
    UIImage *backgroundImage;
    
    UILabel *tipslabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 33,170, 30)];
    tipslabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17.0f];
    tipslabel.textAlignment = NSTextAlignmentCenter;
    tipslabel.textColor =[UIColor lightGrayColor];
    [tipslabel setBackgroundColor:[UIColor clearColor]];
    
    [bgimgView addSubview:tipslabel];
    
    if ([kindlottery.cnname isEqualToString:@"重庆时时彩"]) {
        backgroundImage = [UIImage imageNamed:@"lottery_icon01"];
    }
    if ([kindlottery.cnname isEqualToString:@"江西时时彩"]) {
        backgroundImage = [UIImage imageNamed:@"lottery_icon04"];
        tipslabel.text=@"敬请期待 即将上线....";
    }
    if ([kindlottery.cnname isEqualToString:@"新疆时时彩"]) {
        backgroundImage = [UIImage imageNamed:@"lottery_icon03"];
        tipslabel.text=@"敬请期待 即将上线....";
    }
    [caiBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    [bgimgView addSubview:caiBtn];
}

-(void)modelCellFill:(UITableViewCell *)cell Object:(KindOfLottery *)object rowInd:(NSInteger)rowIndex
{
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(typeLab == nil)
    {
        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(86, 22, 90, 20)];
        typeLab.tag = BASETAG1;
        typeLab.font = [UIFont systemFontOfSize:18];
        typeLab.textColor = [UIColor purpleColor];
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    typeLab.text = object.cnname;
}

//modified by cage for bug #6770 2014-11-24
-(void)updateWinningNumber:(NSString *)number withIssue:(NSString*)issue{
    _firstStr=[NSString getSubStringInString:number atIndex:0 length:1];
    _secondStr=[NSString getSubStringInString:number atIndex:1 length:1];
    _thirdStr=[NSString getSubStringInString:number atIndex:2 length:1];
    _forthStr=[NSString getSubStringInString:number atIndex:3 length:1];
    _fifthStr=[NSString getSubStringInString:number atIndex:4 length:1];
    currentJiangQi = issue;
    [self.tableView reloadData];
    
}
#pragma mark - UITableView Delegate
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (!kindOfLotteries || kindOfLotteries.count == 0) {
//        return 2    ;
//    }else
//        return [kindOfLotteries count] + 2;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HeadCellIdentifier = @"HeadCell";
    static NSString *CellIdentifier = @"Cell";
    static NSString *resultCellIdentifier=@"LotteryResultCell";

    UITableViewCell *cell;
   
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:HeadCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeadCellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner01"] tag:0];
            SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner02"] tag:1];
            SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner03"] tag:2];
            imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, FIRST_CELL_HEIGHT)
                                                                            delegate:nil
                                                                     focusImageItems:item1, item2, item3, nil];
            [cell addSubview:imageFrame];
        }
    }
    else if (indexPath.row==1)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:resultCellIdentifier];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LotteryResultsCell" owner:self options:nil]lastObject];
        }
        [self setupLotteryResultCell:cell];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LotteryTypeCell" owner:self options:nil]lastObject];
        }
        [self setupLotteryTypeCell:cell indexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return FIRST_CELL_HEIGHT;
    }
    else if (indexPath.row==1)
    {
        return SECOND_CELL_HEIGHT;
    }
    else
    {
        return LOTTER_YTYPE_CELL_HEIGHT;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //没有奖期跳转会cash
    if (indexPath.row == 1){}
}
#pragma mark- setup cell
-(void)setupLotteryResultCell:(UITableViewCell *)cell
{
    UILabel *numLab1=(UILabel *)[cell.contentView viewWithTag:101];
    UILabel *numLab2=(UILabel *)[cell.contentView viewWithTag:102];
    UILabel *numLab3=(UILabel *)[cell.contentView viewWithTag:103];
    UILabel *numLab4=(UILabel *)[cell.contentView viewWithTag:104];
    UILabel *numLab5=(UILabel *)[cell.contentView viewWithTag:105];
    UILabel *lotteryDateLab=(UILabel *)[cell.contentView viewWithTag:106];
    UIButton *betBtn=(UIButton *)[cell.contentView viewWithTag:107];
    [betBtn addTarget:self action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
    
    numLab1.text=_firstStr;
    numLab2.text=_secondStr;
    numLab3.text=_thirdStr;
    numLab4.text=_forthStr;
    numLab5.text=_fifthStr;
    
    if ([currentJiangQi isEqualToString:CURRENT_JIANG_QI_DEFAULT]) {
        lotteryDateLab.text=@"重庆时时彩  暂无";
    }else{
        lotteryDateLab.text=[NSString stringWithFormat:@"重庆时时彩 第%@期",currentJiangQi];
    }

}
-(void)setupLotteryTypeCell:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath{
    //左边
    UIButton *left_Btn=(UIButton *)[cell.contentView viewWithTag:101];
    
    UIImageView *left_LotteryIV=(UIImageView *)[cell.contentView viewWithTag:102];
    UIImageView *left_StatusIV=(UIImageView *)[cell.contentView viewWithTag:103];
    UILabel *left_LotteryNameLab=(UILabel *)[cell.contentView viewWithTag:104];
    
   
    //右边
    UIButton *right_Btn=(UIButton *)[cell.contentView viewWithTag:201];
    UIImageView *right_lotteryIV=(UIImageView *)[cell.contentView viewWithTag:202];
    UIImageView *right_StatusIV=(UIImageView *)[cell.contentView viewWithTag:203];
    UILabel *right_LotteryNameLab=(UILabel *)[cell.contentView viewWithTag:204];
    right_LotteryNameLab.textColor=GUI_COLOR_TextGREYLighter;
    //减去上面两行
    switch (indexPath.row-2) {
        case 0:
            [left_Btn addTarget:self action:@selector(clickChongQingShiShiCaiBtn) forControlEvents:UIControlEventTouchUpInside];
            [left_Btn setBackgroundImage:[UIImage imageNamed:@"tab_click_bg"] forState:UIControlStateHighlighted];
            left_LotteryIV.image=[UIImage imageNamed:@"lottery_icon_shicq"];
            left_LotteryNameLab.text=@"重庆时时彩";
            left_LotteryNameLab.textColor=GUI_COLOR__TextBLACK;
            left_StatusIV.image=[UIImage imageNamed:@"tag_bet_now"];
            
            [right_Btn addTarget:self action:@selector(clickFiveFenCaiBtn) forControlEvents:UIControlEventTouchUpInside];
            right_lotteryIV.image=[UIImage imageNamed:@"lottery_icon_quick"];
            right_LotteryNameLab.text=@"河内5分彩";
            [right_Btn setBackgroundImage:[UIImage imageNamed:@"tab_click_bg"] forState:UIControlStateHighlighted];

            right_LotteryNameLab .textColor=GUI_COLOR__TextBLACK;
            right_StatusIV.image=[UIImage imageNamed:@"tag_bet_now"];
            

            break;
        case 1:
            //                [left_Btn addTarget:self action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
            left_LotteryIV.image=[UIImage imageNamed:@"lottery_icon_cq"];
            left_LotteryNameLab.text=@"重庆11选5";
            left_StatusIV.image=[UIImage imageNamed:@"tag_bet_soon"];
            left_LotteryNameLab.textColor=GUI_COLOR_TextGREYLighter;
            
            //                [right_Btn addTarget:self action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
            right_lotteryIV.image=[UIImage imageNamed:@"lottery_icon_gd"];
            right_LotteryNameLab.text=@"广东11选5";
            right_StatusIV.image=[UIImage imageNamed:@"tag_bet_soon"];
            break;
        case 2:
            //                [left_Btn addTarget:self action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
            left_LotteryIV.image=[UIImage imageNamed:@"lottery_icon_jx"];
            left_LotteryNameLab.text=@"江西时时彩";
            left_StatusIV.image=[UIImage imageNamed:@"tag_bet_soon"];
             left_LotteryNameLab.textColor=GUI_COLOR_TextGREYLighter;
            

            //                [right_Btn addTarget:self action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
            right_lotteryIV.image=[UIImage imageNamed:@"lottery_icon_sd"];
            right_LotteryNameLab.text=@"山东11选5";
            right_StatusIV.image=[UIImage imageNamed:@"tag_bet_soon"];
            break;
            
        default:
            break;
    }
}
#pragma mark- cutom method

-(void)jumpToBuyChooseViewAtIndex:(NSInteger)index
{
    if (kindOfLotteries.count > index) {
        KindOfLottery *kindOfLottery = [kindOfLotteries objectAtIndex:index];
        NSArray *ruleAndMenuArray = [[AppCacheManager sharedManager] getMenuAndRuleWithKindOfLottery:kindOfLottery];
        if (ruleAndMenuArray.count > 0)
        {
            if(index == 0 || index == 1)
            {
                NSString *lotteryId;
                if(index == 0)
                {
                    lotteryId = @"1";
                }
                else if(index == 1)
                {
                    lotteryId = @"14";
                }
                
                if (!kindOfLottery.latestJiangQi || !kindOfLottery.latestKeZhuiHaoJiangQi)
                {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //刷新某个奖期
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jiangQiUpdateFinished:) name:NotificationJiangQiUpdateFinished object:nil];
                    [[JiangQiManager sharedManager] updateJiangQiWithKindOfLottery:kindOfLottery];
                    currentChooseKindOfLottery = kindOfLottery;
                }
                else
                {
                    [self showBuyChooseViewAtIndex:index];
                }
            }
            else
            {
                [Utility showErrorWithMessage:@"未知彩种"];
            }
        }
        else
        {
            [Utility showErrorWithMessage:[[AppCacheManager sharedManager] menuAndRuleErrorMsgWithKindOfLottery:kindOfLottery] delegate:self tag:AlertViewTypeMenuAndRuleError];
        }
    }
    else
    {
        [Utility showErrorWithMessage:@"彩种数据获取失败，请稍后再试"];
        [self updateLotteryList];
    }
}

- (void)jiangQiUpdateFinished:(NSNotification *)notification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationJiangQiUpdateFinished object:nil];
    
    id object = notification.object;
    if ([object isKindOfClass:[KindOfLottery class]]) {
        KindOfLottery *kindOfLottery = (KindOfLottery *)object;
        NSArray *lotteryList = [[AppCacheManager sharedManager] getLotteryList];
        
        if ([kindOfLottery.cnname isEqualToString:currentChooseKindOfLottery.cnname]) {
            [self showBuyChooseViewAtIndex:[lotteryList indexOfObject:kindOfLottery]];
        }
    }
    else if ([object isKindOfClass:[NSError class]]) {
        NSError *error = (NSError *)object;
        [Utility showErrorWithMessage:error.localizedFailureReason];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLotteryList) name:NotificationNameUpdateLotteryList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationNameUpdateLotteryList object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationUpdateJiangQi object:nil];
}

#pragma mark - 动作事件
-(void)clickBuyBtn
{
    [self jumpToBuyChooseViewAtIndex:0];
}
-(void)clickChongQingShiShiCaiBtn
{
    [self jumpToBuyChooseViewAtIndex:0];
}
-(void)clickFiveFenCaiBtn
{
    [self jumpToBuyChooseViewAtIndex:1];
}

//跳转到购彩大厅
-(void)showBuyChooseViewAtIndex:(NSInteger)index
{
    BuyChooseViewController *bcVC = [[BuyChooseViewController alloc] initWithNibName:@"BuyChooseViewController" bundle:nil];
    bcVC.hidesBottomBarWhenPushed = YES;
    bcVC.kindOfLottery = [kindOfLotteries objectAtIndex:index];
    [self.navigationController pushViewController:bcVC animated:YES];
}

#pragma mark - 奖期
//获取奖期
- (void)tryToGetJiangqi
{
    [[JiangQiManager sharedManager] updateAllJiangQi];
}

//- (void)error:(NSError *)error Json:(id)JSON
//{
//    if ([JSON containsObject:@"msg"]) {
//        if (error.code == AppServerErrorIssueEmpty1 || error.code == AppServerErrorIssueEmpty2)
//        {
//            [Utility showErrorWithMessage:[JSON objectForKey:@"msg"] delegate:self tag:AlertViewTypeErrorIssueEmpty];
//        }
//        else if (error.code == AppServerErrorIssueNotEnough)
//        {
//            [Utility showErrorWithMessage:[JSON objectForKey:@"msg"] delegate:self tag:AlertViewTypeErrorIssueNotEnough];
//        }
//    }
//}
//- (void)updateTime:(NSNotification *)notification
//{
//    timeString = notification.object;
//    NSLog(@"%@",timeString);
//    [self.tableView reloadData];
//    [self.tableView setNeedsDisplay];
//}
- (void)updateJiangQi:(NSNotification *)notification
{
    [self getWinningNumber];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertViewTypeMenuAndRuleError) {
        [self updateLotteryList];
    }
}
@end
