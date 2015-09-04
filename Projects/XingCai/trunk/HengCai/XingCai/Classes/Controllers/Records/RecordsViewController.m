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

@interface RecordsViewController ()
{
    BOOL viewDidAppear;
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
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    viewDidAppear = YES;
    [self loadData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    viewDidAppear = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
}
-(void)adjustView
{
    
    if (SystemVersion < 7.0) {
        self.contentView.point = CGPointZero;
        CGRect frame = self.contentView.frame;
         frame.size.height = IS_IPHONE5 ? 548 : 480;;
        self.contentView.frame = frame;
       
    }
    
       CGRect frame = tView.frame;
        frame.size.height =IS_IPHONE5?454:366;
            tView.frame = frame;
    
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
- (void)loadData
{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getLotteryInfomationWithBlock:^(id JSON, NSError *error)
     {
         
         if (!error)
         {
//             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                
                 NSDictionary *issueNumbersDict = [JSON objectForKey:@"issueNumbers"];
                 
                 //1:重庆时时彩
                 
                 NSArray *cqArray = [[NSArray alloc]init];
                 cqArray=(NSArray *)issueNumbersDict;
            
                 if (cqArray.count > 0) {
                     id oneObject = [cqArray objectAtIndex:0];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *)oneObject;
                         OpenLotteryObject *openLotteryObject = [[OpenLotteryObject alloc] initWithAttribute:oneObjectDict];
                         [openLotteryObject setType:@"重庆时时彩"];
                         
                         
                         NSString *issueNumner = openLotteryObject.issue;
                         
                         [[AppHttpManager sharedManager] getLotteryInfomationListWithLotteryID:@"1" issueNumber:issueNumner Block:^(id JSON, NSError *error)
                          {
//                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              if (!error)
                              {
                                  if ([JSON isKindOfClass:[NSDictionary class]])
                                  {
                                      NSArray *itemArray = [JSON objectForKey:@"issueList"];
                                      if (!openLotteriesDetails) {
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
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 else
                 {
                     [Utility showErrorWithMessage:@"找不到开奖信息"];
                     [openLotteriesDetails removeAllObjects];
                     [tView reloadData];
                 }
             }
             else
             {
                 DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(LotteryDetailsObject *)object rowInd:(NSInteger)rowIndex
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
    
//      UIImageView *bgimgView= [[UIImageView alloc]initWithFrame:CGRectMake(18 ,15, 44, 44)];
//    bgimgView.image=[UIImage imageNamed:@"lottery_icon01"];
//    [cell addSubview:bgimgView];
    
  
   
    if (rowIndex>=2&&rowIndex%2==0) {
        UIImage *image = [UIImage imageNamed:@"bk_chasing_odd.png"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:image];

    }else
    {
        UIImage *image = [UIImage imageNamed:@"bk_chasing_even"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:image];

    }
    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(typeLab == nil)
    {
        if (rowIndex == 0)
        {
            typeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 140, 18)];
            typeLab.textColor = [UIColor colorWithRed:(254/255.0) green:(46/255.0) blue:(46/255.0) alpha:1.0];
        }
        else
        {
            typeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 140, 18)];
            typeLab.textColor = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1.0];
        }
        typeLab.tag = BASETAG1;
        typeLab.font = [UIFont systemFontOfSize:18];
        typeLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:typeLab];
    }
    typeLab.text = @"重庆时时彩";
    
    UILabel *lotteryTermLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(lotteryTermLab == nil)
    {
        if (rowIndex == 0)
        {
            lotteryTermLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 13, 120, 11)];
             lotteryTermLab.textColor = [UIColor whiteColor];
        }
        else
        {
            lotteryTermLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 13, 120, 11)];
             lotteryTermLab.textColor =[UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1.0];
        }
        lotteryTermLab.tag = BASETAG1+1;
        lotteryTermLab.font = [UIFont systemFontOfSize:13];
       
        lotteryTermLab.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryTermLab];
    }
    lotteryTermLab.text = [[@"第" stringByAppendingString:[object issue]] stringByAppendingString:@"期"];
    
