//
//  ATMViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ATMViewController.h"
#import "AtmListObject.h"
#import "PublicOfLotteryName.h"

#define BASETAG1    1024
#define kTagCellBackView 86181

@interface ATMViewController ()
@end

@implementation ATMViewController
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
        [self loadData:startDate endDate:endDate withPage:@"1"];
    }
    else
    {
        [self loadData:endDate endDate:startDate withPage:@"1"];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        self.atmTableView.size = CGSizeMake(320, 440);
//    }
    
    atmListArr = [[NSMutableArray alloc] init];
    addArray =[[NSMutableArray alloc]init];
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60,240+(IS_IPHONE5?60:0), 200,40)];
    myMessagelabel.text=@"您暂时没有充提记录";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor grayColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:myMessagelabel];
    
    dateArray = [[NSArray alloc] initWithObjects:@"今天",@"近一周",@"近一个月",@"近三个月", nil];
    [self.pv setDates:dateArray];
    [self.pv reloadAllComponents];
    dateLab.text = [dateArray objectAtIndex:0];
    bannerView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBtnClk:(UIButton *)sender
{
    if(atmListArr.count!=0||atmListArr.count > 0)
    {
        [atmListArr removeAllObjects];
    }
    
    NSString *page = @"0";
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"atmPage"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate withPage:(NSString *)page
{
    if (mark==YES)
    {
        myMessagelabel.hidden=YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"atmPage"];
    [[AppHttpManager sharedManager] chongTiChaXunWithStartTime:[sDate stringByAppendingString:@" 00:00:00"] endTime:[eDate stringByAppendingString:@" 23:59:59"] Page:page Block:^(id JSON, NSError *error)
     {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSArray *itemArray = [JSON objectForKey:@"orders"];
                 NSDictionary *itemAr = [JSON objectForKey:@"pageinfo"];
                 totalPage=[[itemAr objectForKey:@"TotalPages"] intValue];
                
                 CurrentPage=[[itemAr objectForKey:@"CurrentPage"] intValue];
//                  NSLog(@"%@--%d---%d",page,totalPage,CurrentPage);
                 if ([current isEqualToString:page]||[page isEqualToString:@"1"])
                 {
                     [atmListArr removeAllObjects];
                 }

                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         AtmListObject *atmListObj = [[AtmListObject alloc] initWithAttribute:oneObjectDict];
                         [atmListArr addObject:atmListObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
               
                 [self.atmTableView reloadData];
              
                 if (atmListArr.count==0&&mark==YES)
                 {
                     myMessagelabel.hidden=NO;
                 }
                 else if(atmListArr.count>0&&mark==YES)
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
             DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
    
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"atmPage"];
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(AtmListObject *)object rowInd:(NSInteger)rowIndex
{
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(typeLab == nil)
    {
        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 18, 70, 20)];
        typeLab.tag = BASETAG1;
        typeLab.font = [UIFont systemFontOfSize:13];
        typeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(174/255.0) blue:(0/255.0) alpha:1];
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    typeLab.text = [object cntitle];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(dateLabel == nil)
    {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 18, 135, 20)];
        dateLabel.tag = BASETAG1+1;
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:dateLabel];
    }
    dateLabel.text = [object times];
    
    UILabel *moneyLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(moneyLab == nil)
    {
        moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 44, 135, 20)];
        moneyLab.tag = BASETAG1+2;
        moneyLab.font = [UIFont systemFontOfSize:13];
        moneyLab.textColor = [UIColor whiteColor];
        moneyLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:moneyLab];
    }
    if ([[object cntitle] isEqualToString:@"提款申请"])
    {
        moneyLab.text = [@"-" stringByAppendingString:[object amount]];
    }
    else
    {
        moneyLab.text = [@"+" stringByAppendingString:[object amount]];
    }
    
    UILabel *yeTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(yeTitleLab == nil)
    {
        yeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(170, 44, 30, 20)];
        yeTitleLab.tag = BASETAG1+33;
        yeTitleLab.font = [UIFont systemFontOfSize:13];
        yeTitleLab.textColor = [UIColor colorWithRed:(255/255.0) green:(174/255.0) blue:(0/255.0) alpha:1];
        yeTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:yeTitleLab];
    }
    yeTitleLab.text = @"余额:";
    
    UILabel *yeLab = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(yeLab == nil)
    {
        yeLab = [[UILabel alloc] initWithFrame:CGRectMake(205, 44, 100, 20)];
        yeLab.tag = BASETAG1+4;
        yeLab.font = [UIFont systemFontOfSize:13];
        yeLab.textColor = [UIColor whiteColor];
        yeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:yeLab];
    }
    yeLab.text = [object availablebalance];
    
    UILabel *noTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+5];
    if(noTitleLab == nil)
    {
        noTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 73, 30, 20)];
        noTitleLab.tag = BASETAG1+5;
        noTitleLab.font = [UIFont systemFontOfSize:13];
        noTitleLab.textColor = [UIColor colorWithRed:(253/255.0) green:(138/255.0) blue:(37/255.0) alpha:1];
        noTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:noTitleLab];
    }
    noTitleLab.text = @"编号:";
    
    //绿色背景条
    UITextField *greenFld = (UITextField *)[cell viewWithTag:BASETAG1+6];
    if(greenFld == nil)
    {
        greenFld = [[UITextField alloc] initWithFrame:CGRectMake(57, 70, 175, 25)];
        greenFld.tag = BASETAG1+6;
        greenFld.backgroundColor = [UIColor colorWithRed:(126/255.0) green:(215/255.0) blue:(172/255.0) alpha:1];
        greenFld.borderStyle = UITextBorderStyleRoundedRect;
        greenFld.enabled = FALSE;
        [cell addSubview:greenFld];
    }
    
    UILabel *noLab = (UILabel *)[cell viewWithTag:BASETAG1+7];
    if(noLab == nil)
    {
        noLab = [[UILabel alloc] initWithFrame:CGRectMake(58, 72, 173, 20)];
        noLab.tag = BASETAG1+7;
        noLab.font = [UIFont systemFontOfSize:13];
        noLab.textColor = [UIColor blackColor];
        noLab.backgroundColor = [UIColor clearColor];
        noLab.textAlignment = UITextAlignmentCenter;
        [cell addSubview:noLab];
    }
    noLab.text = [object orderno];
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG1+8];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(260, 73, 35, 20)];
        statusLab.tag = BASETAG1+8;
        statusLab.font = [UIFont systemFontOfSize:13];
        statusLab.textColor = [UIColor colorWithRed:(255/255.0) green:(174/255.0) blue:(0/255.0) alpha:1];
        statusLab.backgroundColor = [UIColor clearColor];
        statusLab.textAlignment = UITextAlignmentRight;
        [cell addSubview:statusLab];
    }
    if ([[object transferstatus] isEqualToString:@"1"] || [[object transferstatus] isEqualToString:@"3"])
    {
        statusLab.text = @"失败";
    }
    else
    {
        statusLab.text = @"成功";
    }
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [atmListArr count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_chongti"]];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row != [atmListArr count])
    {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_chongti"]];
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
        if (atmListArr.count>0 && [atmListArr isKindOfClass:[NSArray class]])
        {
            myMessagelabel.hidden=YES;
            AtmListObject *atmObj = [atmListArr objectAtIndex:indexPath.row];
            [self modelCellFill:cell Object:atmObj rowInd:[indexPath row]];
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
    if (indexPath.row == [atmListArr count])
    {
        return 10;
    }
    else
    {
        return 94 + 10;
    }
}
//tableView-end

- (void)addFooter
{
    __unsafe_unretained ATMViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.atmTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"atmPage"];
        int curren =[current intValue];
        
        if (curren<totalPage)
        {
            int a= curren+1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
            if ([self.dateLab.text isEqualToString:@"今天"])
            {
                [self loadData:startDate endDate:endDate withPage:pageStr];
            }
            else
            {
                [self loadData:endDate endDate:startDate withPage:pageStr];
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
                [self loadData:startDate endDate:endDate withPage:pageStr];
            }
            else
            {
                [self loadData:endDate endDate:startDate withPage:pageStr];
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
        if (atmListArr.count==0)
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
    __unsafe_unretained ATMViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.atmTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 进入刷新状态就会回调这个Block
        NSString *pageStr =@"1";
        if ([self.dateLab.text isEqualToString:@"今天"])
        {
            [self loadData:startDate endDate:endDate withPage:pageStr];
        }
        else
        {
            [self loadData:endDate endDate:startDate withPage:pageStr];
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
        if (atmListArr.count==0)
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
    [self.atmTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
- (IBAction)selectDate:(id)sender
{
    bannerView.hidden = NO;
}

-(void)searchByDate
{
    if(atmListArr.count>0||atmListArr.count!=0)
    {
        [atmListArr removeAllObjects];
    }
    
    myMessagelabel.hidden=YES;
    mark=YES;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([self.dateLab.text isEqualToString:@"今天"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval += 24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSString *endtime = [formatter stringFromDate:tomorrowDate];
        endDate = endtime;
        
        [self loadData:startDate endDate:endDate withPage:@"1"];
    }
    else if ([self.dateLab.text isEqualToString:@"近一周"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval -= 6*24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        endDate = [formatter stringFromDate:tomorrowDate];
        
        [self loadData:endDate endDate:startDate withPage:@"1"];
    }
    else if ([self.dateLab.text isEqualToString:@"近一个月"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval -= 30*24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        endDate = [formatter stringFromDate:tomorrowDate];
        
        [self loadData:endDate endDate:startDate withPage:@"1"];
    }
    else if ([self.dateLab.text isEqualToString:@"近三个月"])
    {
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        timeInterval -= 90*24 * 60 * 60;
        NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        endDate = [formatter stringFromDate:tomorrowDate];
        [self loadData:endDate endDate:startDate withPage:@"1"];
    }

}
-(IBAction)okClick:(id)sender
{
    bannerView.hidden = YES;
    [self searchByDate];
}
- (void)atmPicker:(AtmPicker *)picker didSelectDateWithName:(NSString *)name
{
    dateLab.text = name;
}
@end
