//
//  RecordsViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "RecordsViewController.h"
//#import "OpenLotteryDetailViewController.h"
#import "OpenLotteryObject.h"
#import "LotteryDetailsObject.h"
#import "JiangQiManager.h"
#define BASETAG1    1024
#import "BuyViewController.h"
@interface RecordsViewController ()
{
    BOOL viewDidAppear;
    NSString *caizhong;

}
@end

@implementation RecordsViewController
@synthesize headCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    viewDidAppear = YES;
     caizhong = @"1";
    [self loadDataWithLotteryId:caizhong];
}
- (void)viewDidDisappear:(BOOL)animated
{
    viewDidAppear = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
}

- (void)viewDidLayoutSubviews
{
//    NSLog(@"frame:%@",NSStringFromCGRect(tView.frame));
//    if (SystemVersion >= 7.0) {
//        CGRect frame = tView.frame;
//        frame.size.height -= 34;
//        tView.frame = frame;
//    }
}
- (void)loadDataWithLotteryId:(NSString *)lotteryID
{
    if ([lotteryID isEqualToString:@"1"]) {
        self.chongqingBtn.selected=YES;
        if (self.quick5Btn.selected==YES) {
            self.quick5Btn.selected=NO;
        }
    }else if ([lotteryID isEqualToString:@"14"]){
        self.quick5Btn.selected=YES;
        if (self.chongqingBtn.selected==YES) {
            self.chongqingBtn.selected=NO;
        }
        
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getLotteryInfomationWithBlock:^(id JSON, NSError *error)
    {
        if (!error)
        {
            if ([JSON isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *issueNumbersDict = [JSON objectForKey:@"issueNumbers"];
                
                //1:重庆时时彩
                NSArray *cqArray = [issueNumbersDict objectForKey:lotteryID];
                
                if (cqArray.count > 0) {
                    id oneObject = [cqArray objectAtIndex:0];
                    if ([oneObject isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *oneObjectDict = (NSDictionary *)oneObject;
                        OpenLotteryObject *openLotteryObject = [[OpenLotteryObject alloc] initWithAttribute:oneObjectDict];
                        if ([lotteryID isEqualToString:@"1"]) {
                            [openLotteryObject setType:@"重庆时时彩"];
                        }else if ([lotteryID isEqualToString:@"14"]){
                            [openLotteryObject setType:@"河内Quick5"];
                        }
                        
                        NSString *issueNumner = openLotteryObject.issue;
                        
                        [[AppHttpManager sharedManager] getLotteryInfomationListWithLotteryID:caizhong issueNumber:issueNumner Block:^(id JSON, NSError *error)
                         {
                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             if (!error)
                             {
                                 if ([JSON isKindOfClass:[NSDictionary class]])
                                 {
                                     NSArray *itemArray = [JSON objectForKey:@"issueList"];
                                     if (!openLotteriesDetails)
                                     {
                                         openLotteriesDetails = [[NSMutableArray alloc] init];
                                     }
                                     else
                                     {
                                         [openLotteriesDetails removeAllObjects];
                                     }
                                     
                                     for (int i = 0; i < itemArray.count; ++i)
                                     {
                                         id oneObject = [itemArray objectAtIndex:i];
                                         if ([oneObject isKindOfClass:[NSDictionary class]])
                                         {
                                             NSDictionary *oneObjectDict = (NSDictionary *)oneObject;
                                             LotteryDetailsObject *ldo = [[LotteryDetailsObject alloc] initWithAttribute:oneObjectDict];
                                             [openLotteriesDetails addObject:ldo];
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
                                 DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                             }
                         }];
                    }
                    else
                    {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                    }
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([lotteryID isEqualToString:@"1"]) {
                        [Utility showErrorWithMessage:@"找不到重庆时时彩开奖信息"];
                    }else if ([lotteryID isEqualToString:@"14"]){
                        [Utility showErrorWithMessage:@"找不到印尼五分彩开奖信息"];
                    }
                    [openLotteriesDetails removeAllObjects];
                    [tView reloadData];
                }
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
            }
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(LotteryDetailsObject *)object rowInd:(int)rowIndex
{
    /*OpenLotteryObject *obj = object;
    
    UIButton *imgBtn = (UIButton *)[cell viewWithTag:BASETAG1];
    if(imgBtn==nil)
    {
        imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 30, 49)];
        //[imgBtn addTarget:self action:@selector(XXX:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:imgBtn];
        imgBtn.tag = rowIndex;
    }
    UIImage *img = [UIImage imageNamed:@"fan.png"];
    [imgBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(typeLab == nil)
    {
        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 90, 20)];
        typeLab.tag = BASETAG1+1;
        typeLab.font = [UIFont systemFontOfSize:15];
        typeLab.textColor = [UIColor darkGrayColor];
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    typeLab.text = [obj type];
    
    UILabel *lotteryTermLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(lotteryTermLab == nil)
    {
        lotteryTermLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 90, 20)];
        lotteryTermLab.tag = BASETAG1+2;
        lotteryTermLab.font = [UIFont systemFontOfSize:12];
        lotteryTermLab.textColor = [UIColor darkGrayColor];
        lotteryTermLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryTermLab];
    }
    lotteryTermLab.text = [obj issue];
    
    UILabel *dateLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(dateLab == nil)
    {
        dateLab = [[UILabel alloc] initWithFrame:CGRectMake(215, 5, 70, 20)];
        dateLab.tag = BASETAG1+3;
        dateLab.font = [UIFont systemFontOfSize:12];
        dateLab.textColor = [UIColor darkGrayColor];
        dateLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:dateLab];
    }
    NSString *year = [[obj issue] substringToIndex:4];
    NSString *MM = [[obj issue] substringWithRange:NSMakeRange(4, 2)];
    NSString *dd = [[obj issue] substringWithRange:NSMakeRange(6, 2)];
    dateLab.text = [[[[year stringByAppendingString:@"-"] stringByAppendingString:MM] stringByAppendingString:@"-"] stringByAppendingString:dd];
    
    UILabel *lotteryNoLab = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(lotteryNoLab == nil)
    {
        lotteryNoLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 25, 90, 20)];
        lotteryNoLab.tag = BASETAG1+4;
        lotteryNoLab.font = [UIFont boldSystemFontOfSize:14];
        lotteryNoLab.textColor = [UIColor darkGrayColor];
        lotteryNoLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab];
    }
    NSString *one = [[obj code] substringToIndex:1];
    NSString *two = [[obj code] substringWithRange:NSMakeRange(1, 1)];
    NSString *three = [[obj code] substringWithRange:NSMakeRange(2, 1)];
    NSString *four = [[obj code] substringWithRange:NSMakeRange(3, 1)];
    NSString *five = [[obj code] substringWithRange:NSMakeRange(4, 1)];
    lotteryNoLab.text = [[[[[[[[one stringByAppendingString:@" "] stringByAppendingString:two] stringByAppendingString:@" "] stringByAppendingString:three] stringByAppendingString:@" "] stringByAppendingString:four] stringByAppendingString:@" "] stringByAppendingString:five];*/
    
    //今天/历史的图片
    UIView *todayIcon = (UIView *)[cell viewWithTag:BASETAG1];
    if(todayIcon==nil)
    {
        if (rowIndex == 0)
        {
            todayIcon = [[UIView alloc] initWithFrame:CGRectMake(18, 33, 19, 23)];
            [todayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_today_icon"]]];
        }
        else
        {
            todayIcon = [[UIView alloc] initWithFrame:CGRectMake(18, 2, 19, 23)];
            [todayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_history_icon"]]];
        }
        [cell addSubview:todayIcon];
        todayIcon.tag = BASETAG1;
    }
    //重庆时时彩背景
    UIView *bgImg = (UIView *)[cell viewWithTag:BASETAG1+1];
    if(bgImg==nil)
    {
        if (rowIndex == 0)
        {
            bgImg = [[UIView alloc] initWithFrame:CGRectMake(40, 37, 129, 22)];
            [bgImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_today_titlebk"]]];
            [cell addSubview:bgImg];
            bgImg.tag = BASETAG1+1;
        }
    }
    //彩种
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(typeLab == nil)
    {
        if (rowIndex == 0)
        {
            typeLab = [[UILabel alloc] initWithFrame:CGRectMake(59, 38, 90, 20)];
            typeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(203/255.0) blue:(44/255.0) alpha:1];
        }
        else
        {
            typeLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 90, 20)];
            typeLab.textColor = [UIColor whiteColor];
        }
        typeLab.tag = BASETAG1+2;
        typeLab.font = [UIFont boldSystemFontOfSize:17];
        typeLab.backgroundColor = [UIColor clearColor];
        typeLab.textAlignment = UITextAlignmentCenter;
        [cell addSubview:typeLab];
    }
   
    if ([caizhong isEqualToString:@"1"]) {
         typeLab.text = @"重庆时时彩";
    }else if ([caizhong isEqualToString:@"14"]){
        //99彩修改彩种名称为印尼五分彩！！！！
     typeLab.text = @"印尼五分彩";
    }
    //奖期
    UILabel *lotteryTermLab = (UILabel *)[cell viewWithTag:BASETAG1+3];
    if(lotteryTermLab == nil)
    {
        if (rowIndex == 0)
        {
            lotteryTermLab = [[UILabel alloc] initWithFrame:CGRectMake(175, 38, 110, 20)];
        }
        else
        {
            lotteryTermLab = [[UILabel alloc] initWithFrame:CGRectMake(175, 4, 110, 20)];
        }
        lotteryTermLab.tag = BASETAG1+3;
        lotteryTermLab.font = [UIFont systemFontOfSize:12];
        lotteryTermLab.textColor = [UIColor colorWithRed:(197/255.0) green:(197/255.0) blue:(197/255.0) alpha:1];
        lotteryTermLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryTermLab];
    }
    lotteryTermLab.text = [[@"第" stringByAppendingString:[object issue]] stringByAppendingString:@"期"];
    
    NSString *ballBG = nil;
    if (rowIndex == 0)
    {
        ballBG = @"tag_ball_click";
    }
    else
    {
        ballBG = @"tag_ball_normal";
    }
    //号码1及背景
    UIView *imgV1 = (UIView *)[cell viewWithTag:BASETAG1+4];
    if(imgV1==nil)
    {
        if (rowIndex == 0)
        {
            imgV1 = [[UIView alloc] initWithFrame:CGRectMake(24, 63, 45, 45)];
        }
        else
        {
            imgV1 = [[UIView alloc] initWithFrame:CGRectMake(24, 31, 45, 45)];
        }
        [cell addSubview:imgV1];
        imgV1.tag = BASETAG1+4;
    }
    [imgV1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab1 = (UILabel *)[cell viewWithTag:BASETAG1+5];
    if(lotteryNoLab1 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(39, 73, 90, 25)];
            lotteryNoLab1.textColor = [UIColor colorWithRed:(252/255.0) green:(154/255.0) blue:(15/255.0) alpha:1];
        }
        else
        {
            lotteryNoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(39, 41, 90, 25)];
            lotteryNoLab1.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        }
        lotteryNoLab1.tag = BASETAG1+5;
        lotteryNoLab1.font = [UIFont boldSystemFontOfSize:30];
        lotteryNoLab1.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab1];
    }
    NSString *one = [[object code] substringToIndex:1];
    lotteryNoLab1.text = one;
    //号码2及背景
    UIView *imgV2 = (UIView *)[cell viewWithTag:BASETAG1+6];
    if(imgV2==nil)
    {
        if (rowIndex == 0)
        {
            imgV2 = [[UIView alloc] initWithFrame:CGRectMake(79, 63, 45, 45)];
        }
        else
        {
            imgV2 = [[UIView alloc] initWithFrame:CGRectMake(79, 31, 45, 45)];
        }
        [cell addSubview:imgV2];
        imgV2.tag = BASETAG1+6;
    }
    [imgV2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab2 = (UILabel *)[cell viewWithTag:BASETAG1+7];
    if(lotteryNoLab2 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(93, 73, 90, 25)];
            lotteryNoLab2.textColor = [UIColor colorWithRed:(252/255.0) green:(154/255.0) blue:(15/255.0) alpha:1];
        }
        else
        {
            lotteryNoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(93, 41, 90, 26)];
            lotteryNoLab2.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        }
        lotteryNoLab2.tag = BASETAG1+7;
        lotteryNoLab2.font = [UIFont boldSystemFontOfSize:30];
        lotteryNoLab2.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab2];
    }
    NSString *two = [[object code] substringWithRange:NSMakeRange(1, 1)];
    lotteryNoLab2.text = two;
    
    //号码3及背景
    UIView *imgV3 = (UIView *)[cell viewWithTag:BASETAG1+8];
    if(imgV3==nil)
    {
        if (rowIndex == 0)
        {
            imgV3 = [[UIView alloc] initWithFrame:CGRectMake(135, 63, 45, 45)];
        }
        else
        {
            imgV3 = [[UIView alloc] initWithFrame:CGRectMake(135, 31, 45, 45)];
        }
        [cell addSubview:imgV3];
        imgV3.tag = BASETAG1+8;
    }
    [imgV3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab3 = (UILabel *)[cell viewWithTag:BASETAG1+9];
    if(lotteryNoLab3 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(149, 73, 90, 25)];
            lotteryNoLab3.textColor = [UIColor colorWithRed:(252/255.0) green:(154/255.0) blue:(15/255.0) alpha:1];
        }
        else
        {
            lotteryNoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(149, 41, 90, 25)];
            lotteryNoLab3.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        }
        lotteryNoLab3.tag = BASETAG1+9;
        lotteryNoLab3.font = [UIFont boldSystemFontOfSize:30];
        lotteryNoLab3.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab3];
    }
    NSString *three = [[object code] substringWithRange:NSMakeRange(2, 1)];
    lotteryNoLab3.text = three;
    //号码4及背景
    UIView *imgV4 = (UIView *)[cell viewWithTag:BASETAG1+10];
    if(imgV4==nil)
    {
        if (rowIndex == 0)
        {
            imgV4 = [[UIView alloc] initWithFrame:CGRectMake(191, 63, 45, 45)];
        }
        else
        {
            imgV4 = [[UIView alloc] initWithFrame:CGRectMake(191, 31, 45, 45)];
        }
        [cell addSubview:imgV4];
        imgV4.tag = BASETAG1+10;
    }
    [imgV4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab4 = (UILabel *)[cell viewWithTag:BASETAG1+11];
    if(lotteryNoLab4 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab4 = [[UILabel alloc] initWithFrame:CGRectMake(205, 73, 90, 25)];
            lotteryNoLab4.textColor = [UIColor colorWithRed:(252/255.0) green:(154/255.0) blue:(15/255.0) alpha:1];
        }
        else
        {
            lotteryNoLab4 = [[UILabel alloc] initWithFrame:CGRectMake(205, 41, 90, 25)];
            lotteryNoLab4.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        }
        lotteryNoLab4.tag = BASETAG1+11;
        lotteryNoLab4.font = [UIFont boldSystemFontOfSize:30];
        lotteryNoLab4.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab4];
    }
    NSString *four = [[object code] substringWithRange:NSMakeRange(3, 1)];
    lotteryNoLab4.text = four;
    //号码5及背景
    UIView *imgV5 = (UIView *)[cell viewWithTag:BASETAG1+12];
    if(imgV5==nil)
    {
        if (rowIndex == 0)
        {
            imgV5 = [[UIView alloc] initWithFrame:CGRectMake(248, 63, 45, 45)];
        }
        else
        {
            imgV5 = [[UIView alloc] initWithFrame:CGRectMake(248, 31, 45, 45)];
        }
        [cell addSubview:imgV5];
        imgV5.tag = BASETAG1+12;
    }
    [imgV5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab5 = (UILabel *)[cell viewWithTag:BASETAG1+13];
    if(lotteryNoLab5 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab5 = [[UILabel alloc] initWithFrame:CGRectMake(262, 73, 90, 25)];
            lotteryNoLab5.textColor = [UIColor colorWithRed:(252/255.0) green:(154/255.0) blue:(15/255.0) alpha:1];
        }
        else
        {
            lotteryNoLab5 = [[UILabel alloc] initWithFrame:CGRectMake(262, 41, 90, 25)];
            lotteryNoLab5.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        }
        lotteryNoLab5.tag = BASETAG1+13;
        lotteryNoLab5.font = [UIFont boldSystemFontOfSize:30];
        lotteryNoLab5.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab5];
    }
    NSString *five = [[object code] substringWithRange:NSMakeRange(4, 1)];
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
    
    if (indexPath.row == 0)
    {
        [self modelCellFill:self.headCell Object:lotteryDetailsObject rowInd:[indexPath row]];
        self.headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.headCell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        UIImage *image = [UIImage imageNamed:@"current_bg2"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:image];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //去掉UITableView中cell的边框和分割线
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self modelCellFill:cell Object:lotteryDetailsObject rowInd:[indexPath row]];
        
        return cell;
    }
}

//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 148;
    }
    else
    {
        return 95;
    }
}
//某行已经被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *tmp = [[OpenLotteryDetailViewController alloc] init];
//    tmp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:tmp animated:YES];
}
//tableView-end

- (void)updateJiangQi:(NSNotification *)notification
{
    if (viewDidAppear) {
        [self loadDataWithLotteryId:caizhong];
    }
}
- (IBAction)gotoChangeKindOfLottery:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *lotteryId =[NSString stringWithFormat:@"%d",btn.tag];
    caizhong=lotteryId;
    [self loadDataWithLotteryId:caizhong];
}

- (IBAction)gotoBuyController:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}
@end
