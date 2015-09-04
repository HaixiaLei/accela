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

@interface ATMViewController ()
@end

@implementation ATMViewController

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
    
    self.atmTableView.size = CGSizeMake(320, 383);
    self.atmTableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_top"]];
    self.atmTableView.tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_form_bottom"]];
    self.atmTableView.tableHeaderView.hidden=YES;
    self.atmTableView.tableFooterView.hidden=YES;

    
    atmListArr = [[NSMutableArray alloc] init];
    addArray =[[NSMutableArray alloc]init];
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    myMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(60,320+(IS_IPHONE5?60:0), 200,40)];
    myMessagelabel.text=@"您暂时没有充提记录";
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
    if(atmListArr.count!=0||atmListArr.count>0){
        [atmListArr removeAllObjects];
    }
    
    NSString *page=@"0";
    [[NSUserDefaults standardUserDefaults]setObject:page forKey:@"atmPage"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData:(NSString *)sDate endDate:(NSString *)eDate withPage:(NSString *)page
{
    if (mark==YES) {
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
                
//                 CurrentPage=[[itemAr objectForKey:@"CurrentPage"] intValue];
                  NSLog(@"%@--%d---%d",page,totalPage,CurrentPage);
                 if ([current isEqualToString:page]||[page isEqualToString:@"1"]) {
                     
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
                  NSLog(@"%@--",atmListArr);
                 [self.atmTableView reloadData];
                
                 if (atmListArr.count==0) {
                    
                     myMessagelabel.hidden=NO;
                     self.atmTableView.tableHeaderView.hidden=YES;
                     self.atmTableView.tableFooterView.hidden=YES;
                   
                 }else if(atmListArr.count>0){
                
                     myMessagelabel.hidden=YES;
                     self.atmTableView.tableHeaderView.hidden=NO;
                     self.atmTableView.tableFooterView.hidden=NO;
            
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
    UILabel *dateLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(dateLab == nil)
    {
        dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 70, 15)];
        dateLab.tag = BASETAG1;
        dateLab.font = [UIFont systemFontOfSize:11];
        dateLab.textColor = [UIColor darkGrayColor];
        dateLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:dateLab];
    }
    dateLab.text = [[object times] substringToIndex:10];
    
    UILabel *timeTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(timeTitleLab == nil)
    {
        timeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 29, 55, 15)];
        timeTitleLab.tag = BASETAG1+1;
        timeTitleLab.font = [UIFont systemFontOfSize:11];
        timeTitleLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
        timeTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:timeTitleLab];
    }
    timeTitleLab.text = @"交易时间:";
    
    UILabel *timeLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(timeLab == nil)
    {
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 29, 60, 15)];
        timeLab.tag = BASETAG1+2;
        timeLab.font = [UIFont systemFontOfSize:11];
        timeLab.textColor = [UIColor darkGrayColor];
        timeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:timeLab];
    }
    timeLab.text = [[object times] substringFromIndex:10];
    
    UILabel *noTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(noTitleLab == nil)
    {
        noTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 49, 35, 15)];
        noTitleLab.tag = BASETAG1+3;
        noTitleLab.font = [UIFont systemFontOfSize:11];
        noTitleLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
        noTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:noTitleLab];
    }
    noTitleLab.text = @"编号:";
    
    UILabel *noLab = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(noLab == nil)
    {
        noLab = [[UILabel alloc] initWithFrame:CGRectMake(45, 49, 130, 15)];
        noLab.tag = BASETAG1+4;
        noLab.font = [UIFont systemFontOfSize:11];
        noLab.textColor = [UIColor darkGrayColor];
        noLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:noLab];
    }
    noLab.text = [object orderno];
    
    UILabel *statusTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+5];
    if(statusTitleLab == nil)
    {
        statusTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 35, 15)];
        statusTitleLab.tag = BASETAG1+5;
        statusTitleLab.font = [UIFont systemFontOfSize:11];
        statusTitleLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
        statusTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:statusTitleLab];
    }
    statusTitleLab.text = @"状态:";
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG1+6];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(45, 72, 30, 15)];
        statusLab.tag = BASETAG1+6;
        statusLab.font = [UIFont systemFontOfSize:11];
        statusLab.textColor = [UIColor darkGrayColor];
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
    
    UILabel *shouRuLab = (UILabel *)[cell viewWithTag:BASETAG1+7];
    if(shouRuLab == nil)
    {
        shouRuLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 96, 35, 15)];
        shouRuLab.tag = BASETAG1+7;
        shouRuLab.font = [UIFont systemFontOfSize:11];
        shouRuLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
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
    
    UILabel *shouRuValueLab = (UILabel *)[cell viewWithTag:BASETAG1+8];
    if(shouRuValueLab == nil)
    {
        shouRuValueLab = [[UILabel alloc] initWithFrame:CGRectMake(45, 96, 100, 15)];
        shouRuValueLab.tag = BASETAG1+8;
        shouRuValueLab.font = [UIFont systemFontOfSize:11];
        shouRuValueLab.textColor = [UIColor darkGrayColor];
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
    //右侧
    UILabel *typeTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+9];
    if(typeTitleLab == nil)
    {
        typeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 29, 55, 15)];
        typeTitleLab.tag = BASETAG1+9;
        typeTitleLab.font = [UIFont systemFontOfSize:11];
        typeTitleLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
        typeTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeTitleLab];
    }
    typeTitleLab.text = @"交易类型:";
    
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1+10];
    if(typeLab == nil)
    {
        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(245, 29, 60, 15)];
        typeLab.tag = BASETAG1+10;
        typeLab.font = [UIFont systemFontOfSize:11];
        typeLab.textColor = [UIColor darkGrayColor];
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    typeLab.text = [object cntitle];
    
    UILabel *remarkTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+11];
    if(remarkTitleLab == nil)
    {
        remarkTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 72, 30, 15)];
        remarkTitleLab.tag = BASETAG1+11;
        remarkTitleLab.font = [UIFont systemFontOfSize:11];
        remarkTitleLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
        remarkTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:remarkTitleLab];
    }
    remarkTitleLab.text = @"备注:";
    
    UILabel *remarkValueLab = (UILabel *)[cell viewWithTag:BASETAG1+12];
    if(remarkValueLab == nil)
    {
        remarkValueLab = [[UILabel alloc] initWithFrame:CGRectMake(220, 72, 90, 15)];
        remarkValueLab.tag = BASETAG1+12;
        remarkValueLab.font = [UIFont systemFontOfSize:11];
        remarkValueLab.textColor = [UIColor darkGrayColor];
        remarkValueLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:remarkValueLab];
    }
    remarkValueLab.text = [object description];
    
    UILabel *yeTitleLab = (UILabel *)[cell viewWithTag:BASETAG1+13];
    if(yeTitleLab == nil)
    {
        yeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 96, 30, 15)];
        yeTitleLab.tag = BASETAG1+13;
        yeTitleLab.font = [UIFont systemFontOfSize:11];
        yeTitleLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
        yeTitleLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:yeTitleLab];
    }
    yeTitleLab.text = @"余额:";
    
    UILabel *yeLab = (UILabel *)[cell viewWithTag:BASETAG1+14];
    if(yeLab == nil)
    {
        yeLab = [[UILabel alloc] initWithFrame:CGRectMake(220, 96, 90, 15)];
        yeLab.tag = BASETAG1+14;
        yeLab.font = [UIFont systemFontOfSize:11];
        yeLab.textColor = [UIColor colorWithRed:(169/255.0) green:(8/255.0) blue:(193/255.0) alpha:1];
        yeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:yeLab];
    }
    yeLab.text = [object availablebalance];
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
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_chongti"]];
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
    return 121;
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
    if(atmListArr.count>0||atmListArr.count!=0){
        [atmListArr removeAllObjects];
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
    [self loadData:startLab.text endDate:endLab.text withPage:@"1"];
    
}
- (void)addFooter
{
    __unsafe_unretained ATMViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.atmTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *current =[[NSUserDefaults standardUserDefaults]objectForKey:@"atmPage"];
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
        if (atmListArr.count==0) {
            self.atmTableView.tableHeaderView.hidden=YES;
            self.atmTableView.tableFooterView.hidden=YES;
            myMessagelabel.hidden=NO;
            
            }else{
                
            self.atmTableView.tableHeaderView.hidden=NO;
            self.atmTableView.tableFooterView.hidden=NO;
            
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
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
        if (atmListArr.count==0) {
            myMessagelabel.hidden=NO;
            self.atmTableView.tableHeaderView.hidden=YES;
            self.atmTableView.tableFooterView.hidden=YES;

        }else{
            myMessagelabel.hidden=YES;
            self.atmTableView.tableHeaderView.hidden=NO;
            self.atmTableView.tableFooterView.hidden=NO;
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
    [self.atmTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark- Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
    [self dismissSemiModalViewController:viewController];
    
    _selectedDate = viewController.datePicker.date;
    [UIView animateWithDuration:.6 animations:^{
        if ([self.view.subviews containsObject:_BGView]) {
            [_BGView removeFromSuperview];
        }
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
    [UIView animateWithDuration:.6 animations:^{
        if ([self.view.subviews containsObject:_BGView]) {
            [_BGView removeFromSuperview];
        }
    }];
}

-(void)datePickerCancel:(TDDatePickerController*)viewController {
    [self dismissSemiModalViewController:viewController];
    [UIView animateWithDuration:.6 animations:^{
        if ([self.view.subviews containsObject:_BGView]) {
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
