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
#import "UIViewController+CustomNavigationBar.h"

#define BASETAG1    1024

@interface AnnouncementViewController ()
@end

@implementation AnnouncementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)loadData
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getNoticeListWithBlock:^(id JSON, NSError *error)
     {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
                 if (noticeListArr.count>0)
                 {
                     myMessagelabel.hidden=YES;
                 }
                 else
                 {
                     myMessagelabel.hidden=NO;
                 }
                 [_tView reloadData];
             }
             else
             {
                 DDLogWarn(@"JSON should be NSArray,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBarTitle:@"网站公告" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    // Do any additional setup after loading the view from its nib.
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
//    if (!IS_IPHONE5)
//    {
//        self.tView.size = CGSizeMake(320, 416);
//    }
    
    if (!IS_IPHONE5)
    {
        myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 180, 200, 40)];
    }
    else
    {
        myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 220, 200, 40)];
    }
    myMessagelabel.text = @"您暂时没有公告信息!";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor grayColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myMessagelabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(NoticeListObject *)object rowInd:(NSInteger)rowIndex
{
    UILabel *contentLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(contentLab == nil)
    {
        contentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, 275, 83)];
        contentLab.tag = BASETAG1+1;
        contentLab.font = [UIFont systemFontOfSize:12];
        contentLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.lineBreakMode = NSLineBreakByWordWrapping;
        contentLab.numberOfLines = 0;
        [cell addSubview:contentLab];
    }
    contentLab.text = [[[NSString stringWithFormat:@"%li",(long)rowIndex + 1] stringByAppendingString:@"、"] stringByAppendingString:[object subject]];
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noticeListArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    if(indexPath.row % 2 == 1)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_txt_odd"]];
    }
    else if(indexPath.row % 2 == 0)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_txt_even"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (noticeListArr.count>0)
    {
        myMessagelabel.hidden=YES;
        NoticeListObject *noticeListObject = [noticeListArr objectAtIndex:[indexPath row]];
        [self modelCellFill:cell Object:noticeListObject rowInd:[indexPath row]];
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
    return 86;
}
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeListObject *noticeListObject = [noticeListArr objectAtIndex:[indexPath row]];
    
    AnnouncementDetailViewController *tmp = [[AnnouncementDetailViewController alloc] init];
    tmp.hidesBottomBarWhenPushed = YES;
    tmp.idd = [noticeListObject idd];
    [self.navigationController pushViewController:tmp animated:YES];
}
//tableView-end

- (void)addFooter
{
    __unsafe_unretained AnnouncementViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        //        NSString *page=@"1";
        //        [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"currentPage"];
        
        [self loadData];
        
        [self.tView reloadData];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        DLog(@"%@----开始进入刷新状态", refreshView.class);
        myMessagelabel.hidden=YES;
    };
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
        DLog(@"%@----刷新完毕", refreshView.class);
        if (noticeListArr.count==0)
        {
            myMessagelabel.hidden=NO;
        }
        else
        {
            myMessagelabel.hidden=YES;
        }
    };
    
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained AnnouncementViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 进入刷新状态就会回调这个Bloc
        
            [self loadData];
            [self.tView reloadData];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        DLog(@"%@----开始进入刷新状态", refreshView.class);
       myMessagelabel.hidden=YES;
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
        DLog(@"%@----刷新完毕", refreshView.class);
        if (noticeListArr.count>0)
        {
            myMessagelabel.hidden=YES;
        }
        else
        {
            myMessagelabel.hidden=NO;
        }
     };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state)
    {
        // 控件的刷新状态切换了就会调用这个block
        switch (state)
        {
            case MJRefreshStateNormal:
                DLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                DLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                DLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

@end
