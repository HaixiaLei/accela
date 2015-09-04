//
//  MyMsgViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-16.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MyMsgViewController.h"

#import "MsgListObject.h"

#import "PublicOfLotteryName.h"
#define BASETAG1    1024

@interface MyMsgViewController ()
@end

@implementation MyMsgViewController

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
    NSString *pushStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"PushMark"];
    
    if (![pushStr isEqualToString:@"1"]) {
        [addArray removeAllObjects];
        [msgListArr removeAllObjects];
         [self loadDataWithPage:@"1"];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"PushMark"];
  
}
- (void)loadDataWithPage:(NSString*)page
{
    
     NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPage"];

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getMessageListWithPage:page Block:^(id JSON, NSError *error)
     {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
                 if (msgListArr.count>0) {
                     myMessagelabel.hidden=YES;
                 }else
                 {
                     myMessagelabel.hidden=NO;
                 }

//                      [msgListArr addObjectsFromArray:addArray];

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
     }];
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"currentPage"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.tView.size = CGSizeMake(320, 504);
    
     addArray = [[NSMutableArray alloc] init];
     msgListArr = [[NSMutableArray alloc] init];
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60,200, 200,40)];
    myMessagelabel.text=@"您暂时没有短消息";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor blackColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:myMessagelabel];
}
- (void)addFooter
{
    __unsafe_unretained MyMsgViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
//        NSString *page=@"1";
//        [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"currentPage"];
        
        if (CurrentPage<totalPage)
        {
            NSString *pageStr =[NSString stringWithFormat:@"%d",CurrentPage+1];
            [self loadDataWithPage:pageStr];
        }
        else if (CurrentPage==totalPage&&CurrentPage!=0)
        {
            NSLog(@"444444");
        }
        else if(CurrentPage==0)
        {
            CurrentPage=1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",CurrentPage];
            [self loadDataWithPage:pageStr];
        }
     
        [self.tView reloadData];
        
  
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        myMessagelabel.hidden=YES;
    };
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
        if (msgListArr.count==0)
        {
            myMessagelabel.hidden=NO;
        }
        else{
         myMessagelabel.hidden=YES;
        
        }
    };

    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained MyMsgViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Bloc
        NSLog(@"%d----%d",CurrentPage,totalPage);
//        if (CurrentPage<totalPage) {
//
//            NSString *pageStr =[NSString stringWithFormat:@"%d",CurrentPage+1];
//            [self loadDataWithPage:pageStr];
//            
//        }else if (CurrentPage==totalPage&&CurrentPage!=0)
//        {
//            
//        }else if(CurrentPage==0){
//            CurrentPage=1;
//             NSString *pageStr =[NSString stringWithFormat:@"%d",CurrentPage];
//            [self loadDataWithPage:pageStr];
//
//        }
        NSString *pageStr=@"1";
        [self loadDataWithPage:pageStr];

         [self.tView reloadData];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        myMessagelabel.hidden=YES;
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
        if (msgListArr.count>0) {
            myMessagelabel.hidden=YES;
        }else
        {
         myMessagelabel.hidden=NO;
        }
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnBtnClk:(UIButton *)sender
{
    
    if (msgListArr.count>0) {
        [msgListArr removeAllObjects];
    }
    NSString *page=@"0";
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"currentPage"];
    
    self.tView.editing = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(MsgListObject *)object rowInd:(NSInteger)rowIndex
{
    UILabel *contentLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(contentLab == nil)
    {
        contentLab = [[UILabel alloc] initWithFrame:CGRectMake(13, 32, 200, 20)];
        contentLab.tag = BASETAG1;
        contentLab.font = [UIFont systemFontOfSize:14];
        contentLab.textColor = [UIColor colorWithRed:(146/255.0) green:(43/255.0) blue:(173/255.0) alpha:1];
        contentLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:contentLab];
    }
//    contentLab.text = [object subject];
    if ([object subject].length==0)
    {
         contentLab.text =@"无标题";
    }else
    contentLab.text = [object subject];
    
    UILabel *dateLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(dateLab == nil)
    {
        dateLab = [[UILabel alloc] initWithFrame:CGRectMake(230, 32, 70, 20)];
        dateLab.tag = BASETAG1+1;
        dateLab.font = [UIFont systemFontOfSize:12];
        dateLab.textColor = [UIColor darkGrayColor];
        dateLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:dateLab];
    }
    dateLab.text = [[object sendtime] substringToIndex:10];
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [msgListArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    if(indexPath.row % 2 == 1)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_bg"]];
    }
    else if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (msgListArr.count>0)
    {
        myMessagelabel.hidden=YES;
        MsgListObject *msgListObject = [msgListArr objectAtIndex:indexPath.row];
        [self modelCellFill:cell Object:msgListObject rowInd:[indexPath row]];
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

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
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
//             if (msgListArr.count > 0)
//             {
//                 myMessagelabel.hidden=YES;
//             }
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
