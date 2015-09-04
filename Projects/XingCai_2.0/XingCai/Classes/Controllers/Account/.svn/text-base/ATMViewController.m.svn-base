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
#import "UIViewController+CustomNavigationBar.h"

#define BASETAG    1024

@interface ATMViewController ()
@end

@implementation ATMViewController
@synthesize startLab;
@synthesize endLab;
@synthesize bannerImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBarTitle:@"充提记录" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    
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
    
    //self.atmTableView.size = CGSizeMake(320, 383);

    atmListArr = [[NSMutableArray alloc] init];
    addArray =[[NSMutableArray alloc]init];
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    if (!IS_IPHONE5)
    {
        myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 120, 200, 20)];
    }
    else
    {
        myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 170, 200, 20)];
    }
    myMessagelabel.text=@"您暂时没有充提记录!";
    myMessagelabel.hidden=YES;
    myMessagelabel.font = [UIFont systemFontOfSize:16.0f];
    myMessagelabel.textColor = [UIColor grayColor];
    myMessagelabel.backgroundColor = [UIColor clearColor];
    myMessagelabel.textAlignment = NSTextAlignmentCenter;
    [self.atmTableView addSubview:myMessagelabel];
    
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

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate withPage:(NSString *)page
{
    if (mark==YES)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mark=NO;
    }

    NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"atmPage"];
    
    [[AppHttpManager sharedManager] chongTiChaXunWithStartTime:[sDate stringByAppendingString:@" 02:20:00"] endTime:[eDate stringByAppendingString:@" 02:20:00"] Page:page Block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSArray *itemArray = [JSON objectForKey:@"orders"];
                 NSDictionary *itemAr = [JSON objectForKey:@"pageinfo"];
                 totalPage=[[itemAr objectForKey:@"TotalPages"] intValue];
                
                 //CurrentPage=[[itemAr objectForKey:@"CurrentPage"] intValue];
                 //NSLog(@"%@--%d---%d",page,totalPage,CurrentPage);
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
                 //DLog(@"%@--",atmListArr);
                 [self.atmTableView reloadData];
                
                 if (atmListArr.count==0)
                 {
                     myMessagelabel.hidden=NO;
                     bannerImg.hidden = YES;
                 }
                 else if(atmListArr.count>0)
                 {
                     myMessagelabel.hidden=YES;
                     bannerImg.hidden = NO;
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
    
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"atmPage"];
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(AtmListObject *)object rowInd:(NSInteger)rowIndex
{
    //背景图
    UIImageView *bgImg = (UIImageView *)[cell viewWithTag:BASETAG];
    if(bgImg==nil)
    {
        bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
        [cell addSubview:bgImg];
        bgImg.tag = BASETAG;
    }
    [bgImg setImage:[UIImage imageNamed:@"bk_form_fram"]];
    //-------------------------------------------------------------------------------------------------------
    UILabel *timeTitleLab = (UILabel *)[cell viewWithTag:BASETAG+1];
    if(timeTitleLab == nil)
    {
        timeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 30, 15)];
        timeTitleLab.tag = BASETAG+1;
        timeTitleLab.font = [UIFont systemFontOfSize:11];
        timeTitleLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        timeTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:timeTitleLab];
    }
    timeTitleLab.text = @"时间:";
    
    UILabel *timeLab = (UILabel *)[cell viewWithTag:BASETAG+2];
    if(timeLab == nil)
    {
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 120, 15)];
        timeLab.tag = BASETAG+2;
        timeLab.font = [UIFont systemFontOfSize:11];
        timeLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        timeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:timeLab];
    }
    timeLab.text = [object times];
    //-------------------------------------------------------------------------------------------------------
    UILabel *noTitleLab = (UILabel *)[cell viewWithTag:BASETAG+3];
    if(noTitleLab == nil)
    {
        noTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 30, 15)];
        noTitleLab.tag = BASETAG+3;
        noTitleLab.font = [UIFont systemFontOfSize:11];
        noTitleLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        noTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:noTitleLab];
    }
    noTitleLab.text = @"编号:";
    
    UILabel *noLab = (UILabel *)[cell viewWithTag:BASETAG+4];
    if(noLab == nil)
    {
        noLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 38, 120, 15)];
        noLab.tag = BASETAG+4;
        noLab.font = [UIFont systemFontOfSize:11];
        noLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        noLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:noLab];
    }
    noLab.text = [object orderno];
    //-------------------------------------------------------------------------------------------------------
    UILabel *statusTitleLab = (UILabel *)[cell viewWithTag:BASETAG+5];
    if(statusTitleLab == nil)
    {
        statusTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 68, 30, 15)];
        statusTitleLab.tag = BASETAG+5;
        statusTitleLab.font = [UIFont systemFontOfSize:11];
        statusTitleLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        statusTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:statusTitleLab];
    }
    statusTitleLab.text = @"状态:";
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG+6];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 68, 120, 15)];
        statusLab.tag = BASETAG+6;
        statusLab.font = [UIFont systemFontOfSize:11];
        statusLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        statusLab.backgroundColor = [UIColor clearColor];
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
    //-------------------------------------------------------------------------------------------------------
    UILabel *shouRuLab = (UILabel *)[cell viewWithTag:BASETAG+7];
    if(shouRuLab == nil)
    {
        shouRuLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 30, 15)];
        shouRuLab.tag = BASETAG+7;
        shouRuLab.font = [UIFont systemFontOfSize:11];
        shouRuLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        shouRuLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:shouRuLab];
    }
    if ([[object cntitle] isEqualToString:@"提款申请"])
    {
        shouRuLab.text = @"支出:";
    }
    else
    {
        shouRuLab.text = @"收入:";
    }
    
    UILabel *shouRuValueLab = (UILabel *)[cell viewWithTag:BASETAG+8];
    if(shouRuValueLab == nil)
    {
        shouRuValueLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 120, 15)];
        shouRuValueLab.tag = BASETAG+8;
        shouRuValueLab.font = [UIFont systemFontOfSize:11];
        shouRuValueLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        shouRuValueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:shouRuValueLab];
    }
    float floatShouRu = [[object amount] floatValue];
    if ([[object cntitle] isEqualToString:@"提款申请"])
    {
        shouRuValueLab.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%.2f", floatShouRu]];
    }
    else
    {
        shouRuValueLab.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%.2f", floatShouRu]];
    }
    //右侧----------------------------------------------------------------------------------------------------
    UILabel *typeTitleLab = (UILabel *)[cell viewWithTag:BASETAG+9];
    if(typeTitleLab == nil)
    {
        typeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(170, 38, 50, 15)];
        typeTitleLab.tag = BASETAG+9;
        typeTitleLab.font = [UIFont systemFontOfSize:11];
        typeTitleLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        typeTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeTitleLab];
    }
    typeTitleLab.text = @"交易类型:";
    
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG+10];
    if(typeLab == nil)
    {
        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(220, 38, 90, 15)];
        typeLab.tag = BASETAG+10;
        typeLab.font = [UIFont systemFontOfSize:11];
        typeLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    typeLab.text = [object cntitle];
    //----------------------------------------------------------------------------------------------------
    UILabel *remarkTitleLab = (UILabel *)[cell viewWithTag:BASETAG+11];
    if(remarkTitleLab == nil)
    {
        remarkTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(170, 68, 30, 15)];
        remarkTitleLab.tag = BASETAG+11;
        remarkTitleLab.font = [UIFont systemFontOfSize:11];
        remarkTitleLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        remarkTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:remarkTitleLab];
    }
    remarkTitleLab.text = @"备注:";
    
    UILabel *remarkValueLab = (UILabel *)[cell viewWithTag:BASETAG+12];
    if(remarkValueLab == nil)
    {
        remarkValueLab = [[UILabel alloc] initWithFrame:CGRectMake(200, 68, 110, 15)];
        remarkValueLab.tag = BASETAG+12;
        remarkValueLab.font = [UIFont systemFontOfSize:11];
        remarkValueLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        remarkValueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:remarkValueLab];
    }
    remarkValueLab.text = [object description];
    //----------------------------------------------------------------------------------------------------
    UILabel *yeTitleLab = (UILabel *)[cell viewWithTag:BASETAG+13];
    if(yeTitleLab == nil)
    {
        yeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(170, 100, 30, 15)];
        yeTitleLab.tag = BASETAG+13;
        yeTitleLab.font = [UIFont systemFontOfSize:11];
        yeTitleLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        yeTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:yeTitleLab];
    }
    yeTitleLab.text = @"余额:";
    
    UILabel *yeLab = (UILabel *)[cell viewWithTag:BASETAG+14];
    if(yeLab == nil)
    {
        yeLab = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 110, 15)];
        yeLab.tag = BASETAG+14;
        yeLab.font = [UIFont systemFontOfSize:11];
        yeLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        yeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:yeLab];
    }
    yeLab.text = [object availablebalance];
    //分割线--------------------------------------------------------------------------------------------------
    UIImageView *separateImg = (UIImageView *)[cell viewWithTag:BASETAG+15];
    if(separateImg==nil)
    {
        separateImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 121, 320, 5)];
        [cell addSubview:separateImg];
        separateImg.tag = BASETAG+15;
    }
    [separateImg setImage:[UIImage imageNamed:@"separate"]];
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [atmListArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk_infor_even"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (atmListArr.count>0 && [atmListArr isKindOfClass:[NSArray class]])
    {
        myMessagelabel.hidden=YES;
        AtmListObject *atmObj = [atmListArr objectAtIndex:indexPath.row];
        [self modelCellFill:cell Object:atmObj rowInd:[indexPath row]];
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
    return 125;
}
//tableView-end

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
    if(atmListArr.count>0||atmListArr.count!=0)
    {
        [atmListArr removeAllObjects];
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
    [self loadData:startLab.text endDate:endLab.text withPage:@"1"];
}
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
            [self loadData:startLab.text endDate:endLab.text withPage:pageStr];
            
        }
        else if (curren==totalPage&&curren!=0){}
        else if(curren==0)
        {
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
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
//        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"atmPage"];
//        int curren =[current intValue];
//        NSLog(@"%d---%d",curren,totalPage);
//        if (curren<totalPage) {
//            int a= curren+1;
//            NSString *pageStr =[NSString stringWithFormat:@"%d",a];
//             [self loadData:startLab.text endDate:endLab.text withPage:pageStr];
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
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
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
    [self.atmTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark- Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController
{
    [self dismissSemiModalViewController:viewController];
    
    _selectedDate = viewController.datePicker.date;
    [UIView animateWithDuration:.6 animations:^{
        if ([self.view.subviews containsObject:_BGView])
        {
            [_BGView removeFromSuperview];
        }
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
    [UIView animateWithDuration:.6 animations:^{
        if ([self.view.subviews containsObject:_BGView])
        {
            [_BGView removeFromSuperview];
        }
    }];
}

-(void)datePickerCancel:(TDDatePickerController*)viewController
{
    [self dismissSemiModalViewController:viewController];
    [UIView animateWithDuration:.6 animations:^{
        if ([self.view.subviews containsObject:_BGView])
        {
            [_BGView removeFromSuperview];
        }
    }];
}

-(void)dealloc
{
    _starDatePickerView.delegate=nil;
    _endDatePickerView.delegate=nil;
}
@end
