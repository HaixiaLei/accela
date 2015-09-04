//
//  OpenLotteryDetailViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "OpenLotteryDetailViewController.h"
#import "LotteryDetailsObject.h"

#define BASETAG1    1024

@interface OpenLotteryDetailViewController ()
@end

@implementation OpenLotteryDetailViewController

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
    [self loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
}
- (void)loadData
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[AppHttpManager sharedManager] getLotteryInfomationListWithBlock:^(id JSON, NSError *error)
//     {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//         if (!error)
//         {
//             if ([JSON isKindOfClass:[NSDictionary class]])
//             {
//                 NSArray *itemArray = [JSON objectForKey:@"issueList"];
//                 openLotteriesDetails = [[NSMutableArray alloc] init];
//                 for (int i = 0; i < itemArray.count; ++i)
//                 {
//                     id oneObject = [itemArray objectAtIndex:i];
//                     if ([oneObject isKindOfClass:[NSDictionary class]])
//                     {
//                         NSDictionary *oneObjectDict = (NSDictionary *)oneObject;
//                         LotteryDetailsObject *ldo = [[LotteryDetailsObject alloc] initWithAttribute:oneObjectDict];
//                         [openLotteriesDetails addObject:ldo];
//                     }
//                     else
//                     {
//                         NSLog(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
//                     }
//                 }
//                 [tView reloadData];
//             }
//             else
//             {
//                 NSLog(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
//             }
//         }
//     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnBtnClk:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(LotteryDetailsObject *)object rowInd:(NSInteger)rowIndex
{
    LotteryDetailsObject *obj = object;
    
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(typeLab == nil)
    {
        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 90, 20)];
        typeLab.tag = BASETAG1;
        typeLab.font = [UIFont systemFontOfSize:15];
        typeLab.textColor = [UIColor darkGrayColor];
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    typeLab.text = @"重庆时时彩";
    
    UILabel *lotteryTermLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(lotteryTermLab == nil)
    {
        lotteryTermLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 6, 110, 20)];
        lotteryTermLab.tag = BASETAG1+1;
        lotteryTermLab.font = [UIFont systemFontOfSize:12];
        lotteryTermLab.textColor = [UIColor brownColor];
        lotteryTermLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryTermLab];
    }
    lotteryTermLab.text = [[@"第" stringByAppendingString:[obj issue]] stringByAppendingString:@"期"];
    
    UILabel *dateLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(dateLab == nil)
    {
        dateLab = [[UILabel alloc] initWithFrame:CGRectMake(240, 20, 70, 20)];
        dateLab.tag = BASETAG1+2;
        dateLab.font = [UIFont systemFontOfSize:12];
        dateLab.textColor = [UIColor darkGrayColor];
        dateLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:dateLab];
    }
    NSString *year = [[obj issue] substringToIndex:4];
    NSString *MM = [[obj issue] substringWithRange:NSMakeRange(4, 2)];
    NSString *dd = [[obj issue] substringWithRange:NSMakeRange(6, 2)];
    dateLab.text = [[[[year stringByAppendingString:@"-"] stringByAppendingString:MM] stringByAppendingString:@"-"] stringByAppendingString:dd];
    
    //号码1及背景
    UIView *imgV1 = (UIView *)[cell viewWithTag:BASETAG1+3];
    if(imgV1==nil)
    {
        imgV1 = [[UIView alloc] initWithFrame:CGRectMake(20, 25, 28, 28)];
        [cell addSubview:imgV1];
        imgV1.tag = BASETAG1+3;
    }
    [imgV1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"white_ball"]]];
    UILabel *lotteryNoLab1 = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(lotteryNoLab1 == nil)
    {
        lotteryNoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 90, 20)];
        lotteryNoLab1.tag = BASETAG1+4;
        lotteryNoLab1.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab1.textColor = [UIColor redColor];
        lotteryNoLab1.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab1];
    }
    NSString *one = [[obj code] substringToIndex:1];
    lotteryNoLab1.text = one;
    //号码2及背景
    UIView *imgV2 = (UIView *)[cell viewWithTag:BASETAG1+5];
    if(imgV2==nil)
    {
        imgV2 = [[UIView alloc] initWithFrame:CGRectMake(55, 25, 28, 28)];
        [cell addSubview:imgV2];
        imgV2.tag = BASETAG1+5;
    }
    [imgV2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"white_ball"]]];
    UILabel *lotteryNoLab2 = (UILabel *)[cell viewWithTag:BASETAG1+6];
    if(lotteryNoLab2 == nil)
    {
        lotteryNoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 90, 20)];
        lotteryNoLab2.tag = BASETAG1+6;
        lotteryNoLab2.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab2.textColor = [UIColor redColor];
        lotteryNoLab2.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab2];
    }
    NSString *two = [[obj code] substringWithRange:NSMakeRange(1, 1)];
    lotteryNoLab2.text = two;
    
    //号码3及背景
    UIView *imgV3 = (UIView *)[cell viewWithTag:BASETAG1+7];
    if(imgV3==nil)
    {
        imgV3 = [[UIView alloc] initWithFrame:CGRectMake(90, 25, 28, 28)];
        [cell addSubview:imgV3];
        imgV3.tag = BASETAG1+7;
    }
    [imgV3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"white_ball"]]];
    UILabel *lotteryNoLab3 = (UILabel *)[cell viewWithTag:BASETAG1+8];
    if(lotteryNoLab3 == nil)
    {
        lotteryNoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 90, 20)];
        lotteryNoLab3.tag = BASETAG1+8;
        lotteryNoLab3.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab3.textColor = [UIColor redColor];
        lotteryNoLab3.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab3];
    }
    NSString *three = [[obj code] substringWithRange:NSMakeRange(2, 1)];
    lotteryNoLab3.text = three;
    //号码4及背景
    UIView *imgV4 = (UIView *)[cell viewWithTag:BASETAG1+9];
    if(imgV4==nil)
    {
        imgV4 = [[UIView alloc] initWithFrame:CGRectMake(125, 25, 28, 28)];
        [cell addSubview:imgV4];
        imgV4.tag = BASETAG1+9;
    }
    [imgV4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"white_ball"]]];
    UILabel *lotteryNoLab4 = (UILabel *)[cell viewWithTag:BASETAG1+10];
    if(lotteryNoLab4 == nil)
    {
        lotteryNoLab4 = [[UILabel alloc] initWithFrame:CGRectMake(135, 30, 90, 20)];
        lotteryNoLab4.tag = BASETAG1+10;
        lotteryNoLab4.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab4.textColor = [UIColor redColor];
        lotteryNoLab4.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab4];
    }
    NSString *four = [[obj code] substringWithRange:NSMakeRange(3, 1)];
    lotteryNoLab4.text = four;
    //号码5及背景
    UIView *imgV5 = (UIView *)[cell viewWithTag:BASETAG1+11];
    if(imgV5==nil)
    {
        imgV5 = [[UIView alloc] initWithFrame:CGRectMake(160, 25, 28, 28)];
        [cell addSubview:imgV5];
        imgV5.tag = BASETAG1+11;
    }
    [imgV5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"white_ball"]]];
    UILabel *lotteryNoLab5 = (UILabel *)[cell viewWithTag:BASETAG1+12];
    if(lotteryNoLab5 == nil)
    {
        lotteryNoLab5 = [[UILabel alloc] initWithFrame:CGRectMake(170, 30, 90, 20)];
        lotteryNoLab5.tag = BASETAG1+12;
        lotteryNoLab5.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab5.textColor = [UIColor redColor];
        lotteryNoLab5.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab5];
    }
    NSString *five = [[obj code] substringWithRange:NSMakeRange(4, 1)];
    lotteryNoLab5.text = five;
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [openLotteriesDetails count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LotteryDetailsObject *lotteryDetailsObject = [openLotteriesDetails objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    if(indexPath.row % 2 == 1)
    {
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"content_bg"]];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_bg"]];
    }
    else if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self modelCellFill:cell Object:lotteryDetailsObject rowInd:[indexPath row]];
    
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
    return 60;
}
//tableView-end
@end
