//
//  BetRecordsViewController.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-23.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetRecordsViewController.h"
#import "BetRecordsObject.h"
#import "BetRecordsCell.h"
#import "BetRecordDetailViewController.h"
#import "MJRefresh.h"

static NSString *CellIdentifier = @"BetRecordsCell";

@interface BetRecordsViewController()
{
    NSArray *dataList;
    NSString *lastId;
}
@end

@implementation BetRecordsViewController
@synthesize tView;

@synthesize lotteryTypeView;
@synthesize lotteryLab;
@synthesize lp;

@synthesize startLab;
@synthesize endLab;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}
- (void)viewDidAppear:(BOOL)animated
{
    [tView headerBeginRefreshing];
    [self requestList_isRefresh:lotteryTypeStr beginDate:startLab.text endDate:endLab.text isRef:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"投注记录";
    
    lotteryTypeView.hidden = YES;
    
    //设置默认全部彩种
    lotteryTypeStr = @"0";
    lotteryText = @"全部";
    lotteryArray = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    subLotteryArr = [[NSMutableArray alloc] initWithObjects:@"重庆", @"日本", nil];
    [lotteryArray addObjectsFromArray:subLotteryArr];
    [self.lp setDates:lotteryArray];
    [self.lp reloadAllComponents];
    lotteryLab.text = [lotteryArray objectAtIndex:0];
    
    //设置默认开始时间和结束时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today = [formatter stringFromDate:date];
    startLab.text = today;
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    timeInterval += 24 * 60 * 60;
    NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *endDate = [formatter stringFromDate:tomorrowDate];
    endLab.text = endDate;
    
    _starDatePickerView=[[TDDatePickerController alloc]init];
    _starDatePickerView.delegate=self;
    
    _endDatePickerView=[[TDDatePickerController alloc]init];
    _endDatePickerView.delegate=self;
    
    [tView registerNib:[UINib nibWithNibName:@"BetRecordsCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [tView addHeaderWithTarget:self action:@selector(headerRefreshing)];
}

- (void)headerRefreshing
{
    [self requestList_isRefresh:lotteryTypeStr beginDate:startLab.text endDate:endLab.text isRef:YES];
}
- (void)footerRefreshing
{
    [self requestList_isRefresh:lotteryTypeStr beginDate:startLab.text endDate:endLab.text isRef:NO];
}
- (void)updateTableViewFooter
{
    tView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    int totalHeight = 0;
    for (int i = 0; i < dataList.count; ++i)
    {
        totalHeight += [self tableView:tView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    int maxHeight = IS_IPHONE5 ? 504 : 416;
    
    if (totalHeight > maxHeight)
    {
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        [tView addFooterWithTarget:self action:@selector(footerRefreshing)];
    }
    else
    {
        [tView removeFooter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//不显示左箭头
- (void)setLeftBarButton{}

//选择彩种-begin
- (IBAction)lotteryTypeClk:(id)sender
{
    lotteryTypeView.hidden = NO;
}
- (void)lotteryPicker:(LotteryPicker *)picker didSelectDateWithName:(NSString *)name
{
    lotteryText = name;
}
-(IBAction)cancelClick:(id)sender
{
    lotteryTypeView.hidden = YES;
}
-(IBAction)okClick:(id)sender
{
    lotteryTypeView.hidden = YES;
    lotteryLab.text = lotteryText;
}
//选择彩种-end

//日期控件相关函数-begin
- (IBAction)beginDateClk:(id)sender
{
    [self presentSemiModalViewController:_starDatePickerView];
}
- (IBAction)endDateClk:(id)sender
{
    [self presentSemiModalViewController:_endDatePickerView];
}

-(void)datePickerSetDate:(TDDatePickerController*)viewController
{
    [self dismissSemiModalViewController:viewController];
    
    _selectedDate = viewController.datePicker.date;
    [UIView animateWithDuration:.6 animations:^{
        
    }completion:^(BOOL finished)
    {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyy-MM-dd"];
        if (viewController==_starDatePickerView)
        {
            startLab.text = [fmt stringFromDate:_selectedDate];
        }
        else
        {
            endLab.text = [fmt stringFromDate:_selectedDate];
        }
    }];
}

-(void)datePickerClearDate:(TDDatePickerController*)viewController
{
    [self dismissSemiModalViewController:viewController];
    _selectedDate = nil;
}

-(void)datePickerCancel:(TDDatePickerController*)viewController
{
    [self dismissSemiModalViewController:viewController];
}
//日期控件相关函数-end

- (IBAction)searchClk:(id)sender
{
    if ([lotteryLab.text isEqualToString:@"重庆"])
    {
        lotteryTypeStr = @"1";
    }
    else if ([lotteryLab.text isEqualToString:@"日本"])
    {
        lotteryTypeStr = @"15";
    }
    else
    {
        lotteryTypeStr = @"0";
    }
    [tView headerBeginRefreshing];
    [self requestList_isRefresh:lotteryTypeStr beginDate:startLab.text endDate:endLab.text isRef:YES];
}

- (void)requestList_isRefresh:(NSString *)lyTypeStr beginDate:(NSString *)sDate endDate:(NSString *)eDate isRef:(BOOL)isRefresh
{
    if (isRefresh)
    {
        lastId = @"0";
    }
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient sharedClient] betRecordList_with_lotteryid:lyTypeStr startTime:[sDate stringByAppendingString:@" 02:00:00"] endTime:[eDate stringByAppendingString:@" 02:00:00"] maxid:lastId count:@"10" block:^(id JSON, NSError *error)
     {
         //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSMutableArray *betRecordsArr = [NSMutableArray array];
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 [betRecordsArr removeAllObjects];
                 
                 NSArray *itemArray = [JSON objectForKey:@"aProject"];
                 
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         
                         BetRecordsObject *betRecordObj = [[BetRecordsObject alloc] initWithAttribute:oneObjectDict];
                         [betRecordsArr addObject:betRecordObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 
                 if (isRefresh)
                 {
                     dataList = betRecordsArr;
                 }
                 else
                 {
                     dataList = [dataList arrayByAddingObjectsFromArray:betRecordsArr];
                 }
                 if (betRecordsArr.count > 0)
                 {
                     BetRecordsObject *betRecordObj = [betRecordsArr lastObject];
                     lastId = betRecordObj.projectid;
                 }
                 
                 [tView reloadData];
                 [self updateTableViewFooter];
             }
             else
             {
                 DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
         // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
         [tView headerEndRefreshing];
         
         // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
         [tView footerEndRefreshing];
     }];
}

//tableView-begin
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerNib:[UINib nibWithNibName:@"BetRecordsCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    BetRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (dataList.count>0)
    {
        BetRecordsObject *betRecordsObj = [dataList objectAtIndex:indexPath.row];
        [cell updateBetRecordsObject:betRecordsObj];
    }
    
    return cell;
}

//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataList.count>0 && [dataList isKindOfClass:[NSArray class]])
    {
        BetRecordsObject *betRecordsObj = [dataList objectAtIndex:indexPath.row];
        BetRecordDetailViewController *tmp = [[BetRecordDetailViewController alloc] init];
        tmp.projectID = [betRecordsObj projectidcode];
        tmp.issueStr = [betRecordsObj issue];
        [self.navigationController pushViewController:tmp animated:YES];
    }
}
//tableView-end

@end