//    UILabel *dateLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
//    if(dateLab == nil)
//    {
//        if (rowIndex == 0)
//        {
//            dateLab = [[UILabel alloc] initWithFrame:CGRectMake(240, 36, 70, 20)];
//        }
//        else
//        {
//            dateLab = [[UILabel alloc] initWithFrame:CGRectMake(240, 30, 70, 20)];
//        }
//        dateLab.tag = BASETAG1+2;
//        dateLab.font = [UIFont systemFontOfSize:10];
//        dateLab.textColor = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1.0];
//        dateLab.backgroundColor = [UIColor clearColor];
//        [cell addSubview:dateLab];
//    }
//    NSString *year = [[object issue] substringToIndex:4];
//    NSString *MM = [[object issue] substringWithRange:NSMakeRange(4, 2)];
//    NSString *dd = [[object issue] substringWithRange:NSMakeRange(6, 2)];
//    dateLab.text = [[[[year stringByAppendingString:@"-"] stringByAppendingString:MM] stringByAppendingString:@"-"] stringByAppendingString:dd];
    
//    NSString *ballBG = nil;
//    if (rowIndex == 0)
//    {
//        ballBG = @"current_ball";
//    }
//    else
//    {
//        ballBG = @"white_ball";
//    }
    //号码1及背景
//    UIView *imgV1 = (UIView *)[cell viewWithTag:BASETAG1+3];
//    if(imgV1==nil)
//    {
//        if (rowIndex == 0)
//        {
//            imgV1 = [[UIView alloc] initWithFrame:CGRectMake(27, 42, 32, 32)];
//        }
//        else
//        {
//            imgV1 = [[UIView alloc] initWithFrame:CGRectMake(27, 36, 32, 32)];
//        }
//        [cell addSubview:imgV1];
//        imgV1.tag = BASETAG1+3;
//    }
//    [imgV1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab1 = (UILabel *)[cell viewWithTag:BASETAG1+4];
    if(lotteryNoLab1 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(28, 41, 90, 20)];
            lotteryNoLab1.textColor = [UIColor whiteColor];
        }
        else
        {
            lotteryNoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(28, 42, 90, 20)];
            lotteryNoLab1.textColor = [UIColor colorWithRed:(252/255.0) green:(191/255.0) blue:(0/255.0) alpha:1];
        }
        
        lotteryNoLab1.tag = BASETAG1+4;
        lotteryNoLab1.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab1.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab1];
    }
    NSString *one = [[object code] substringToIndex:1];
    lotteryNoLab1.text = one;
    //号码2及背景
//    UIView *imgV2 = (UIView *)[cell viewWithTag:BASETAG1+5];
//    if(imgV2==nil)
//    {
//        if (rowIndex == 0)
//        {
//            imgV2 = [[UIView alloc] initWithFrame:CGRectMake(64, 42, 32, 32)];
//        }
//        else
//        {
//            imgV2 = [[UIView alloc] initWithFrame:CGRectMake(64, 36, 32, 32)];
//        }
//        [cell addSubview:imgV2];
//        imgV2.tag = BASETAG1+5;
//    }
//    [imgV2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab2 = (UILabel *)[cell viewWithTag:BASETAG1+6];
    if(lotteryNoLab2 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(58, 41, 90, 20)];
            lotteryNoLab2.textColor =  lotteryNoLab1.textColor = [UIColor whiteColor];
        }
        else
        {
            lotteryNoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(58, 42, 90, 20)];
            lotteryNoLab2.textColor = [UIColor colorWithRed:(252/255.0) green:(191/255.0) blue:(0/255.0) alpha:1];
        }
        
        lotteryNoLab2.tag = BASETAG1+6;
        lotteryNoLab2.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab2.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab2];
    }
    NSString *two = [[object code] substringWithRange:NSMakeRange(1, 1)];
    lotteryNoLab2.text = two;
    
    //号码3及背景
