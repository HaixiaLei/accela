//
//  MyMsgViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-16.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MyMsgViewController.h"
#import "MsgListObject.h"
#import "MyMsgCell.h"
#import "PublicOfLotteryName.h"
#import "MJRefresh.h"

#define BASETAG    1024
#define kTagCellBackView 5000
static NSString *CellIdentifier = @"MyMsgCell";

@interface MyMsgViewController ()
@end

@implementation MyMsgViewController
@synthesize containerView;
@synthesize tView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0)
    {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //-----------------------------------------------------------------------------------------加出了加载的效果-[begin]
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
//    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.tView headerEndRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tView addFooterWithTarget:self action:@selector(footerRefreshing)];
    //-----------------------------------------------------------------------------------------加出了加载的效果-[end]
    
    [self.tView footerBeginRefreshing];
    [self.tView headerBeginRefreshing];
}
//----------------------------------------------------------------------------------------------------------------参考demo-begin
- (void)headerRefreshing
{
    //NSString *pushStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushMark"];
    
    //if (![pushStr isEqualToString:@"1"])
    //{
        [msgListArr removeAllObjects];
        [self loadDataWithPage:@"1"];
    //}
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"PushMark"];
}
- (void)footerRefreshing
{
    NSString *current =[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPage"];
    int curren =[current intValue];
    if (curren<totalPage)
    {
        int nextPage = curren+1;
        NSString *pageStr =[NSString stringWithFormat:@"%d", nextPage];
        [self loadDataWithPage:pageStr];
    }
    else if (curren == totalPage && curren != 0)
    {
        //DLog(@"到头了");
        [self.tView footerEndRefreshing];//必须加这样，否则到头后，底部不消失
    }
}
//----------------------------------------------------------------------------------------------------------------参考demo-end
- (void)loadDataWithPage:(NSString*)page
{
     NSString *current =[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPage"];

    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getMessageListWithPage:page Block:^(id JSON, NSError *error)
     {
         //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSArray *itemArray = [JSON objectForKey:@"result"];
                 NSDictionary *itemAr = [JSON objectForKey:@"pageinfo"];
                 totalPage=[[itemAr objectForKey:@"TotalPages"] intValue];
                 CurrentPage=[[itemAr objectForKey:@"CurrentPage"] intValue];
              
                 if ([current isEqualToString:page]||[page isEqualToString:@"1"])
                 {
                    [msgListArr removeAllObjects];
                 }
              
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         MsgListObject *msgListObj = [[MsgListObject alloc] initWithAttribute:oneObjectDict];
                       
                         [msgListArr addObject:msgListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }

                 [self.tView reloadData];
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
         [self.tView headerEndRefreshing];
         
         // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
         [self.tView footerEndRefreshing];
     }];
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"currentPage"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"站内短信";
    
    [self adjustView];
    
    if (!IS_IPHONE5)
    {
        self.tView.size = CGSizeMake(320, 416);
    }
    else
    {
        self.tView.size = CGSizeMake(320, 504);
    }
    
    msgListArr = [[NSMutableArray alloc] init];
}

- (void)setLeftBarButton
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnBtnClk:(UIButton *)sender
{
    if (msgListArr.count>0)
    {
        [msgListArr removeAllObjects];
    }
    NSString *page=@"0";
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"currentPage"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//tableView-begin
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [msgListArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerNib:[UINib nibWithNibName:@"MyMsgCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    MyMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(indexPath.row % 2 == 1)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_news_odd"]];
    }
    else if(indexPath.row % 2 == 0)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_news_even"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (msgListArr.count>0)
    {
        MsgListObject *msgListObject = [msgListArr objectAtIndex:indexPath.row];
        [cell updateMsgObject:msgListObject];
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
    return 84;
}
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (msgListArr.count>0 && [msgListArr isKindOfClass:[NSArray class]])
    {
        MsgListObject *msgListObject = [msgListArr objectAtIndex:indexPath.row];
        
        MyMsgDetailViewController *tmp = [[MyMsgDetailViewController alloc] init];
        tmp.hidesBottomBarWhenPushed = YES;
        tmp.entryStr = [msgListObject entry];
        [self.navigationController pushViewController:tmp animated:YES];
    }
}
//tableView-end

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MsgListObject *msgListObject = [msgListArr objectAtIndex:indexPath.row];
    [[AppHttpManager sharedManager] deleteMessageContentWithMessageId:[msgListObject entry] Block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             [msgListArr removeObjectAtIndex:indexPath.row];
             [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
             [self.tView reloadData];
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
@end
