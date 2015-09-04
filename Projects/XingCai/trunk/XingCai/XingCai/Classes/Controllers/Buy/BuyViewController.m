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
#define BASETAG1    1024

@implementation BuyViewController
{
    NSString *timeString;
    NSString *currentJiangQi;
    
    UIButton *refreshButton;
    
    SGFocusImageFrame *imageFrame;
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
    
    [imageFrame resetFocusImageItems];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timeString = @"暂无";
    currentJiangQi = @"暂无";
    
    //登陆后刷新彩种列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLotteryList) name:NotificationNameUpdateLotteryList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime:) name:NotificationUpdateTime object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self.view addSubview:refreshButton];
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
        if (!error || (error && ![error.domain isEqualToString:AppCacheErrorLotteryListDomain])) {
            [self getLotteryList];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        refreshButton.enabled = YES;
    }];
}
#pragma mark - UI数据刷新
-(void)showKindOfLotteryInTopCell:(UITableViewCell*)topCell WithIndexRow:(NSInteger)indexPath
{
    UIImageView *bgimgView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 96)];
    [bgimgView setImage:[UIImage imageNamed:@"bk_content"]];
    [topCell addSubview:bgimgView];
    KindOfLottery *kindlottery = [kindOfLotteries objectAtIndex:indexPath-1];
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


#pragma mark - UITableView Delegate
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!kindOfLotteries || kindOfLotteries.count == 0) {
        return 1    ;
    }else
        return [kindOfLotteries count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HeadCellIdentifier = @"HeadCell";
    static NSString *CellIdentifier = @"Cell";
    
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
            imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 88)
                                                                            delegate:nil
                                                                     focusImageItems:item1, item2, item3, nil];
            [cell addSubview:imageFrame];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self showKindOfLotteryInTopCell:cell WithIndexRow:indexPath.row];
            KindOfLottery *kindOfLottery = [kindOfLotteries objectAtIndex:[indexPath row]-1];
            [self modelCellFill:cell Object:kindOfLottery rowInd:[indexPath row]];
            
            if (indexPath.row == 1) {
                daoJiShiLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 70, 200, 20)];
                daoJiShiLabel.font = [UIFont systemFontOfSize:13];
                daoJiShiLabel.textColor = [UIColor darkTextColor];
                daoJiShiLabel.backgroundColor = [UIColor clearColor];
                daoJiShiLabel.numberOfLines = 0;
                [cell addSubview:daoJiShiLabel];
                
                jiangQiLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 42, 150, 20)];
                jiangQiLabel.font = [UIFont systemFontOfSize:13];
                jiangQiLabel.textColor = [UIColor darkTextColor];
                jiangQiLabel.backgroundColor = [UIColor clearColor];
                jiangQiLabel.numberOfLines = 0;
                [cell addSubview:jiangQiLabel];
            }
            
        }
        
        daoJiShiLabel.text =[NSString stringWithFormat:@"投注截止:%@",timeString];
        jiangQiLabel.text =[NSString stringWithFormat:@"奖期:%@",currentJiangQi];
    }

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
        return 88;
    }
    else
        
        return 106;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //没有奖期跳转会cash
    if (indexPath.row == 1) {
        KindOfLottery *kindOfLottery = [kindOfLotteries objectAtIndex:indexPath.row - 1];
        NSArray *ruleAndMenuArray = [[AppCacheManager sharedManager] getMenuAndRuleWithKindOfLottery:kindOfLottery];
        if (ruleAndMenuArray.count > 0) {
            JiangQiObject *jiangQiObject = [[JiangQiManager sharedManager] getJiangQiObjectWithLotteryId:@"1"];
            if (!jiangQiObject.latestJiangQi) {
                [Utility showErrorWithMessage:@"奖期未获取成功，请稍后重试"];
                [[JiangQiManager sharedManager] updateAllJiangQi];
                return;
            }
            else if(!jiangQiObject.latestKeZhuiHaoJiangQi) {
                [Utility showErrorWithMessage:@"可追号奖期未获取成功，请稍后重试"];
                [[JiangQiManager sharedManager] updateAllJiangQi];
                return;
            }
            [self kindOfLotteryClicked:0];
        }
        else
        {
            [Utility showErrorWithMessage:[[AppCacheManager sharedManager] menuAndRuleErrorMsgWithKindOfLottery:kindOfLottery] delegate:self tag:AlertViewTypeMenuAndRuleError];
        }
    }
}
#pragma mark - 动作事件
//跳转到购彩大厅
-(void)jumpToBuyLotteryAtIndex:(NSInteger)index
{
    BuyChooseViewController *bcVC = [[BuyChooseViewController alloc] initWithNibName:@"BuyChooseViewController" bundle:nil];
    bcVC.hidesBottomBarWhenPushed = YES;
    bcVC.kindOfLottery = [kindOfLotteries objectAtIndex:index];
    [self.navigationController pushViewController:bcVC animated:YES];
}
-(void)kindOfLotteryClicked:(UIButton *)sender
{
    [self jumpToBuyLotteryAtIndex:sender.tag];
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
- (void)updateTime:(NSNotification *)notification
{
    timeString = notification.object;
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}
- (void)updateJiangQi:(NSNotification *)notification
{
    currentJiangQi = notification.object;
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    DDLogDebug(@"setTime = %f",startTime);
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertViewTypeMenuAndRuleError) {
        [self updateLotteryList];
    }
}
@end
