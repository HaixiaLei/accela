//
//  OpenNoViewController.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-10-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "OpenNoViewController.h"
#import "OpenNoObject.h"
#import "OpenNoCell.h"

static NSString *CellIdentifier = @"OpenNoCell";

@interface OpenNoViewController ()
@end

@implementation OpenNoViewController
@synthesize tView;
@synthesize lotteryTypeView;
@synthesize lp;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self searchData:lotteryTypeStr];
    [self.tView setContentOffset:CGPointMake(0,0) animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lotteryTypeView.hidden = YES;
    
    //设置默认全部彩种
    lotteryTypeStr = @"0";
    lotteryTypeName = @"全部记录";
    lotteryArray = [[NSMutableArray alloc] initWithObjects:@"全部记录", nil];
    subLotteryArr = [[NSMutableArray alloc] initWithObjects:@"重庆时时彩", @"日本时时彩", nil];
    [lotteryArray addObjectsFromArray:subLotteryArr];
    [self.lp setDates:lotteryArray];
    [self.lp reloadAllComponents];
    
    topTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [topTitleView setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = topTitleView;
    
    topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setTitle:[lotteryArray objectAtIndex:0] forState:UIControlStateNormal];
    [topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    topBtn.frame = CGRectMake(30, -5, 140, 44);
    [topBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [topBtn addTarget:self action:@selector(lotteryTypeClk) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:topBtn];
    
    arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    arrowBtn.frame = CGRectMake(134, 12, 16, 12);
    [arrowBtn setImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
    [arrowBtn addTarget:self action:@selector(lotteryTypeClk) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:arrowBtn];
    
    openNoArr = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//不显示左箭头
- (void)setLeftBarButton{}

//选择彩种-begin
- (IBAction)lotteryTypeClk
{
    lotteryTypeView.hidden = NO;
}
- (void)lotteryPicker:(LotteryPicker *)picker didSelectDateWithName:(NSString *)name
{
    lotteryTypeName = name;
}
- (IBAction)cancelClick:(id)sender
{
    lotteryTypeView.hidden = YES;
}
- (IBAction)okClick:(id)sender
{
    lotteryTypeView.hidden = YES;
    
    [topBtn setTitle:lotteryTypeName forState:UIControlStateNormal];
    
    if ([topBtn.titleLabel.text isEqualToString:@"重庆时时彩"])
    {
        lotteryTypeStr = @"1";
        arrowBtn.point =CGPointMake(142, arrowBtn.frame.origin.y);
    }
    else if ([topBtn.titleLabel.text isEqualToString:@"日本时时彩"])
    {
        lotteryTypeStr = @"15";
        arrowBtn.point =CGPointMake(142, arrowBtn.frame.origin.y);
    }
    else
    {
        lotteryTypeStr = @"0";
        arrowBtn.point =CGPointMake(134, arrowBtn.frame.origin.y);
    }
    
    [self searchData:lotteryTypeStr];
}
//选择彩种-end

- (void)searchData:(NSString *)lyTypeStr
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient sharedClient] historyOfTheWinningNumbers_with_lotteryId:lyTypeStr type:@"2" block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 [openNoArr removeAllObjects];
                 
                 NSArray *itemArray = [JSON objectForKey:@"results"];
                 
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         
                         OpenNoObject *openNoObj = [[OpenNoObject alloc] initWithAttribute:oneObjectDict];
                         [openNoArr addObject:openNoObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 [tView reloadData];
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
}

//tableView-begin
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [openNoArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerNib:[UINib nibWithNibName:@"OpenNoCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    OpenNoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (openNoArr.count>0)
    {
        OpenNoObject *openNoObj = [openNoArr objectAtIndex:indexPath.row];
        [cell updateOpenNoObject:openNoObj];
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
    return 80;
}
//tableView-end

@end
