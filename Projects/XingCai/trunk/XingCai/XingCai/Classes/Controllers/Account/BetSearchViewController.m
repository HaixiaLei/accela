//
//  BetSearchViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetSearchViewController.h"
#import "BetListObject.h"
#import "PublicOfLotteryName.h"
#import "BetDetailViewController.h"

#define BASETAG1    1024

@interface BetSearchViewController ()
@end

@implementation BetSearchViewController

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
    [self loadData:startLab.text endDate:endLab.text withPageNume:@"1"];
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
    
    self.betTabelView.size = CGSizeMake(320, 359);
    self.betTabelView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_top"]];
    self.betTabelView.tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_bottom"]];
    self.betTabelView.tableHeaderView.hidden=YES;
    self.betTabelView.tableFooterView.hidden=YES;

  
    betListArr = [[NSMutableArray alloc] init];
    addArray=[[NSMutableArray alloc]init];
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60,320+(IS_IPHONE5?60:0), 200,40)];
    myMessagelabel.text=@"您暂时没有投注记录";
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
#pragma mark-
#pragma mark force to show the refresh headerView
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnBtnClk:(UIButton *)sender
{
    if(betListArr.count!=0||betListArr.count>0)
    {
        [betListArr removeAllObjects];
    }
    NSString *page=@"0";
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"betPage"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate withPageNume:(NSString *)page
{
    if (mark==YES)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mark=NO;
    }

     NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"betPage"];
     [[AppHttpManager sharedManager] gouCaiChaXunWithStartTime:[sDate stringByAppendingString:@" 02:20:00"] endTime:[eDate stringByAppendingString:@" 02:20:00"] Page:page Block:^(id JSON, NSError *error)
     {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSArray *itemArray = [JSON objectForKey:@"aProject"];
                 NSDictionary *itemAr = [JSON objectForKey:@"pageinfo"];
                 totalPage=[[itemAr objectForKey:@"TotalPages"] intValue];
//                  CurrentPage=[[itemAr objectForKey:@"CurrentPage"] intValue];
                 
                 NSString *str=@"1";
                 if ([current isEqualToString:page]||[page isEqualToString:str])
                 {
                     [betListArr removeAllObjects];
                 }
                 
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         
                         //---根据id取名字---begin
                         NSString *lotteryid = [oneObjectDict objectForKey:@"lotteryid"];
                         NSDictionary *lotteryDic = [JSON objectForKey:@"lottery"];
                         NSString *lotteryName = [lotteryDic objectForKey:lotteryid];
                         //---根据id取名字---end
                         BetListObject *betListObj = [[BetListObject alloc] initWithAttribute:oneObjectDict];
                         [betListObj setLotteryname:lotteryName];
                         [betListArr addObject:betListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
           
                 [self.betTabelView reloadData];

                     if (betListArr.count==0)
                     {
                         myMessagelabel.hidden=NO;
                         self.betTabelView.tableHeaderView.hidden=YES;
                         self.betTabelView.tableFooterView.hidden=YES;
                     }
                     else if(betListArr.count>0)
                     {
                         myMessagelabel.hidden=YES;
                         self.betTabelView.tableHeaderView.hidden=NO;
                         self.betTabelView.tableFooterView.hidden=NO;
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
    
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"betPage"];
   
}

//设置开始时间---begin
-(IBAction)startDate:(id)sender
{
    [self presentSemiModalViewController:_starDatePickerView];
}

//设置结束时间---begin
-(IBAction)endDate:(id)sender
{
    [self presentSemiModalViewController:_endDatePickerView];
}
//设置结束时间---end
-(IBAction)searchClk:(id)sender
{
    mark=YES;
    if(betListArr.count>0||betListArr.count!=0)
    {
        [betListArr removeAllObjects];
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
    //    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"betPage"];
    
    [self loadData:startLab.text endDate:endLab.text withPageNume:@"1"];
}
//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(BetListObject *)object rowInd:(NSInteger)rowIndex
{
    UILabel *issueLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(issueLab == nil)
    {
        issueLab = [[UILabel alloc] initWithFrame:CGRectMake(6, 33.5, 84, 15)];
        issueLab.tag = BASETAG1;
        issueLab.font = [UIFont systemFontOfSize:11];
        issueLab.textColor = [UIColor colorWithRed:(255/255.0) green:(130/255.0) blue:(0/255.0) alpha:1];
        issueLab.textAlignment = UITextAlignmentCenter;
        issueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:issueLab];
    }
    issueLab.text = [object issue];

    UILabel *lotterynameLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(lotterynameLab == nil)
    {
        lotterynameLab = [[UILabel alloc] initWithFrame:CGRectMake(91, 33.5, 73, 15)];
        lotterynameLab.tag = BASETAG1+1;
        lotterynameLab.font = [UIFont systemFontOfSize:11];
        lotterynameLab.textColor = [UIColor darkGrayColor];
        lotterynameLab.textAlignment = UITextAlignmentCenter;
        lotterynameLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotterynameLab];
    }
    lotterynameLab.text = [object lotteryname];
    
    UILabel *totalpriceLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(totalpriceLab == nil)
    {
        totalpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 33.5, 56, 15)];
        totalpriceLab.tag = BASETAG1+2;
        totalpriceLab.font = [UIFont systemFontOfSize:10];
        totalpriceLab.textColor = [UIColor darkGrayColor];
        totalpriceLab.textAlignment = UITextAlignmentCenter;
        totalpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:totalpriceLab];
    }
    //totalpriceLab.text = [NSString stringWithFormat:@"%.2f", [[object totalprice] floatValue]];
    totalpriceLab.text = [object totalprice];
    
    UILabel *bonusLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(bonusLab == nil)
    {
        bonusLab = [[UILabel alloc] initWithFrame:CGRectMake(222, 33.5, 56, 15)];
        bonusLab.tag = BASETAG1+3;
        bonusLab.font = [UIFont systemFontOfSize:10];
        bonusLab.textColor = [UIColor darkGrayColor];
        bonusLab.textAlignment = UITextAlignmentCenter;
        bonusLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:bonusLab];
    }
    //bonusLab.text = [NSString stringWithFormat:@"%.2f", [[object bonus] floatValue]];
    bonusLab.text = [object bonus];
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(278, 26.5, 35, 30)];
        statusLab.tag = BASETAG1+4;
        statusLab.font = [UIFont systemFontOfSize:11];
        statusLab.textColor = [UIColor darkGrayColor];
        statusLab.textAlignment = UITextAlignmentCenter;
        statusLab.backgroundColor = [UIColor clearColor];
        statusLab.lineBreakMode = UILineBreakModeWordWrap;
        statusLab.numberOfLines = 0;
        [cell addSubview:statusLab];
    }
    if ([[object iscancel] isEqualToString:@"1"])
    {
        statusLab.text = @"本人撤单";
    }
    else if ([[object iscancel] isEqualToString:@"2"])
    {
        statusLab.text = @"平台撤单";
    }
    else if ([[object iscancel] isEqualToString:@"3"])
    {
        statusLab.text = @"错开撤单";
    }
    else if ([[object iscancel] isEqualToString:@"0"])
    {
        if ([[object isgetprize] isEqualToString:@"0"])
        {
            statusLab.text = @"未开奖";
        }
        else if ([[object isgetprize] isEqualToString:@"2"])
        {
            statusLab.text = @"未中奖";
        }
        else
        {
            if ([[object prizestatus] isEqualToString:@"0"])
            {
                statusLab.text = @"未派奖";
            }
            else
            {
                statusLab.text = @"已派奖";
            }
        }
    }
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    DDLogDebug(@"[betListArr count]----%d",[betListArr count]);
    return [betListArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_middleshort"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    if (betListArr.count>0 && [betListArr isKindOfClass:[NSArray class]])
    {
        myMessagelabel.hidden=YES;
        BetListObject *betObj = [betListArr objectAtIndex:indexPath.row];
        [self modelCellFill:cell Object:betObj rowInd:[indexPath row]];
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
    if (betListArr.count>0 && [betListArr isKindOfClass:[NSArray class]])
    {
        BetListObject *betObj = [betListArr objectAtIndex:indexPath.row];
        
        BetDetailViewController *betDetailVC = [[BetDetailViewController alloc] init];
        betDetailVC.projectID = [betObj projectid];
        [self.navigationController pushViewController:betDetailVC animated:YES];
    }
}
//tableView-end

- (void)addFooter
{
    __unsafe_unretained BetSearchViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.betTabelView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"betPage"];
        int curren =[current intValue];
        
        if (curren<totalPage)
        {
            int a= curren+1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
            [self loadData:startLab.text endDate:endLab.text withPageNume:pageStr];
        }
        else if (curren==totalPage&&curren!=0){}
        else if(curren==0)
        {
            curren=1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",curren];
            [self loadData:startLab.text endDate:endLab.text withPageNume:pageStr];
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
        if (betListArr.count==0)
        {
            myMessagelabel.hidden=NO;
            self.betTabelView.tableFooterView.hidden=YES;
            self.betTabelView.tableHeaderView.hidden=YES;
        }
        else
        {
            myMessagelabel.hidden=YES;
            self.betTabelView.tableFooterView.hidden=NO;
            self.betTabelView.tableHeaderView.hidden=NO;
        }
    };
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained BetSearchViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.betTabelView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 进入刷新状态就会回调这个Block

//        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"betPage"];
//        int curren =[current intValue];
//       
//        if (curren<totalPage) {
//            int a= curren+1;
//            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
//            [self loadData:startLab.text endDate:endLab.text withPageNume:pageStr];
//            
//        }else if (curren==totalPage&&curren!=0)
//        {
//          
//        }else if(curren==0){
//            curren=1;
//            NSString *pageStr =[NSString stringWithFormat:@"%d",curren];
//            [self loadData:startLab.text endDate:endLab.text withPageNume:pageStr];
//            
//        }
        NSString *pageStr =@"1";
        [self loadData:startLab.text endDate:endLab.text withPageNume:pageStr];

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
        if (betListArr.count==0)
        {
            myMessagelabel.hidden=NO;
            self.betTabelView.tableFooterView.hidden=YES;
            self.betTabelView.tableHeaderView.hidden=YES;

        }
        else
        {
             myMessagelabel.hidden=YES;
            self.betTabelView.tableFooterView.hidden=NO;
            self.betTabelView.tableHeaderView.hidden=NO;
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
    [self.betTabelView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
-(void)dealloc
{
    _starDatePickerView.delegate=nil;
    
    _endDatePickerView.delegate=nil;
}

@end
