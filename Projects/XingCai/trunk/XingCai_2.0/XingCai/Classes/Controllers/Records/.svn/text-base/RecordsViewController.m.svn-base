//
//  RecordsViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "RecordsViewController.h"
//#import "OpenLotteryDetailViewController.h"
#import "OpenLotteryObject.h"
#import "LotteryDetailsObject.h"
#import "JiangQiManager.h"
#import "UIViewController+CustomNavigationBar.h"
#import "TableViewRecordHeadCell.h"
#import "AwardResultHistoryCell_Left.h"
#import "awardResultHistoryCell_right.h"
#import "NSString+Extension.h"

#define BASETAG1    1024
#define HEAD_SELECT_HEIGHT 56
#define HEAD_CELL_HEIGHT 122
#define CELL_HEIGHT 47


static NSString *rightCellId = @"rightCell";
static NSString *leftCellId=@"leftCell";
@interface RecordsViewController ()
{
    BOOL viewDidAppear;
    UIRefreshControl * _refreshCtrl;
    
    NSString *caizhong;
}
@end

@implementation RecordsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    viewDidAppear = YES;
    [self loadData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    viewDidAppear = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    caizhong = @"1";
    
    [tView registerNib:[UINib nibWithNibName:@"HeadSelectCell" bundle:nil] forCellReuseIdentifier:@"headSelctCellIndentifier"];
    [tView registerNib:[UINib nibWithNibName:@"TableViewRecordHeadCell" bundle:nil] forCellReuseIdentifier:@"TableViewRecordHeadCellIndentifier"];
    [tView registerNib:[UINib nibWithNibName:@"AwardResultHistoryCell_Left" bundle:nil] forCellReuseIdentifier:leftCellId];
    [tView registerNib:[UINib nibWithNibName:@"awardResultHistoryCell_right" bundle:nil] forCellReuseIdentifier:rightCellId];
    
    
    [self setupNavigationBarTitle:@"开奖信息" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
    
    _refreshCtrl=[[UIRefreshControl alloc]init];
    [_refreshCtrl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    _refreshCtrl.tintColor=GUI_COLOR__viRed_Bar;
    [tView addSubview:_refreshCtrl];
}

- (void)viewDidLayoutSubviews
{
//    NSLog(@"frame:%@",NSStringFromCGRect(tView.frame));
//    if (SystemVersion >= 7.0) {
//        CGRect frame = tView.frame;
//        frame.size.height -= 34;
//        tView.frame = frame;
//    }
}
- (void)loadData
{
    [_refreshCtrl beginRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getLotteryInfomationWithBlock:^(id JSON, NSError *error)
    {
        if (!error)
        {
            if ([JSON isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Infomation---JSON-==%@\n",JSON);
                
                NSDictionary *issueNumbersDict = [JSON objectForKey:@"issueNumbers"];
                
                //1:重庆时时彩
                NSArray *cqArray = [issueNumbersDict objectForKey:caizhong];
                if (cqArray.count > 0) {
                    id oneObject = [cqArray objectAtIndex:0];
                    if ([oneObject isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *oneObjectDict = (NSDictionary *)oneObject;
                        OpenLotteryObject *openLotteryObject = [[OpenLotteryObject alloc] initWithAttribute:oneObjectDict];
                        
                        if ([caizhong isEqualToString:@"1"]) {
                            [openLotteryObject setType:@"重庆时时彩"];
                        }else if ([caizhong isEqualToString:@"14"]){
                            [openLotteryObject setType:@"河内Quick5"];
                        }
                        
//                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        NSString *issueNumner = openLotteryObject.issue;
                        
                        [[AppHttpManager sharedManager] getLotteryInfomationListWithLotteryID:caizhong issueNumber:issueNumner Block:^(id JSON, NSError *error)
                         {
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             if (!error)
                             {
                                 if ([JSON isKindOfClass:[NSDictionary class]])
                                 {
                                     NSLog(@"JSON-==%@\n",JSON);
                                     
                                     
                                     NSArray *itemArray = [JSON objectForKey:@"issueList"];
                                     if (!openLotteriesDetails) {
                                         openLotteriesDetails = [[NSMutableArray alloc] init];
                                     }
                                     else
                                     {
                                         [openLotteriesDetails removeAllObjects];
                                     }
                                     
                                     for (int i = 0; i < itemArray.count; ++i)
                                     {
                                         id oneObject = [itemArray objectAtIndex:i];
                                         if ([oneObject isKindOfClass:[NSDictionary class]])
                                         {
                                             NSDictionary *oneObjectDict = (NSDictionary *)oneObject;
                                             LotteryDetailsObject *ldo = [[LotteryDetailsObject alloc] initWithAttribute:oneObjectDict];
                                             [openLotteriesDetails addObject:ldo];
                                         }
                                         else
                                         {
                                             DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                                         }
                                     }
                                     [tView reloadData];
                                 }
                                 else
                                 {
                                     DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                                 }
                             }
                             else
                             {
                                 DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                             }
                         }];
                    }
                    else
                    {
                        DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                    }
                }
                else
                {
                    [Utility showErrorWithMessage:@"找不到开奖信息"];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    [openLotteriesDetails removeAllObjects];
                    [tView reloadData];
                }
            }
            else
            {
                DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        }
         [_refreshCtrl endRefreshing];
    }];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HeadSelectCellButtonEchoProtocol 响应cell上面的按钮点击事件
-(void)HeadSelectCellButtonPressedWithIndex:(NSInteger)index{
    NSLog(@"HeadSelectCellButton:%li has been pressed.",(long)index);
    
    if (index == 0) {
        caizhong = @"1"; //重庆时时彩的彩种ID
    }else if (index == 1){
        caizhong = @"14"; //五分彩
    }
    
    [self loadData];
}

#pragma mark- setup cell method
-(void)setupHeadCell:(TableViewRecordHeadCell *)cell Object:(LotteryDetailsObject *)object rowInd:(NSInteger)rowIndex
{
    if ([caizhong isEqualToString:@"1"]) {
        cell.lotteryType.text = @"重庆时时彩";
    }else if ([caizhong isEqualToString:@"14"]){
        cell.lotteryType.text = @"河内5分彩";
    }
    
    cell.awardDate.text=[object issue];
    cell.date.text=[NSString getDateByString:[object issue]];
    cell.firstNum.text=[NSString getSubStringInString:object.code atIndex:0 length:1];
    cell.secondNum.text=[NSString getSubStringInString:object.code atIndex:1 length:1];
    cell.thirdNum.text=[NSString getSubStringInString:object.code atIndex:2 length:1];
    cell.forthNum.text=[NSString getSubStringInString:object.code atIndex:3 length:1];
    cell.fifthNum.text=[NSString getSubStringInString:object.code atIndex:4 length:1];
    //号码1及背景
}
-(void)setupResultHistoryLeftCell:(AwardResultHistoryCell_Left *)cell Object:(LotteryDetailsObject *)object rowInd:(NSInteger)rowIndex
{
    cell.awardDate.text=[object issue];
    cell.date.text=[NSString getDateByString:[object issue]];
    cell.firstNum.text=[NSString getSubStringInString:object.code atIndex:0 length:1];
    cell.secondNum.text=[NSString getSubStringInString:object.code atIndex:1 length:1];
    cell.thirdNum.text=[NSString getSubStringInString:object.code atIndex:2 length:1];
    cell.forthNum.text=[NSString getSubStringInString:object.code atIndex:3 length:1];
    cell.fifthNum.text=[NSString getSubStringInString:object.code atIndex:4 length:1];
}
-(void)setupResultHistoryRightCell:(awardResultHistoryCell_right *)cell Object:(LotteryDetailsObject *)object rowInd:(NSInteger)rowIndex
{
    cell.awardDate.text=[object issue];
    cell.date.text=[NSString getDateByString:[object issue]];
    cell.firstNum.text=[NSString getSubStringInString:object.code atIndex:0 length:1];
    cell.secondNum.text=[NSString getSubStringInString:object.code atIndex:1 length:1];
    cell.thirdNum.text=[NSString getSubStringInString:object.code atIndex:2 length:1];
    cell.forthNum.text=[NSString getSubStringInString:object.code atIndex:3 length:1];
    cell.fifthNum.text=[NSString getSubStringInString:object.code atIndex:4 length:1];
}
#pragma mark-
//tableView-begin
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [openLotteriesDetails count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LotteryDetailsObject *lotteryDetailsObject = nil;
    if (indexPath.row > 0) {
        lotteryDetailsObject = [openLotteriesDetails objectAtIndex:indexPath.row-1];
    }
    
    if (indexPath.row == 0) {
        HeadSelectCell *selectCell = [tableView dequeueReusableCellWithIdentifier:@"headSelctCellIndentifier"];
        selectCell.delegate = self;
        return selectCell;
    }
    else if (indexPath.row == 1)
    {
       TableViewRecordHeadCell *headCell= [tableView dequeueReusableCellWithIdentifier:@"TableViewRecordHeadCellIndentifier"];
        [self setupHeadCell:headCell Object:lotteryDetailsObject rowInd:indexPath.row];
        return headCell;
    }
    else
    {
        if (indexPath.row%2==0) {
            AwardResultHistoryCell_Left *leftCell=[tableView  dequeueReusableCellWithIdentifier:leftCellId];
            [self setupResultHistoryLeftCell:leftCell Object:lotteryDetailsObject rowInd:indexPath.row];
            return leftCell;
        }else{
            awardResultHistoryCell_right *rightCell=[tableView  dequeueReusableCellWithIdentifier:rightCellId];
            [self setupResultHistoryRightCell:rightCell Object:lotteryDetailsObject rowInd:indexPath.row];
            return rightCell;
        }
    }
}

//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return HEAD_SELECT_HEIGHT;
    }
    else if (indexPath.row == 1)
    {
        return HEAD_CELL_HEIGHT;
    }
    else
    {
        return CELL_HEIGHT;
    }
}
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *tmp = [[OpenLotteryDetailViewController alloc] init];
//    tmp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:tmp animated:YES];
}
//tableView-end

- (void)updateJiangQi:(NSNotification *)notification
{
    if (viewDidAppear) {
        [self loadData];
    }
}
@end
