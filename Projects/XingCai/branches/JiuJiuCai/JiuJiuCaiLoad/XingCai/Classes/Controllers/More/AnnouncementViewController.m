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
    [[AppHttpManager sharedManager] getNoticeListWithBlock:^(id JSON, NSError *error)
     {
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
                 [_tView reloadData];
             }
             else
             {
                 DDLogWarn(@"JSON should be NSArray,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
//    if (!IS_IPHONE5)
//    {
//        self.tView.size = CGSizeMake(320, 456);
//    }
//    else
//    {
//        self.tView.size = CGSizeMake(320, 495);
//    }
    self.tView.size = CGSizeMake(320, 495);
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

    [self.navigationController popViewControllerAnimated:YES];
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(NoticeListObject *)object rowInd:(int)rowIndex
{
    UILabel *contentLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(contentLab == nil)
    {
        contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, 270, 63)];
        contentLab.tag = BASETAG1;
        contentLab.font = [UIFont systemFontOfSize:14];
        contentLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.lineBreakMode = UILineBreakModeWordWrap;
        contentLab.numberOfLines = 0;
        [cell addSubview:contentLab];
    }
    contentLab.text = [[[NSString stringWithFormat:@"%i",rowIndex+1] stringByAppendingString:@"、"] stringByAppendingString:[object subject]];
    
    UIView *arrowImg = (UIView *)[cell viewWithTag:BASETAG1+1];
    if(arrowImg == nil)
    {
        arrowImg = [[UIView alloc] initWithFrame:CGRectMake(292, 23, 20, 20)];
        [cell addSubview:arrowImg];
        arrowImg.tag = BASETAG1+1;
    }
    [arrowImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_right_arrow"]]];
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
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_text_content"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (noticeListArr.count>0)
    {
        NoticeListObject *noticeListObject = [noticeListArr objectAtIndex:indexPath.row];
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
    return 64;
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
- (void)addFooter
{
    __unsafe_unretained AnnouncementViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        
        //        NSString *page=@"1";
        //        [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"currentPage"];
        
            [self loadData];
            
        
        [self.tView reloadData];
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
//        myMessagelabel.hidden=YES;
    };
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained AnnouncementViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Bloc
        
            [self loadData];
            [self.tView reloadData];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
       
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
     };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
//                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
//                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
//                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
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

//tableView-end
@end
