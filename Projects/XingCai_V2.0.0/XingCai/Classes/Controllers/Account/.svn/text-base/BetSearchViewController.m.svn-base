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
#import "UIViewController+CustomNavigationBar.h"

#define BASETAG1    1024

@interface BetSearchViewController ()
@end

@implementation BetSearchViewController
@synthesize startLab;
@synthesize endLab;
@synthesize titleImg;
@synthesize lotteryTypeLab;
@synthesize priceLab;
@synthesize bonusLabel;
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
    [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPageNume:@"1"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBarTitle:@"投注查询" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    
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
    
    //self.betTabelView.size = CGSizeMake(320, 359);

    betListArr = [[NSMutableArray alloc] init];
    addArray=[[NSMutableArray alloc] init];
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
    myMessagelabel.text=@"您暂时没有投注记录!";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor grayColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = NSTextAlignmentCenter;
    [self.betTabelView addSubview:myMessagelabel];
    
    
    _starDatePickerView=[[TDDatePickerController alloc] init];
    _starDatePickerView.delegate=self;
    
    _endDatePickerView=[[TDDatePickerController alloc] init];
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
        if (viewController==_starDatePickerView)
        {
            startLab.text= [fmt stringFromDate:_selectedDate];
        }
        else
        {
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

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate lotteryid:(NSString *)lotteryid withPageNume:(NSString *)page
{
    if (mark==YES)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mark=NO;
    }

     NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"betPage"];
     [[AppHttpManager sharedManager] gouCaiChaXunWithStartTime:[sDate stringByAppendingString:@" 02:00:00"] endTime:[eDate stringByAppendingString:@" 02:00:00"] lotteryid:lotteryid Page:page Block:^(id JSON, NSError *error)
     {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSArray *itemArray = [JSON objectForKey:@"aProject"];
                 NSDictionary *itemAr = [JSON objectForKey:@"pageinfo"];
                 totalPage=[[itemAr objectForKey:@"TotalPages"] intValue];
                 
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
                         
                         titleImg.hidden=YES;
                         lotteryTypeLab.hidden=YES;
                         priceLab.hidden=YES;
                         bonusLabel.hidden=YES;
                         statusLabel.hidden=YES;
                         bannerImg.hidden=YES;
                     }
                     else if(betListArr.count>0)
                     {
                         myMessagelabel.hidden=YES;
                         
                         titleImg.hidden=NO;
                         lotteryTypeLab.hidden=NO;
                         priceLab.hidden=NO;
                         bonusLabel.hidden=NO;
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
    
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"betPage"];
}

//设置开始时间---begin
-(IBAction)startDate:(id)sender
{
    [self presentSemiModalViewController:_starDatePickerView];
}
//设置开始时间---end

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
    //    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"betPage"];
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
    [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPageNume:@"1"];
}
//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(BetListObject *)object rowInd:(NSInteger)rowIndex
{
    //彩种图片
    UIImageView *lotteryImg = (UIImageView *)[cell viewWithTag:BASETAG1];
    if(lotteryImg==nil)
    {
        lotteryImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 5, 36, 36)];
        [cell addSubview:lotteryImg];
        lotteryImg.tag = BASETAG1;
    }
    if ([[object lotteryid] isEqualToString:@"1"])
    {
        [lotteryImg setImage:[UIImage imageNamed:@"icon_cq"]];
    }
    else if ([[object lotteryid] isEqualToString:@"14"])
    {
        [lotteryImg setImage:[UIImage imageNamed:@"icon_henei"]];
    }
    
    UILabel *lotterynameLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(lotterynameLab == nil)
    {
        lotterynameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 72, 15)];
        lotterynameLab.tag = BASETAG1+1;
        lotterynameLab.font = [UIFont systemFontOfSize:10];
        lotterynameLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        lotterynameLab.textAlignment = NSTextAlignmentCenter;
        lotterynameLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotterynameLab];
    }
    lotterynameLab.text = [object lotteryname];
    
    UILabel *issueLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(issueLab == nil)
    {
        issueLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, 72, 15)];
        issueLab.tag = BASETAG1+2;
        issueLab.font = [UIFont systemFontOfSize:9];
        issueLab.textColor = [UIColor colorWithRed:(106/255.0) green:(120/255.0) blue:(141/255.0) alpha:1];
        issueLab.textAlignment = NSTextAlignmentCenter;
        issueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:issueLab];
    }
    issueLab.text = [object issue];

    UILabel *totalpriceLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(totalpriceLab == nil)
    {
        totalpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(72, 31, 78, 15)];
        totalpriceLab.tag = BASETAG1+3;
        totalpriceLab.font = [UIFont systemFontOfSize:10];
        totalpriceLab.textColor = [UIColor colorWithRed:(244/255.0) green:(58/255.0) blue:(58/255.0) alpha:1];
        totalpriceLab.textAlignment = NSTextAlignmentCenter;
        totalpriceLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:totalpriceLab];
    }
    //totalpriceLab.text = [NSString stringWithFormat:@"%.2f", [[object totalprice] floatValue]];
    totalpriceLab.text = [object totalprice];
    
    UILabel *bonusLab = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(bonusLab == nil)
    {
        bonusLab = [[UILabel alloc] initWithFrame:CGRectMake(150, 31, 79, 15)];
        bonusLab.tag = BASETAG1+4;
        bonusLab.font = [UIFont systemFontOfSize:10];
        bonusLab.textColor = [UIColor colorWithRed:(106/255.0) green:(120/255.0) blue:(141/255.0) alpha:1];
        bonusLab.textAlignment = NSTextAlignmentCenter;
        bonusLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:bonusLab];
    }
    //bonusLab.text = [NSString stringWithFormat:@"%.2f", [[object bonus] floatValue]];
    bonusLab.text = [object bonus];
    
    //状态背景
    UIImageView *statusBg = (UIImageView *)[cell viewWithTag:BASETAG1+5];
    if(statusBg==nil)
    {
        statusBg = [[UIImageView alloc] initWithFrame:CGRectMake(243, 29, 50, 18)];
        [cell addSubview:statusBg];
        statusBg.tag = BASETAG1+5;
    }
    [statusBg setImage:[UIImage imageNamed:@"bk_status"]];
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG1+6];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(230, 31, 75, 15)];
        statusLab.tag = BASETAG1+6;
        statusLab.font = [UIFont systemFontOfSize:10];
        statusLab.textColor = [UIColor colorWithRed:(255/255.0) green:(129/255.0) blue:(28/255.0) alpha:1];
        statusLab.textAlignment = NSTextAlignmentCenter;
        statusLab.backgroundColor = [UIColor clearColor];
//        statusLab.lineBreakMode = NSLineBreakByWordWrapping;
//        statusLab.numberOfLines = 0;
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
    return 77;
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
        
        if (curren<=totalPage)
        {
            int a= curren+1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
            [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPageNume:pageStr];
        }
        else if (curren==totalPage&&curren!=0){}
        else if(curren==0)
        {
            curren=1;
            NSString *pageStr =[NSString stringWithFormat:@"%d",curren];
            [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPageNume:pageStr];
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
        [self loadData:startLab.text endDate:endLab.text lotteryid:lotteryTypeStr withPageNume:pageStr];

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
    [self.betTabelView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
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
