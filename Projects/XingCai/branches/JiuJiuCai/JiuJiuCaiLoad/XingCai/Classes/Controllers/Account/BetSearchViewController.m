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
#define kTagCellBackView 86181

@interface BetSearchViewController ()
@end

@implementation BetSearchViewController
@synthesize dateLab;
@synthesize bannerView;
@synthesize pv;

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
    if ([dateLab.text isEqualToString:@"今天"])
    {
        [self loadData:startDate endDate:endDate lotteryid:lotteryTypeStr withPageNume:@"1"];
    }
    else
    {
        [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:@"1"];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置默认全部彩种
    lotteryTypeStr = @"0";
    lotteryText = @"全部";
    lotteryArray = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    subLotteryArr = [[NSMutableArray alloc] initWithObjects:@"重庆", @"印尼", nil];
    [lotteryArray addObjectsFromArray:subLotteryArr];
    [self.lp setDates:lotteryArray];
    [self.lp reloadAllComponents];
    self.lotteryLab.text = [lotteryArray objectAtIndex:0];
    
    //设置默认开始时间和结束时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *today = [formatter stringFromDate:date];
    startDate = today;
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    timeInterval += 24 * 60 * 60;
    NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *endtime = [formatter stringFromDate:tomorrowDate];
    endDate = endtime;
//    if (!IS_IPHONE5)
//    {
        self.betTabelView.size = CGSizeMake(320, 440);
//    }

    mark=NO;
    betListArr = [[NSMutableArray alloc] init];
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60,240+(IS_IPHONE5?60:0), 200,40)];
    myMessagelabel.text=@"您暂时没有投注记录";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor grayColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myMessagelabel];
    
    dateArray = [[NSArray alloc] initWithObjects:@"今天",@"近一周",@"近一个月",@"近三个月", nil];
    [self.pv setDates:dateArray];
    [self.pv reloadAllComponents];
    dateLab.text = [dateArray objectAtIndex:0];
}

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

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate lotteryid:(NSString *)lotteryid withPageNume:(NSString *)page
{
    if (mark==YES)
    {
        myMessagelabel.hidden=YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

     NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"betPage"];
    
     [[AppHttpManager sharedManager] gouCaiChaXunWithStartTime:[sDate stringByAppendingString:@" 00:00:00"] endTime:[eDate stringByAppendingString:@" 23:59:59"] lotteryid:lotteryid Page:page Block:^(id JSON, NSError *error)
     {
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSArray *itemArray = [JSON objectForKey:@"aProject"];
                 NSDictionary *itemAr = [JSON objectForKey:@"pageinfo"];
                 totalPage=[[itemAr objectForKey:@"TotalPages"] intValue];
                 CurrentPage=[[itemAr objectForKey:@"CurrentPage"] intValue];
//                 NSLog(@"%@",itemArray);
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
                     if (betListArr.count==0&&mark==YES)
                     {
                         myMessagelabel.hidden=NO;
                     }
                     else if(betListArr.count>0&&mark==YES)
                     {
                         myMessagelabel.hidden=YES;
                     }
                  mark=NO;
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
//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(BetListObject *)object rowInd:(NSInteger)rowIndex
{
    UILabel *titleLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(titleLab == nil)
    {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 100, 20)];
        titleLab.tag = BASETAG1;
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.textColor = [UIColor colorWithRed:(255/225.0) green:(90/255.0) blue:(0/255.0) alpha:1];
        titleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLab];
    }
    titleLab.text = [object lotteryname];
    
    UILabel *beginIssueLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(beginIssueLab == nil)
    {
        beginIssueLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 14, 120, 20)];
        beginIssueLab.tag = BASETAG1+1;
        beginIssueLab.font = [UIFont systemFontOfSize:13];
        beginIssueLab.textColor = [UIColor colorWithRed:(60/255.0) green:(60/255.0) blue:(60/255.0) alpha:1];
        beginIssueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:beginIssueLab];
    }
    beginIssueLab.text = [[@"第" stringByAppendingString:[object issue]] stringByAppendingString:@"期"];
    
    UILabel *totalPriceLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(totalPriceLab == nil)
    {
        totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, 60, 20)];
        totalPriceLab.tag = BASETAG1+2;
        totalPriceLab.font = [UIFont systemFontOfSize:13];
        totalPriceLab.textColor = [UIColor colorWithRed:(60/255.0) green:(60/255.0) blue:(60/255.0) alpha:1];
        totalPriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:totalPriceLab];
    }
    totalPriceLab.text = @"投注金额:";
    
    UILabel *taskpriceLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(taskpriceLab == nil)
    {
        taskpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 39, 100, 20)];
        taskpriceLab.tag = BASETAG1+3;
        taskpriceLab.font = [UIFont systemFontOfSize:13];
        taskpriceLab.textColor = [UIColor darkGrayColor];
        taskpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:taskpriceLab];
    }
    taskpriceLab.text = [object totalprice];
    
    UIImageView *imgV1 = (UIImageView *)[cell viewWithTag:BASETAG1+6];
    if(imgV1==nil)
    {
        imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(228, 35, 60, 25)];
        [cell addSubview:imgV1];
        imgV1.tag = BASETAG1+6;
    }
    [imgV1 setImage:[UIImage imageNamed:@"tag_prize_bk"]];
    
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG1+7];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(230, 37, 55, 20)];
        statusLab.tag = BASETAG1+7;
        statusLab.font = [UIFont systemFontOfSize:12];
        statusLab.textColor = [UIColor colorWithRed:(255/255.0) green:(107/255.0) blue:(107/255.0) alpha:1];
        statusLab.textAlignment = NSTextAlignmentCenter;
        statusLab.backgroundColor = [UIColor clearColor];
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
    
    UILabel *finishPriceTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+8];
    if(finishPriceTitleLab == nil)
    {
        finishPriceTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 62, 35, 20)];
        finishPriceTitleLab.tag = BASETAG1+8;
        finishPriceTitleLab.font = [UIFont systemFontOfSize:13];
        finishPriceTitleLab.textColor = [UIColor colorWithRed:(60/255.0) green:(60/255.0) blue:(60/255.0) alpha:1];
        finishPriceTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:finishPriceTitleLab];
    }
    finishPriceTitleLab.text = @"奖金:";
    
    UILabel *finishpriceLab = (UILabel *)[cell viewWithTag:BASETAG1+9];
    if(finishpriceLab == nil)
    {
        finishpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 62, 100, 20)];
        finishpriceLab.tag = BASETAG1+9;
        finishpriceLab.font = [UIFont systemFontOfSize:13];
        finishpriceLab.textColor = [UIColor darkGrayColor];
        finishpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:finishpriceLab];
    }
    finishpriceLab.text = [object bonus];
    
    UILabel *timeLab = (UILabel *)[cell viewWithTag:BASETAG1+10];
    if(timeLab == nil)
    {
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 62, 140, 20)];
        timeLab.tag = BASETAG1+10;
        timeLab.font = [UIFont systemFontOfSize:13];
        timeLab.textColor = [UIColor darkGrayColor];
        timeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:timeLab];
    }
    timeLab.text = [object writetime];
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    DDLogDebug(@"[betListArr count]----%d",[betListArr count]);
    return [betListArr count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_content_click"]];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row != [betListArr count])
    {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_content_click"]];
        bgImageView.tag = kTagCellBackView;
        bgImageView.point = CGPointMake(0, 10);
        BOOL alreadyHave = NO;
        for (UIView *view in cell.subviews)
        {
            if (view.tag == kTagCellBackView)
            {
                alreadyHave = YES;
                break;
            }
        }
        if (!alreadyHave)
        {
            [cell insertSubview:bgImageView atIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //去掉UITableView中cell的边框和分割线
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        if (betListArr.count>0 && [betListArr isKindOfClass:[NSArray class]])
        {
            myMessagelabel.hidden=YES;
            BetListObject *betObj = [betListArr objectAtIndex:indexPath.row];
            [self modelCellFill:cell Object:betObj rowInd:[indexPath row]];
        }
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
    if (indexPath.row == [betListArr count])
    {
        return 10;
    }
    else
    {
        return 76+10;
    }
}
//某行已经被选中时调用
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
            if ([self.dateLab.text isEqualToString:@"今天"])
            {
                [self loadData:startDate endDate:endDate lotteryid:lotteryTypeStr withPageNume:pageStr];
            }
            else
            {
                [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:pageStr];
            }
        }
        else if (curren==totalPage&&curren!=0)
        {
            
        }
        else if(curren==0)
        {
            curren=1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",curren];
            if ([self.dateLab.text isEqualToString:@"今天"])
            {
                [self loadData:startDate endDate:endDate lotteryid:lotteryTypeStr withPageNume:pageStr];
            }
            else
            {
                [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:pageStr];
            }
        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        myMessagelabel.hidden=YES;
    };
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
        if (betListArr.count==0)
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
    __unsafe_unretained BetSearchViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.betTabelView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 进入刷新状态就会回调这个Block

        //NSLog(@"%@========%@",startDate,endDate);
        NSString *pageStr =@"1";
       
        if ([self.dateLab.text isEqualToString:@"今天"])
        {
            [self loadData:startDate endDate:endDate lotteryid:lotteryTypeStr withPageNume:pageStr];
        }
        else
        {
            [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:pageStr];
        }

        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
         myMessagelabel.hidden=YES;
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
        if (betListArr.count==0)
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
        switch (state)
        {
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
    [self.betTabelView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (IBAction)selectDate:(id)sender
{
    bannerView.hidden = NO;
}

-(void)searchByDate
{
    mark=YES;
    if(betListArr.count>0||betListArr.count!=0)
    {
        [betListArr removeAllObjects];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([self.lotteryLab.text isEqualToString:@"重庆"])
    {
        lotteryTypeStr = @"1";
    }
    else if ([self.lotteryLab.text isEqualToString:@"印尼"])
    {
        lotteryTypeStr = @"14";
    }
    else
    {
        lotteryTypeStr = @"0";
    }
    
    if ([self.dateLab.text isEqualToString:@"今天"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval += 24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSString *endtime = [formatter stringFromDate:tomorrowDate];
        endDate = endtime;
        
        [self loadData:startDate endDate:endDate lotteryid:lotteryTypeStr withPageNume:@"1"];
    }
    else if ([self.dateLab.text isEqualToString:@"近一周"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval -= 6*24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        endDate = [formatter stringFromDate:tomorrowDate];
        
        [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:@"1"];
    }
    else if ([self.dateLab.text isEqualToString:@"近一个月"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval -= 30*24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        endDate = [formatter stringFromDate:tomorrowDate];
        
        [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:@"1"];
    }
    else if ([self.dateLab.text isEqualToString:@"近三个月"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval -= 90*24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        endDate = [formatter stringFromDate:tomorrowDate];
        [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:@"1"];
    }
}
- (IBAction)okClick:(id)sender
{
    bannerView.hidden = YES;
    [self searchByDate];
}
- (void)betPicker:(BetPicker *)picker didSelectDateWithName:(NSString *)name
{
    dateLab.text = name;
}

//选择彩种-begin
- (IBAction)lotteryTypeClk:(id)sender
{
    self.lotteryTypeView.hidden = NO;
}
- (void)lotteryPicker:(LotteryPicker *)picker didSelectDateWithName:(NSString *)name
{
    lotteryText = name;
    if ([name isEqualToString:@"重庆"]) {
        lotteryTypeStr=@"1";
    }else if ([name isEqualToString:@"印尼"])
    {
        lotteryTypeStr=@"14";
    }else
    {
        lotteryTypeStr=@"0";
    }
}
-(IBAction)cancel2Click:(id)sender
{
    self.lotteryTypeView.hidden = YES;
}
-(IBAction)ok2Click:(id)sender
{
    self.lotteryTypeView.hidden = YES;
    self.lotteryLab.text = lotteryText;
    if ([dateLab.text isEqualToString:@"今天"])
    {
        [self loadData:startDate endDate:endDate lotteryid:lotteryTypeStr withPageNume:@"1"];
    
    }
    else
    {
        [self loadData:endDate endDate:startDate lotteryid:lotteryTypeStr withPageNume:@"1"];
        
    }

}
//选择彩种-end
@end
