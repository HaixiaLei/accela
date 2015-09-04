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
#import "ZHRecordsDetailViewController.h"
#import "UIViewController+CustomNavigationBar.h"

#define BASETAG    1024

@interface ZhuiHaoViewController ()
@end

@implementation ZhuiHaoViewController
@synthesize startLab;
@synthesize endLab;
@synthesize titleImg;
@synthesize lotteryTypeLab;
@synthesize priceLab;
@synthesize ifWinStopLab;
@synthesize statusLabel;
@synthesize bannerImg;

@synthesize lotteryTypeView;
@synthesize lotteryLab;
@synthesize lp;

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
    [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPage:@"1"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBarTitle:@"追号查询" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    
    //设置默认全部彩种
    lotteryTypeStr = @"0";
    lotteryText = @"全部";
    lotteryArray = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    subLotteryArr = [[NSMutableArray alloc] initWithObjects:@"重庆", @"5分彩", nil];
    [lotteryArray addObjectsFromArray:subLotteryArr];
    [self.lp setDates:lotteryArray];
    [self.lp reloadAllComponents];
    lotteryLab.text = [lotteryArray objectAtIndex:0];
    
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
    
    //self.zhuihaoTableView.size = CGSizeMake(320, 359);
  
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    if (!IS_IPHONE5)
    {
        myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 200, 20)];
    }
    else
    {
        myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 150, 200, 20)];
    }
    myMessagelabel.text=@"您暂时没有追号记录!";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor grayColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = NSTextAlignmentCenter;
    [self.zhuihaoTableView addSubview:myMessagelabel];

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

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate lotteryid:(NSString *)lotteryid withPage:(NSString*)page
{
    if (mark==YES)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mark=NO;
    }
    NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"zhuihaoPage"];
   
    [[AppHttpManager sharedManager] zhuiHaoChaXunWithStartTime:[sDate stringByAppendingString:@" 02:00:00"] endTime:[eDate stringByAppendingString:@" 02:00:00"] lotteryid:lotteryid Page:page Block:^(id JSON, NSError *error)
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
                 if ([current isEqualToString:page]||[page isEqualToString:str])
                 {
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

                 if (zhListArr.count==0)
                 {
                     myMessagelabel.hidden=NO;
                     
                     titleImg.hidden=YES;
                     lotteryTypeLab.hidden=YES;
                     priceLab.hidden=YES;
                     ifWinStopLab.hidden=YES;
                     statusLabel.hidden=YES;
                     bannerImg.hidden=YES;
                 }
                 else if(zhListArr.count>0)
                 {
                     myMessagelabel.hidden=YES;
                     
                     titleImg.hidden=NO;
                     lotteryTypeLab.hidden=NO;
                     priceLab.hidden=NO;
                     ifWinStopLab.hidden=NO;
                     statusLabel.hidden=NO;
                     bannerImg.hidden=NO;
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
        [Utility showErrorWithMessage:@"开始时间不能为空!"];
        return;
    }
    else if ([endDate isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"结束时间不能为空!"];
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
        [Utility showErrorWithMessage:@"开始时间不能晚于结束时间!"];
        return;
    }
    
//    NSString *page=@"0";
//    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"zhuihaoPage"];
    if ([lotteryLab.text isEqualToString:@"重庆"])
    {
        lotteryTypeStr = @"1";
    }
    else if ([lotteryLab.text isEqualToString:@"5分彩"])
    {
        lotteryTypeStr = @"14";
    }
    else
    {
        lotteryTypeStr = @"0";
    }
    [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPage:@"1"];
}
//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(ZhuiHaoObject *)object rowInd:(NSInteger)rowIndex
{
    UIImageView *imgV1 = (UIImageView *)[cell viewWithTag:BASETAG];
    if(imgV1==nil)
    {
        imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 5, 36, 36)];
        [cell addSubview:imgV1];
        imgV1.tag = BASETAG;
    }
    if ([[object lotteryid] isEqualToString:@"1"])
    {
        [imgV1 setImage:[UIImage imageNamed:@"icon_cq"]];
    }
    else if ([[object lotteryid] isEqualToString:@"14"])
    {
        [imgV1 setImage:[UIImage imageNamed:@"icon_henei"]];
    }
    
    UILabel *titleLab = (UILabel *)[cell viewWithTag:BASETAG+1];
    if(titleLab == nil)
    {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 72, 15)];
        titleLab.tag = BASETAG+1;
        titleLab.font = [UIFont systemFontOfSize:10];
        titleLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLab];
    }
    titleLab.text = [object cnname];

    UILabel *beginIssueLab = (UILabel *)[cell viewWithTag:BASETAG+2];
    if(beginIssueLab == nil)
    {
        beginIssueLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, 72, 15)];
        beginIssueLab.tag = BASETAG+2;
        beginIssueLab.font = [UIFont systemFontOfSize:9];
        beginIssueLab.textColor = [UIColor colorWithRed:(106/255.0) green:(120/255.0) blue:(141/255.0) alpha:1];
        beginIssueLab.textAlignment = NSTextAlignmentCenter;
        beginIssueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:beginIssueLab];
    }
    beginIssueLab.text = [object beginissue];
    //-------------------------------------------------------------------------------------------------------
    UILabel *taskpriceLab = (UILabel *)[cell viewWithTag:BASETAG+3];
    if(taskpriceLab == nil)
    {
        taskpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(72, 26, 115, 15)];
        taskpriceLab.tag = BASETAG+3;
        taskpriceLab.font = [UIFont systemFontOfSize:10];
        taskpriceLab.textColor = [UIColor colorWithRed:(244/255.0) green:(58/255.0) blue:(58/255.0) alpha:1];
        taskpriceLab.textAlignment = NSTextAlignmentCenter;
        taskpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:taskpriceLab];
    }
    //float floatTaskPrice = [[object taskprice] floatValue];
    //taskpriceLab.text = [NSString stringWithFormat:@"%.2f", floatTaskPrice];
    taskpriceLab.text = [@"总金额: " stringByAppendingString:[object taskprice]];
    
    UILabel *finishpriceLab = (UILabel *)[cell viewWithTag:BASETAG+4];
    if(finishpriceLab == nil)
    {
        finishpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(72, 41, 115, 15)];
        finishpriceLab.tag = BASETAG+4;
        finishpriceLab.font = [UIFont systemFontOfSize:10];
        finishpriceLab.textColor = [UIColor colorWithRed:(244/255.0) green:(58/255.0) blue:(58/255.0) alpha:1];
        finishpriceLab.textAlignment = NSTextAlignmentCenter;
        finishpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:finishpriceLab];
    }
    //float floatFinishPrice = [[object finishprice] floatValue];
    //finishpriceLab.text = [NSString stringWithFormat:@"%.2f", floatFinishPrice];
    finishpriceLab.text = [@"已完成: " stringByAppendingString:[object finishprice]];
    //-------------------------------------------------------------------------------------------------------
    UILabel *stopWinLab = (UILabel *)[cell viewWithTag:BASETAG+5];
    if(stopWinLab == nil)
    {
        stopWinLab = [[UILabel alloc] initWithFrame:CGRectMake(187, 31, 60, 15)];
        stopWinLab.tag = BASETAG+5;
        stopWinLab.font = [UIFont systemFontOfSize:10];
        stopWinLab.textColor = [UIColor colorWithRed:(106/255.0) green:(120/255.0) blue:(141/255.0) alpha:1];
        stopWinLab.textAlignment = NSTextAlignmentCenter;
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
    //-------------------------------------------------------------------------------------------------------
    //状态背景
    UIImageView *statusBg = (UIImageView *)[cell viewWithTag:BASETAG+6];
    if(statusBg==nil)
    {
        statusBg = [[UIImageView alloc] initWithFrame:CGRectMake(247, 29, 57, 18)];
        [cell addSubview:statusBg];
        statusBg.tag = BASETAG+6;
    }
    [statusBg setImage:[UIImage imageNamed:@"bk_status"]];
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG+7];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(247, 31, 57, 15)];
        statusLab.tag = BASETAG+7;
        statusLab.font = [UIFont systemFontOfSize:10];
        statusLab.textColor = [UIColor colorWithRed:(255/255.0) green:(129/255.0) blue:(28/255.0) alpha:1];
        statusLab.textAlignment = NSTextAlignmentCenter;
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
    if(indexPath.row % 2 == 1)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_infor_odd"]];
    }
    else if(indexPath.row % 2 == 0)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_infor_even"]];
    }
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
    return 77;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (zhListArr.count>0 && [zhListArr isKindOfClass:[NSArray class]])
    {
        ZhuiHaoObject *zhObj = [zhListArr objectAtIndex:indexPath.row];
        
        ZHRecordsDetailViewController *zhDetailVC = [[ZHRecordsDetailViewController alloc] init];
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
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"zhuihaoPage"];
        int curren =[current intValue];
       
        if (curren<=totalPage)
        {
            int a= curren+1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
            [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPage:pageStr];
            
        }
        else if (curren==totalPage && curren!=0)
        {
        }
        else if(curren==0)
        {
            curren=1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",curren];
            [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPage:pageStr];
        }
        
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
        if (zhListArr.count==0)
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
        [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPage:pageStr];

        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        myMessagelabel.hidden=YES;
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
        if (zhListArr.count==0)
        {
            myMessagelabel.hidden=NO;
        }
        else
        {
            myMessagelabel.hidden=YES;
        }
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state)
    {
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

-(void)datePickerSetDate:(TDDatePickerController*)viewController
{
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

-(void)datePickerClearDate:(TDDatePickerController*)viewController
{
    [self dismissSemiModalViewController:viewController];
    _selectedDate = nil;
}

-(void)datePickerCancel:(TDDatePickerController*)viewController
{
    [self dismissSemiModalViewController:viewController];
}
-(void)dealloc
{
    _starDatePickerView.delegate=nil;
    _endDatePickerView.delegate=nil;
}

//选择彩种-begin
- (IBAction)lotteryTypeClk:(id)sender
{
    lotteryTypeView.hidden = NO;
}
- (void)lotteryPicker:(LotteryPicker *)picker didSelectDateWithName:(NSString *)name
{
    lotteryText = name;
}
-(IBAction)cancelClick:(id)sender
{
    lotteryTypeView.hidden = YES;
}
-(IBAction)okClick:(id)sender
{
    lotteryTypeView.hidden = YES;
    lotteryLab.text = lotteryText;
}
//选择彩种-end

@end
