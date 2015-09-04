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
//    UIImageView *caiBtnimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 96)];
//    
//    [caiBtnimgView setImage:[UIImage imageNamed:@"tag_record_content_n"]];
//
//    
//    [topCell addSubview:caiBtnimgView];
    
    UIImageView *bgimgView= [[UIImageView alloc]initWithFrame:CGRectMake(10 ,14, 68.5, 68.5)];
    
    KindOfLottery *kindlottery = [kindOfLotteries objectAtIndex:indexPath-1];
    UIImage *backgroundImage;
    
    UILabel *tipslabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 50,170, 30)];
    tipslabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17.0f];
    tipslabel.textAlignment = NSTextAlignmentCenter;
    tipslabel.textColor =[UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1.0];
    [tipslabel setBackgroundColor:[UIColor clearColor]];
    
    [topCell addSubview:tipslabel];
    
    if ([kindlottery.cnname isEqualToString:@"重庆时时彩"])
    {
        backgroundImage = [UIImage imageNamed:@"icon_cq"];
    }
    if ([kindlottery.cnname isEqualToString:@"江西时时彩"])//air-2014-09-28[接口返回数据没变，只能这么判断]-1
    {
        backgroundImage = [UIImage imageNamed:@"icon_thailand"];
        tipslabel.text=@"敬请期待 即将上线....";
        topCell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if ([kindlottery.cnname isEqualToString:@"新疆时时彩"])//air-2014-09-28[接口返回数据没变，只能这么判断]-2
    {
        backgroundImage = [UIImage imageNamed:@"icon_3d"];
        tipslabel.text=@"敬请期待 即将上线....";
        topCell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    bgimgView.image=backgroundImage;

    [topCell addSubview:bgimgView];
}

-(void)modelCellFill:(UITableViewCell *)cell Object:(KindOfLottery *)object rowInd:(NSInteger)rowIndex
{
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(typeLab == nil)
    {
        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(86, 15, 90, 20)];
        typeLab.tag = BASETAG1;
        typeLab.font = [UIFont systemFontOfSize:18];
        if (rowIndex==1)
        {
             typeLab.textColor = [UIColor colorWithRed:254/255.0 green:46/255.0 blue:46/255.0 alpha:1];
        }else
        {
        
            typeLab.textColor = [UIColor colorWithRed:163/255.0 green:156/255.0 blue:156/255.0 alpha:1];
        }
        
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    //typeLab.text = object.cnname;
    //air-2014-09-28[接口返回数据没变，只能这么判断]-3-begin
    if ([object.cnname isEqualToString:@"重庆时时彩"])
    {
        typeLab.text = @"重庆时时彩";
    }
    else if([object.cnname isEqualToString:@"江西时时彩"])
    {
        typeLab.text = @"泰国300秒";
    }
    else
    {
        typeLab.text = @"福彩3D";
    }
    //air-2014-09-28[接口返回数据没变，只能这么判断]-3-end
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

            SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"ios_ad01@2x.jpg"] tag:0];
            SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"ios_ad02@2x.jpg"] tag:1];
            SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"ios_ad03@2x.jpg"] tag:2];
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
            [self showKindOfLotteryInTopCell:cell WithIndexRow:indexPath.row];
            KindOfLottery *kindOfLottery = [kindOfLotteries objectAtIndex:[indexPath row]-1];
            [self modelCellFill:cell Object:kindOfLottery rowInd:[indexPath row]];
        
            if (indexPath.row == 1) {
                
                jiangQiLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 150, 20)];
                jiangQiLabel.font = [UIFont systemFontOfSize:13];
                jiangQiLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(203/255.0) blue:(40/255.0) alpha:1.0];
                jiangQiLabel.backgroundColor = [UIColor clearColor];
                jiangQiLabel.numberOfLines = 0;
                [cell addSubview:jiangQiLabel];

                
                daoJiShiLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 60, 200, 20)];
                daoJiShiLabel.font = [UIFont systemFontOfSize:13];
                daoJiShiLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(203/255.0) blue:(40/255.0) alpha:1.0];
                daoJiShiLabel.backgroundColor = [UIColor clearColor];
                daoJiShiLabel.numberOfLines = 0;
                [cell addSubview:daoJiShiLabel];
                
            }
            
        }
        
        [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag_record_content_n"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag_record_content_h"]]];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];

        jiangQiLabel.text =[NSString stringWithFormat:@"期号:%@",currentJiangQi];
        daoJiShiLabel.text =[NSString stringWithFormat:@"投注截止:%@",timeString];
       
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
        return 98;
    }
    else
        
        return 96;
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
-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertViewTypeMenuAndRuleError) {
        [self updateLotteryList];
    }
}
@end
