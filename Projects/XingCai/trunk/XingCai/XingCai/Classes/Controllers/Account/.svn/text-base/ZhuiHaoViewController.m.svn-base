//
//  ZhuiHaoViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-12.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZhuiHaoViewController.h"
#import "ZhuiHaoObject.h"
#import "PublicOfLotteryName.h"
#import "ZhuiHaoDetailViewController.h"

#define BASETAG1    1024

@interface ZhuiHaoViewController ()
@end

@implementation ZhuiHaoViewController


@synthesize startLab;
@synthesize endLab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self loadData:startLab.text endDate:endLab.text withPage:@"1"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    addArray=[[NSMutableArray alloc]init];
    zhListArr = [[NSMutableArray alloc] init];
    
    self.zhuihaoTableView.size = CGSizeMake(320, 359);
    self.zhuihaoTableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_top"]];
    self.zhuihaoTableView.tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_bottom"]];
    self.zhuihaoTableView.tableHeaderView.hidden=YES;
    self.zhuihaoTableView.tableFooterView.hidden=YES;
  
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60,320+(IS_IPHONE5?60:0), 200,40)];
    myMessagelabel.text=@"您暂时没有追号记录";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor grayColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:myMessagelabel];

    _starDatePickerView=[[TDDatePickerController alloc]init];
    
    _starDatePickerView.delegate=self;
    
    _endDatePickerView=[[TDDatePickerController alloc]init];
    
    _endDatePickerView.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBtnClk:(UIButton *)sender
{
    if(zhListArr.count>0||zhListArr.count!=0){
        [zhListArr removeAllObjects];
    }
    NSString *page=@"0";
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"zhuihaoPage"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate withPage:(NSString*)page
{
    
    if (mark==YES) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mark=NO;
    }
    NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"zhuihaoPage"];
   
    [[AppHttpManager sharedManager] zhuiHaoChaXunWithStartTime:[sDate stringByAppendingString:@" 02:20:00"] endTime:[eDate stringByAppendingString:@" 02:20:00"] Page:page Block:^(id JSON, NSError *error)
     {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSArray *itemArray = [JSON objectForKey:@"aTask"];
                 NSDictionary *itemAr = [JSON objectForKey:@"pageinfo"];
             
                 totalPage=[[itemAr objectForKey:@"TotalPages"] intValue];
//                 CurrentPage=[[itemAr objectForKey:@"TotalCounts"] intValue];
                 NSString *str=@"1";
                 if ([current isEqualToString:page]||[page isEqualToString:str]) {
                     
                     [zhListArr removeAllObjects];
                     
                 }

                
                  for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         ZhuiHaoObject *zhListObj = [[ZhuiHaoObject alloc] initWithAttribute:oneObjectDict];
                         [zhListArr addObject:zhListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 
                     [self.zhuihaoTableView reloadData];

              
                 if (zhListArr.count==0) {
                     myMessagelabel.hidden=NO;
                     self.zhuihaoTableView.tableHeaderView.hidden=YES;
                     self.zhuihaoTableView.tableFooterView.hidden=YES;
                 }
                 else if(zhListArr.count>0){
                     myMessagelabel.hidden=YES;
                     self.zhuihaoTableView.tableHeaderView.hidden=NO;
                     self.zhuihaoTableView.tableFooterView.hidden=NO;

                 }
                  
              

             }
             else
             {
                 DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
    
      [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"zhuihaoPage"];
}
//设置开始时间---begin
-(IBAction)startDate:(id)sender
{
     [self presentSemiModalViewController:_starDatePickerView];
}

//设置开始时间---end

-(IBAction)endDate:(id)sender
{
    [self presentSemiModalViewController:_endDatePickerView];
}
//设置结束时间---end
-(IBAction)searchClk:(id)sender
{
    mark=YES;
    if(zhListArr.count>0||zhListArr.count!=0){
        [zhListArr removeAllObjects];
    }
    
    myMessagelabel.hidden=YES;
    
    
    NSString *startDate = startLab.text;
    NSString *endDate = endLab.text;
    if ([startDate isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"开始时间不能为空！"];
        return;
    }
    else if ([endDate isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"结束时间不能为空！"];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *sDate=[formatter dateFromString:startDate];
    NSDate *eDate=[formatter dateFromString:endDate];
    long sLong = [sDate timeIntervalSince1970];
    long eLong = [eDate timeIntervalSince1970];
    if (sLong > eLong)
    {
        [Utility showErrorWithMessage:@"开始时间不能晚于结束时间！"];
        return;
    }
    
//    NSString *page=@"0";
//    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"zhuihaoPage"];
    
    [self loadData:startLab.text endDate:endLab.text withPage:@"1"];
    
}
//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(ZhuiHaoObject *)object rowInd:(NSInteger)rowIndex
{
    UIImageView *imgV1 = (UIImageView *)[cell viewWithTag:BASETAG1];
    if(imgV1==nil)
    {
        imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 94, 20)];
        [cell addSubview:imgV1];
        imgV1.tag = BASETAG1;
    }
    [imgV1 setImage:[UIImage imageNamed:@"bg_tag"]];
    
    UILabel *titleLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(titleLab == nil)
    {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0.5, 94, 20)];
        titleLab.tag = BASETAG1+1;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = [UIColor colorWithRed:(229/225.0) green:(27/255.0) blue:(199/255.0) alpha:1];
        titleLab.textAlignment = UITextAlignmentCenter;
        titleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLab];
    }
    titleLab.text = [object cnname];

    UILabel *beginIssueLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(beginIssueLab == nil)
    {
        beginIssueLab = [[UILabel alloc] initWithFrame:CGRectMake(6, 40, 85, 15)];
        beginIssueLab.tag = BASETAG1+2;
        beginIssueLab.font = [UIFont systemFontOfSize:11];
        beginIssueLab.textColor = [UIColor colorWithRed:(255/255.0) green:(130/255.0) blue:(0/255.0) alpha:1];
        beginIssueLab.textAlignment = UITextAlignmentCenter;
        beginIssueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:beginIssueLab];
    }
    beginIssueLab.text = [object beginissue];
    
    UILabel *taskpriceLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(taskpriceLab == nil)
    {
        taskpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(91, 40, 73, 15)];
        taskpriceLab.tag = BASETAG1+3;
        taskpriceLab.font = [UIFont systemFontOfSize:10];
        taskpriceLab.textColor = [UIColor darkGrayColor];
        taskpriceLab.textAlignment = UITextAlignmentCenter;
        taskpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:taskpriceLab];
    }
    //float floatTaskPrice = [[object taskprice] floatValue];
    //taskpriceLab.text = [NSString stringWithFormat:@"%.2f", floatTaskPrice];
    taskpriceLab.text = [object taskprice];
    
    UILabel *finishpriceLab = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(finishpriceLab == nil)
    {
        finishpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 40, 56, 15)];
        finishpriceLab.tag = BASETAG1+4;
        finishpriceLab.font = [UIFont systemFontOfSize:10];
        finishpriceLab.textColor = [UIColor darkGrayColor];
        finishpriceLab.textAlignment = UITextAlignmentCenter;
        finishpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:finishpriceLab];
    }
    //float floatFinishPrice = [[object finishprice] floatValue];
    //finishpriceLab.text = [NSString stringWithFormat:@"%.2f", floatFinishPrice];
    finishpriceLab.text = [object finishprice];
    
    UILabel *stopWinLab = (UILabel *)[cell viewWithTag:BASETAG1+5];
    if(stopWinLab == nil)
    {
        stopWinLab = [[UILabel alloc] initWithFrame:CGRectMake(222, 40, 56, 15)];
        stopWinLab.tag = BASETAG1+5;
        stopWinLab.font = [UIFont systemFontOfSize:11];
        stopWinLab.textColor = [UIColor darkGrayColor];
        stopWinLab.textAlignment = UITextAlignmentCenter;
        stopWinLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:stopWinLab];
    }
    if ([[object stoponwin] isEqualToString:@"1"])
    {
        stopWinLab.text = @"是";
    }
    else
    {
        stopWinLab.text = @"否";
    }
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG1+6];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(278, 40, 35, 15)];
        statusLab.tag = BASETAG1+6;
        statusLab.font = [UIFont systemFontOfSize:11];
        statusLab.textColor = [UIColor darkGrayColor];
        statusLab.textAlignment = UITextAlignmentCenter;
        statusLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:statusLab];
    }
    if ([[object status] isEqualToString:@"0"])
    {
        statusLab.text = @"进行中";
    }
    else if ([[object status] isEqualToString:@"1"])
    {
        statusLab.text = @"已取消";
    }
    else if ([[object status] isEqualToString:@"2"])
    {
        statusLab.text = @"已完成";
    }
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [zhListArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_middle"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    if (zhListArr.count>0 && [zhListArr isKindOfClass:[NSArray class]])
    {
        myMessagelabel.hidden=YES;
        ZhuiHaoObject *zhtObj = [zhListArr objectAtIndex:indexPath.row];
        [self modelCellFill:cell Object:zhtObj rowInd:[indexPath row]];
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
    return 82;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (zhListArr.count>0 && [zhListArr isKindOfClass:[NSArray class]])
    {
        ZhuiHaoObject *zhObj = [zhListArr objectAtIndex:indexPath.row];
        
        ZhuiHaoDetailViewController *zhDetailVC = [[ZhuiHaoDetailViewController alloc] init];
        zhDetailVC.taskID = [zhObj taskid];
        zhDetailVC.isCancel = [zhObj status];
        [self.navigationController pushViewController:zhDetailVC animated:YES];
    }
}
//tableView-end
- (void)addFooter
{
    __unsafe_unretained ZhuiHaoViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.zhuihaoTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"zhuihaoPage"];
        int curren =[current intValue];
       
        if (curren<totalPage) {
            int a= curren+1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
            [self loadData:startLab.text endDate:endLab.text withPage:pageStr];
            
        }else if (curren==totalPage&&curren!=0)
        {
            
        }else if(curren==0){
            curren=1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",curren];
            [self loadData:startLab.text endDate:endLab.text withPage:pageStr];
            
        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        myMessagelabel.hidden=YES;
    };
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
        if (zhListArr.count==0) {
            myMessagelabel.hidden=NO;
            self.zhuihaoTableView.tableHeaderView.hidden=YES;
            self.zhuihaoTableView.tableFooterView.hidden=YES;

        }
        else{
            myMessagelabel.hidden=YES;
            self.zhuihaoTableView.tableFooterView.hidden=NO;
            self.zhuihaoTableView.tableHeaderView.hidden=NO;
        }

    };
    
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained ZhuiHaoViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.zhuihaoTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
//        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"zhuihaoPage"];
//        int curren =[current intValue];
//      
//        if (curren<totalPage) {
//            int a= curren+1;
//            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
//            [self loadData:startLab.text endDate:endLab.text withPage:pageStr];
//            
//        }else if (curren==totalPage&&curren!=0)
//        {
//            
//        }else if(curren==0){
//            curren=1;
//            NSString *pageStr =[NSString stringWithFormat:@"%d",curren];
//            [self loadData:startLab.text endDate:endLab.text withPage:pageStr];
//            
//        }
        NSString *pageStr =@"1";
        [self loadData:startLab.text endDate:endLab.text withPage:pageStr];

        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        myMessagelabel.hidden=YES;
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
        if (zhListArr.count==0) {
            myMessagelabel.hidden=NO;
            self.zhuihaoTableView.tableHeaderView.hidden=YES;
            self.zhuihaoTableView.tableFooterView.hidden=YES;

        }
        else{
            myMessagelabel.hidden=YES;
            self.zhuihaoTableView.tableFooterView.hidden=NO;
            self.zhuihaoTableView.tableHeaderView.hidden=NO;
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
    [self.zhuihaoTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark- Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
    [self dismissSemiModalViewController:viewController];
    
    _selectedDate = viewController.datePicker.date;
    [UIView animateWithDuration:.6 animations:^{
        
    }completion:^(BOOL finished) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyy-MM-dd"];
        if (viewController==_starDatePickerView) {
            startLab.text= [fmt stringFromDate:_selectedDate];
        }else{
            endLab.text=[fmt stringFromDate:_selectedDate];
        }
        
    }];
}

-(void)datePickerClearDate:(TDDatePickerController*)viewController {
    [self dismissSemiModalViewController:viewController];
    
    _selectedDate = nil;
    
}

-(void)datePickerCancel:(TDDatePickerController*)viewController {
    [self dismissSemiModalViewController:viewController];
    
}
-(void)dealloc
{
    _starDatePickerView.delegate=nil;
    
    _endDatePickerView.delegate=nil;
    
}

@end
