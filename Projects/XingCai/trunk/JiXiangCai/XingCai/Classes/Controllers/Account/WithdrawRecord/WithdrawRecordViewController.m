//
//  WithdrawRecordViewController.m
//  HengCai
//
//  Created by jay on 14-8-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "WithdrawRecordViewController.h"
#import "WithdrawRecordCell.h"
#import "MJRefresh.h"
#import "WithdrawRecordObject.h"
#import "PageInfoObject.h"

#define WithdrawRecord_nextPage_start   @"2"
#define WithdrawRecord_totalPage_start   @"1"
#define kTagCellBackView 5000

//#define VerticalScrollViewDisabled @"YES"

static NSString *CellIdentifier = @"WithdrawRecordCell";

@interface WithdrawRecordViewController ()
{
    IBOutletCollection(UIButton) NSArray *topBarButtons;
    NSArray *tableViews;
    NSMutableArray *dataSources;
    NSInteger currentGroup;
    NSMutableArray *nextPages; //下一页页号
    NSMutableArray *totalPages; //总共页数
    NSString *startDateString;
    NSString *endDateString;
}
@end

@implementation WithdrawRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDatas];
    [self adjustView];
    [self addTableViews];
    
    [self selectAtGroup:0];
}

- (void)initDatas
{
    dataSources = [NSMutableArray array];
    for (unsigned i = 0; i < 3; ++i) {
        [dataSources addObject:[NSMutableArray array]];
    }
    
    nextPages = [NSMutableArray array];
    for (unsigned i = 0; i < 3; ++i) {
        [nextPages addObject:WithdrawRecord_nextPage_start];
    }
    
    totalPages = [NSMutableArray array];
    for (unsigned i = 0; i < 3; ++i) {
        [totalPages addObject:WithdrawRecord_totalPage_start];
    }
}
- (void)addTableViews
{
    NSMutableArray *tbViews = [NSMutableArray array];
    CGRect tableFrame = self.scrollView.frame;
    for (unsigned i = 0; i < 3; ++i) {
        tableFrame.origin = CGPointMake(i * tableFrame.size.width, 0);
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = i;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView registerNib:[UINib nibWithNibName:@"WithdrawRecordCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        
        NSString *selectorStr = [NSString stringWithFormat:@"headerRefreshing%d",i];
        // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
        [tableView addHeaderWithTarget:self action:NSSelectorFromString(selectorStr)];
        
        [self.scrollView addSubview:tableView];
        [tbViews addObject:tableView];
    }
    
    tableViews = tbViews;
    
    CGSize size = self.scrollView.frame.size;
    size.width = size.width * 3;
    self.scrollView.contentSize = size;
    self.scrollView.scrollsToTop = NO;
    
#ifdef VerticalScrollViewDisabled
    self.scrollView.scrollEnabled = NO;
#endif
}

- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0) {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
    
    frame = self.scrollView.frame;
    frame.size.height = IS_IPHONE5 ? 411 + 49 : 323 + 49;
    self.scrollView.frame = frame;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)topBarAction:(UIButton *)sender {
    [self selectAtGroup:sender.tag];
}

