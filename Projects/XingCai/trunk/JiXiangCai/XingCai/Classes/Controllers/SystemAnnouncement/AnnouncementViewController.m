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
#define TITLE_CONTENT @"系统公告"

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    [[AFAppAPIClient sharedClient] getNoticeList_with_block:^(id JSON, NSError *error)
     {
         //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if([JSON isKindOfClass:[NSDictionary class]])
             {
                 ;
                 NoticeListObject *noticeObject=[[NoticeListObject alloc]initWithAttribute:JSON];
                 _noticeArray=[noticeObject getDataArray];
                 [self.tView reloadData];
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
    self.title = TITLE_CONTENT;
    // Do any additional setup after loading the view from its nib.
    [self adjustView];
    if (!IS_IPHONE5)
    {
        self.tView.size = CGSizeMake(320, 416);
    }
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
    if (_noticeArray.count>0)
    {
        [_noticeArray removeAllObjects];
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

//tableView-begin
//返回某个表视图有多少行数据
#pragma mark  - tableview delegate&& datesource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_noticeArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * cellIdentifier=@"AnnouncementCell" ;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"AnnouncementCell"  owner:self options:nil]lastObject];
    }
    UILabel *subjectLab=(UILabel *)[cell.contentView viewWithTag:101];
    UILabel *timeLab=(UILabel *)[cell.contentView viewWithTag:102];
    AnnouncementObject *object=_noticeArray[indexPath.row];
    subjectLab.text=object.subject;
    timeLab.text=object.sendDay;
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
    return 80;
}
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementObject *noticeObject = [_noticeArray objectAtIndex:[indexPath row]];
    
    AnnouncementDetailViewController *announcementDetailViewController = [[AnnouncementDetailViewController alloc] init];
    announcementDetailViewController.urlString = noticeObject.noticeUrl;
    [self.navigationController pushViewController:announcementDetailViewController animated:YES];
}

//tableView-end
@end
