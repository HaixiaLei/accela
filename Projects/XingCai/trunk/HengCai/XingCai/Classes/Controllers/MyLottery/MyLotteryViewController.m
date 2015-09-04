//
//  MyLotteryViewController.m
//  XingCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "MyLotteryViewController.h"
#import "MyLotteryCell.h"
#import "MJRefresh.h"
#import "MyLotteryObject.h"
#import "BetDetailViewController.h"
#import "ZHSearchViewController.h"

#define MyLottery_lastId_start   @"0"
#define MyLottery_numberOfPage   20

#define KeyLastUpdateTime     @"KeyLastUpdateTime"
#define AutoUpdateTime        (30 * 60)

//#define VerticalScrollViewDisabled @"YES" 

static NSString *CellIdentifier = @"MyLotteryCell";

@interface MyLotteryViewController ()
{
    IBOutletCollection(UIButton) NSArray *topBarButtons;
    NSArray *tableViews;
    NSMutableArray *dataSources;
    NSInteger currentGroup;
    NSMutableArray *lastIds; //最后一条数据id
    NSString *currentPId;
}
@end

@implementation MyLotteryViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (self.shouldReloadData) {
        for (unsigned i = 0; i < dataSources.count; ++i) {
            [dataSources replaceObjectAtIndex:i withObject:[NSMutableArray array]];
        }
        
        for (unsigned i = 0; i < lastIds.count; ++i) {
            [lastIds replaceObjectAtIndex:i withObject:MyLottery_lastId_start];
        }
        
        for (unsigned i = 0; i < 3; ++i) {
            NSString *key = [self keyWithType:i];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self selectAtGroup:0];
        self.shouldReloadData = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDatas];
    [self adjustView];
    [self addTableViews];
    
//    [self selectAtGroup:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatus) name:@"BetSearchUpdateStatus" object:nil];
}
- (void)updateStatus
{
    NSArray *dataSource = [dataSources objectAtIndex:currentGroup];
    for (MyLotteryObject *myObj in dataSource)
    {
        if ([myObj.projectid isEqualToString:currentPId])
        {
            myObj.iscancel = @"1";
        }
    }
    UITableView *tableView = [tableViews objectAtIndex:currentGroup];
    [tableView reloadData];
}
- (void)initDatas
{
    dataSources = [NSMutableArray array];
    for (unsigned i = 0; i < 3; ++i) {
        [dataSources addObject:[NSMutableArray array]];
    }
    
    lastIds = [NSMutableArray array];
    for (unsigned i = 0; i < 3; ++i) {
        [lastIds addObject:MyLottery_lastId_start];
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
        
        [tableView registerNib:[UINib nibWithNibName:@"MyLotteryCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        
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
    frame.size.height = IS_IPHONE5 ? 411 : 323;
    self.scrollView.frame = frame;
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
        else
        {
            NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval lastTimeInterval = [self updateTimeWithType:group];
            if (currentTimeInterval - lastTimeInterval > AutoUpdateTime) {
                [self refreshData_type:group];
            }
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
    int maxHeight = IS_IPHONE5 ? 411 : 323;
    
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
    if (scrollView.tag == -1) {
        currentGroup = scrollView.contentOffset.x / 320;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == -1) {
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
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataSource = [dataSources objectAtIndex:tableView.tag];
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLotteryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell=[[MyLotteryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *dataSource = [self dataSourceWithType:tableView.tag];
    if (dataSource && [dataSource isKindOfClass:[NSArray class]] && indexPath.row < dataSource.count) {
        MyLotteryObject *myLotteryObject = [dataSource objectAtIndex:indexPath.row];
        [cell updateWithMyLotteryObject:myLotteryObject];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *dataSource = [self dataSourceWithType:tableView.tag];
    MyLotteryObject *myObj = [dataSource objectAtIndex:indexPath.row];
    
    BetDetailViewController *betDetailVC = [[BetDetailViewController alloc] init];
    betDetailVC.hidesBottomBarWhenPushed = YES;
    betDetailVC.projectID = [myObj projectid];
    currentPId = [myObj projectid];
    [self.navigationController pushViewController:betDetailVC animated:YES];
}

#pragma mark - 数据处理
//lastId
- (void)setId:(NSString *)projectId type:(NSInteger)type
{
    if (type >= lastIds.count) {
        NSLog(@"type 超出范围");
        return;
    }
    [lastIds replaceObjectAtIndex:type withObject:projectId];
}
- (NSString *)lastIdWithType:(NSInteger)type
{
    if (type >= lastIds.count) {
        NSLog(@"type 超出范围");
        return MyLottery_lastId_start;
    }
    return [lastIds objectAtIndex:type];
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


#pragma mark - 数据请求
- (void)requestData_isRefresh:(BOOL)isRefresh type:(NSInteger)type
{
    UITableView *tableView = [tableViews objectAtIndex:type];
    
    if (isRefresh)
    {
        [self setId:MyLottery_lastId_start type:type];
    }
    NSString *lastId = [self lastIdWithType:type];
    
    NSString *pageNumberStr = [NSString stringWithFormat:@"%d",MyLottery_numberOfPage];
    
    NSString *typeStr = [@(type) stringValue];
    [[AppHttpManager sharedManager] getMyLotteryList_with_type:typeStr projectId:lastId projectNumber:pageNumberStr block:^(id JSON, NSError *error)
    {
        if (!error)
        {
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
            
            id listData = [JSON objectForKey:@"data"];
            if([listData isKindOfClass:[NSArray class]])
            {
                NSArray *dataArray = (NSArray *)listData;
                for (NSDictionary *dictionary in dataArray)
                {
                    MyLotteryObject *myLotteryObject = [[MyLotteryObject alloc] initWithDictionary:dictionary];
                    [dataSource addObject:myLotteryObject];
                }
            }
            
            if (dataSource.count > 0)
            {
                MyLotteryObject *myLotteryObject = [dataSource lastObject];
                [self setId:myLotteryObject.projectid type:type];
            }
            
            [self setDataSource:dataSource type:type];
            [self saveUpdateTimeWithType:type];
            
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

- (NSString *)keyWithType:(NSInteger)type
{
    NSString *key = [NSString stringWithFormat:@"%@_%d",KeyLastUpdateTime,type];
    return key;
}
- (void)saveUpdateTimeWithType:(NSInteger)type
{
    NSString *key = [self keyWithType:type];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:timeInterval forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSTimeInterval)updateTimeWithType:(NSInteger)type
{
    NSString *key = [self keyWithType:type];
    NSTimeInterval timeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:key];
    return timeInterval;
}
- (IBAction)zhuiHaoAction:(UIButton *)sender
{
    ZHSearchViewController *zhVC = [[ZHSearchViewController alloc] init];
    zhVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhVC animated:YES];
}
@end