//    UIView *imgV3 = (UIView *)[cell viewWithTag:BASETAG1+7];
//    if(imgV3==nil)
//    {
//        if (rowIndex == 0)
//        {
//            imgV3 = [[UIView alloc] initWithFrame:CGRectMake(101, 42, 32, 32)];
//        }
//        else
//        {
//            imgV3 = [[UIView alloc] initWithFrame:CGRectMake(101, 36, 32, 32)];
//        }
//        [cell addSubview:imgV3];
//        imgV3.tag = BASETAG1+7;
//    }
//    [imgV3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab3 = (UILabel *)[cell viewWithTag:BASETAG1+8];
    if(lotteryNoLab3 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(88, 41, 90, 20)];
            lotteryNoLab3.textColor =  lotteryNoLab1.textColor = [UIColor whiteColor];
        }
        else
        {
            lotteryNoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(88, 42, 90, 20)];
            lotteryNoLab3.textColor = [UIColor colorWithRed:(252/255.0) green:(191/255.0) blue:(0/255.0) alpha:1];
        }
        
        lotteryNoLab3.tag = BASETAG1+8;
        lotteryNoLab3.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab3.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab3];
    }
    NSString *three = [[object code] substringWithRange:NSMakeRange(2, 1)];
    lotteryNoLab3.text = three;
    //号码4及背景
//    UIView *imgV4 = (UIView *)[cell viewWithTag:BASETAG1+9];
//    if(imgV4==nil)
//    {
//        if (rowIndex == 0)
//        {
//            imgV4 = [[UIView alloc] initWithFrame:CGRectMake(138, 42, 32, 32)];
//        }
//        else
//        {
//            imgV4 = [[UIView alloc] initWithFrame:CGRectMake(138, 36, 32, 32)];
//        }
//        [cell addSubview:imgV4];
//        imgV4.tag = BASETAG1+9;
//    }
//    [imgV4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab4 = (UILabel *)[cell viewWithTag:BASETAG1+10];
    if(lotteryNoLab4 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab4 = [[UILabel alloc] initWithFrame:CGRectMake(118, 41, 90, 20)];
             lotteryNoLab4.textColor =  lotteryNoLab1.textColor = [UIColor whiteColor];
        }
        else
        {
            lotteryNoLab4 = [[UILabel alloc] initWithFrame:CGRectMake(118, 42, 90, 20)];
             lotteryNoLab4.textColor = [UIColor colorWithRed:(252/255.0) green:(191/255.0) blue:(0/255.0) alpha:1];
        }
       
        lotteryNoLab4.tag = BASETAG1+10;
        lotteryNoLab4.font = [UIFont boldSystemFontOfSize:18];
        lotteryNoLab4.backgroundColor = [UIColor clearColor];
        [cell addSubview:lotteryNoLab4];
    }
    NSString *four = [[object code] substringWithRange:NSMakeRange(3, 1)];
    lotteryNoLab4.text = four;
    //号码5及背景
//    UIView *imgV5 = (UIView *)[cell viewWithTag:BASETAG1+11];
//    if(imgV5==nil)
//    {
//        if (rowIndex == 0)
//        {
//            imgV5 = [[UIView alloc] initWithFrame:CGRectMake(175, 42, 32, 32)];
//        }
//        else
//        {
//            imgV5 = [[UIView alloc] initWithFrame:CGRectMake(175, 36, 32, 32)];
//        }
//        [cell addSubview:imgV5];
//        imgV5.tag = BASETAG1+11;
//    }
//    [imgV5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ballBG]]];
    UILabel *lotteryNoLab5 = (UILabel *)[cell viewWithTag:BASETAG1+12];
    if(lotteryNoLab5 == nil)
    {
        if (rowIndex == 0)
        {
            lotteryNoLab5 = [[UILabel alloc] initWithFrame:CGRectMake(148, 41, 90, 20)];
            lotteryNoLab5.textColor =  lotteryNoLab1.textColor = [UIColor whiteColor];
        }
        else
        {
            lotteryNoLab5 = [[UILabel alloc] initWithFrame:CGRectMake(148, 42, 90, 20)];
            lotteryNoLab5.textColor = [UIColor colorWithRed:(252/255.0) green:(191/255.0) blue:(0/255.0) alpha:1];
        }
        
        lotteryNoLab5.tag = BASETAG1+12;
        lotteryNoLab5.font = [UIFont boldSystemFontOfSize:18];
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
        return 75;
    }
    else
    {
        return 75;
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
        [self loadData];
    }
}
@end
