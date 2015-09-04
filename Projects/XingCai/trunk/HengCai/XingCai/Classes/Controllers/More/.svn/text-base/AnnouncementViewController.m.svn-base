//
//  AnnouncementViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AnnouncementDetailViewController.h"
#import "NoticeListObject.h"
#import "AnnouncementCell.h"
#import "MJRefresh.h"

#define BASETAG    1024
#define kTagCellBackView 5000
static NSString *CellIdentifier = @"AnnouncementCell";

@interface AnnouncementViewController ()
@end

@implementation AnnouncementViewController
@synthesize containerView;
@synthesize tView;
@synthesize headCell;

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
-(void) viewWillAppear:(BOOL)animated
{
    //[self loadData];
    //-----------------------------------------------------------------------------------------加出了加载的效果->[begin]
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tView addFooterWithTarget:self action:@selector(footerRefreshing)];
    //-----------------------------------------------------------------------------------------加出了加载的效果->[end]
    
    [self.tView footerBeginRefreshing];
    [self.tView headerBeginRefreshing];
}
//----------------------------------------------------------------------------------------------------------------参考demo-begin
- (void)headerRefreshing
{
    [self loadData];
}
- (void)footerRefreshing
{
    [tView reloadData];
    [tView footerEndRefreshing];
}
//----------------------------------------------------------------------------------------------------------------参考demo-end
- (void)loadData
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getNoticeListWithBlock:^(id JSON, NSError *error)
     {
         //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSArray class]])
             {
                 NSArray *itemArray = JSON;
                 noticeListArr = [[NSMutableArray alloc] init];
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         NoticeListObject *noticeListObj = [[NoticeListObject alloc] initWithAttribute:oneObjectDict];
                         [noticeListArr addObject:noticeListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSArray,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 [tView reloadData];
             }
             else
             {
                 DDLogWarn(@"JSON should be NSArray,%@:%@", NSStringFromSelector(_cmd),[self class]);
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adjustView];
    if (!IS_IPHONE5)
    {
        self.tView.size = CGSizeMake(320, 416);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnBtnClk:(UIButton *)sender
{
    if (noticeListArr.count>0)
    {
        [noticeListArr removeAllObjects];
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

//tableView-begin
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noticeListArr count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        self.headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.headCell;
    }
    else
    {
        [tableView registerNib:[UINib nibWithNibName:@"AnnouncementCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell){
            cell=[[AnnouncementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
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
        //去掉UITableView中cell的边框和分割线
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        if (noticeListArr.count>0)
        {
            NoticeListObject *noticeListObject = [noticeListArr objectAtIndex:[indexPath row]-1];
            [cell updateAnnouncementObject:noticeListObject index:indexPath.row];
        }
        
        return cell;
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
    if (indexPath.row == 0)
    {
        return 100;
    }
    else
    {
        return 84;
    }
}
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        NoticeListObject *noticeListObject = [noticeListArr objectAtIndex:[indexPath row]-1];
        
        AnnouncementDetailViewController *tmp = [[AnnouncementDetailViewController alloc] init];
        tmp.hidesBottomBarWhenPushed = YES;
        tmp.idd = [noticeListObject idd];
        [self.navigationController pushViewController:tmp animated:YES];
    }
}

//tableView-end
@end