- (void)selectAtGroup:(NSInteger)group
{
    for (UIButton *button in topBarButtons)
    {
        button.selected = button.tag == group ? YES : NO;
    }
    CGRect frame = CGRectMake(320 * group, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    BOOL animated = YES;
#ifdef VerticalScrollViewDisabled
    animated = NO;
#endif
    [self.scrollView scrollRectToVisible:frame animated:animated];
    
    if (group < dataSources.count) {
        NSArray *dataSource = [dataSources objectAtIndex:group];
        if (dataSource.count == 0) {
            [self refreshData_type:group];
        }
    }
    
    for (UITableView *tableView in tableViews) {
        if (tableView.tag == group) {
            tableView.scrollsToTop = YES;
        }
        else
        {
            tableView.scrollsToTop = NO;
        }
    }
}

#pragma mark - view update
- (void)updateTableViewFrame:(UITableView *)tableView dataSource:(NSArray *)dataList
{
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGRect frame = tableView.frame;
    int totalHeight = 0;
    for (int i = 0; i < dataList.count; ++i) {
        totalHeight += [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    int maxHeight = IS_IPHONE5 ? 411 + 49: 323 + 49;
    
    if (totalHeight > maxHeight) {
        NSString *selectorStr = [NSString stringWithFormat:@"footerRefreshing%d",(int)tableView.tag];
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        [tableView addFooterWithTarget:self action:NSSelectorFromString(selectorStr)];
    }
    else
    {
        [tableView removeFooter];
    }
    
    frame.size.height = maxHeight;
    tableView.frame = frame;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == -1)
    {
        currentGroup = scrollView.contentOffset.x / 320;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == -1)
    {
        [self selectAtGroup:currentGroup];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // This will create a "invisible" footer
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataSource = [dataSources objectAtIndex:tableView.tag];
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *dataSource = [self dataSourceWithType:tableView.tag];
    WithdrawRecordObject *withdrawRecordObject = [dataSource objectAtIndex:indexPath.row];
    
    cell.bgImageView.image = indexPath.row % 2 == 1 ? [UIImage imageNamed:@"cell_bg_gary"] : [UIImage imageNamed:@"cell_bg_dark"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateWithWithdrawRecordObject:withdrawRecordObject];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}

#pragma mark - 数据处理
//nextPage
- (void)setNextPage:(NSString *)page type:(NSInteger)type
{
    if (type >= nextPages.count) {
        NSLog(@"type 超出范围");
        return;
    }
    [nextPages replaceObjectAtIndex:type withObject:page];
}
- (NSString *)nextPageWithType:(NSInteger)type
{
    if (type >= nextPages.count) {
        NSLog(@"type 超出范围");
        return WithdrawRecord_nextPage_start;
    }
    return [nextPages objectAtIndex:type];
}
//totalPage
- (void)setTotalPage:(NSString *)page type:(NSInteger)type
{
    if (type >= totalPages.count) {
        NSLog(@"type 超出范围");
        return;
    }
    [totalPages replaceObjectAtIndex:type withObject:page];
}
- (NSString *)totalPageWithType:(NSInteger)type
{
    if (type >= totalPages.count) {
        NSLog(@"type 超出范围");
        return WithdrawRecord_totalPage_start;
    }
    return [totalPages objectAtIndex:type];
}
//dataSource
- (void)setDataSource:(NSMutableArray *)dataSource type:(NSInteger)type
{
    if (type >= dataSources.count) {
        NSLog(@"type 超出范围");
        return;
    }
    [dataSources replaceObjectAtIndex:type withObject:dataSource];
}
- (NSMutableArray *)dataSourceWithType:(NSInteger)type
{
    if (type >= dataSources.count) {
        NSLog(@"type 超出范围");
        return nil;
    }
    NSMutableArray *dataSource = [dataSources objectAtIndex:type];
    return dataSource;
}

- (void)refreshData_type:(NSInteger)type
{
    UITableView *tableView = [tableViews objectAtIndex:type];
    [tableView headerBeginRefreshing];
}

#pragma mark 开始进入刷新状态
//虽然冗余，但目前没有更好的办法（只能怪别人的类库回调写的不好）
- (void)headerRefreshing0
{
    [self requestData_isRefresh:YES type:0];
}

- (void)footerRefreshing0
{
    [self requestData_isRefresh:NO type:0];
}
- (void)headerRefreshing1
{
    [self requestData_isRefresh:YES type:1];
}

- (void)footerRefreshing1
{
    [self requestData_isRefresh:NO type:1];
}
- (void)headerRefreshing2
{
    [self requestData_isRefresh:YES type:2];
}

- (void)footerRefreshing2
{
    [self requestData_isRefresh:NO type:2];
}

//更新日期参数
- (void)updateDateParameterWithType:(NSInteger)type
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTimeInterval = [currentDate timeIntervalSince1970];
    NSDate *startDate;
    if (type == 0)//一天内
    {
        startDate = currentDate;
        
        NSTimeInterval timeIntervalDay = currentTimeInterval;
        timeIntervalDay += 24 * 60 * 60;
        currentDate = [NSDate dateWithTimeIntervalSince1970:timeIntervalDay];
    }
    else if (type == 1)//一周内
    {
        NSTimeInterval timeInterval = currentTimeInterval;
        timeInterval -= 6 * 24 * 60 * 60;
        startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSTimeInterval timeIntervalWeek = currentTimeInterval;
        timeIntervalWeek += 24 * 60 * 60;
        currentDate = [NSDate dateWithTimeIntervalSince1970:timeIntervalWeek];
    }
    else if (type == 2)//一月内
    {
        NSTimeInterval timeInterval = currentTimeInterval;
        timeInterval -= 29 * 24 * 60 * 60;
        startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSTimeInterval timeIntervalMonth = currentTimeInterval;
        timeIntervalMonth += 24 * 60 * 60;
        currentDate = [NSDate dateWithTimeIntervalSince1970:timeIntervalMonth];
    }
    
    if (startDate)
    {
        startDateString = [[formatter stringFromDate:startDate] stringByAppendingString:@" 00:00:00"];
        endDateString = [[formatter stringFromDate:currentDate] stringByAppendingString:@" 23:59:59"];
    }
}
#pragma mark - 数据请求
- (void)requestData_isRefresh:(BOOL)isRefresh type:(NSInteger)type
{
    UITableView *tableView = [tableViews objectAtIndex:type];
    
    NSString *nextPage;
    
    if (isRefresh)
    {
        [self setNextPage:WithdrawRecord_nextPage_start type:type];
        nextPage = @"1";
    }
    else
    {
        nextPage = [self nextPageWithType:type];
        NSString *totalPage = [self totalPageWithType:type];
        
        if ([nextPage intValue] > [totalPage intValue] && !isRefresh) {
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [tableView footerEndRefreshing];
            return;
        }
    }
    
    [self updateDateParameterWithType:type];
    
    [[AppHttpManager sharedManager] chongTiChaXunWithStartTime:startDateString endTime:endDateString Page:nextPage Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if (!isRefresh)
             {
                 int currentPage = [nextPage intValue];
                 int nextPage = ++currentPage;
                 NSString *nextPageString = [@(nextPage) stringValue];
                 [self setNextPage:nextPageString type:type];
             }
             else
             {
                 [self setNextPage:@"2" type:type];
             }
             PageInfoObject *pageInfoObject = [[PageInfoObject alloc] initWithDictionary:[JSON objectForKey:@"pageinfo"]];
             [self setTotalPage:pageInfoObject.TotalPages type:type];
             
             NSMutableArray *dataSource = [self dataSourceWithType:type];
             if (!dataSource)
             {
                 dataSource = [NSMutableArray array];
             }
             else
             {
                 if (isRefresh)
                 {
                     [dataSource removeAllObjects];
                 }
             }
             
             /*
             PageInfoObject *pageInfoObject = [[PageInfoObject alloc] initWithDictionary:[JSON objectForKey:@"pageinfo"]];
             int currentPage = [pageInfoObject.CurrentPage intValue];
             int totalPages = [pageInfoObject.TotalPages intValue];
             */
             
             id listData = [JSON objectForKey:@"orders"];
             if([listData isKindOfClass:[NSArray class]] /*&& currentPage == [nextPage intValue]返回的数据和当前的页码匹配*/)
             {
                 NSArray *dataArray = (NSArray *)listData;
                 for (NSDictionary *dictionary in dataArray)
                 {
                     WithdrawRecordObject *withdrawRecordObject = [[WithdrawRecordObject alloc] initWithDictionary:dictionary];
                     [dataSource addObject:withdrawRecordObject];
                 }
             }

             /*
             if (currentPage < totalPages)
             {
                 int nextPage = ++currentPage;
                 NSString *nextPageString = [@(nextPage) stringValue];
                 [self setNextPage:nextPageString type:type];
             }
             */
             
             [self setDataSource:dataSource type:type];
             
             [tableView reloadData];
             [self updateTableViewFrame:tableView dataSource:dataSource];
         }
         else
         {
             DLog(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
         
         // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
         [tableView headerEndRefreshing];
         
         // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
         [tableView footerEndRefreshing];
     }];
}

@end
