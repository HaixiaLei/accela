//
//  MessageViewController.m
//  JiXiangCai
//
//  Created by jay on 14-11-7.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageObject.h"
#import "MJRefresh.h"

static NSString *CellIdentifier = @"MessageCell";

@interface MessageViewController ()
{
    NSArray *dataList;
    NSString *lastId;
}

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"站内短信";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftBarButton{}

- (void)refreshList
{
    [self.tableView headerBeginRefreshing];
}

- (void)headerRefreshing
{
    [self requestList_isRefresh:YES];
}

- (void)footerRefreshing
{
    [self requestList_isRefresh:NO];
}

- (void)requestList_isRefresh:(BOOL)isRefresh
{
    if (isRefresh)
    {
        lastId = @"0";
    }
    [[AFAppAPIClient sharedClient] getMessageList_with_maxid:lastId count:@"10" block:^(id JSON, NSError *error){
        if (!error) {
            NSMutableArray *messages = [NSMutableArray array];
            NSArray *dataArray = [JSON objectForKey:@"results"];
            for (NSDictionary *dictionary in dataArray) {
                MessageObject *messageObject = [[MessageObject alloc] initWithDictionary:dictionary];
                [messages addObject:messageObject];
            }
            
            if (isRefresh)
            {
                dataList = messages;
            }
            else
            {
                dataList = [dataList arrayByAddingObjectsFromArray:messages];
            }
            
            if (messages.count > 0)
            {
                MessageObject *messageObject = [messages lastObject];
                lastId = messageObject.entry;
            }
            
            [self.tableView reloadData];
            [self updateTableViewFooter];
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        }
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageObject *messageObject = [dataList objectAtIndex:indexPath.row];
    if (messageObject.showDetail) {
        MessageTableViewCell *cell = (MessageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell cellHeightForContent:messageObject.content];
    }
    else
    {
        return 61;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MessageObject *messageObject = [dataList objectAtIndex:indexPath.row];
    [cell setTitle:messageObject.subject];
    [cell setTime:messageObject.sendtime];
    
    [cell setStatusWithReadTime:messageObject.readtime];
    [cell setContent:messageObject.content];
    
    if (messageObject.showDetail) {
        [cell setExpandBtnPositionWithContent:messageObject.content];
        [cell setSeparatorLinePositionWithContent:messageObject.content];
    }
    else
    {
        [cell setExpandBtnPositionWithContent:@""];
        [cell setSeparatorLinePositionWithContent:@""];
    }
    
    [cell setShowDetail:messageObject.showDetail];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageObject *messageObject = [dataList objectAtIndex:indexPath.row];
    
    //调用接口更新
    if (![messageObject.readtime integerValue] && !messageObject.showDetail) {
        [[AFAppAPIClient sharedClient] updateMessage_with_msgid:messageObject.entry block:^(id JSON, NSError *error){
            if (!error) {
                NSString *totalString = [JSON objectForKey:@"total"];
                [[MessageManager sharedManager] setTotal:totalString];
            }
        }];
    }

    messageObject.showDetail = ! messageObject.showDetail;
    messageObject.readtime = @"1";
    
    [tableView reloadData];
    [self updateTableViewFooter];
}


- (void)updateTableViewFooter
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    int totalHeight = 0;
    for (int i = 0; i < dataList.count; ++i) {
        totalHeight += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    int maxHeight = IS_IPHONE5 ? 504 : 416;
    
    if (totalHeight > maxHeight) {
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    }
    else
    {
        [self.tableView removeFooter];
    }
}
@end
