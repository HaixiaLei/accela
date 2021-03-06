//
//  ZhuiHaoDetailViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-6-29.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZhuiHaoDetailViewController.h"
#import "ZhuiHaoItemObject.h"
#import "UIViewController+CustomNavigationBar.h"

#define BASETAG1    1024

@interface ZhuiHaoDetailViewController ()
@end

@implementation ZhuiHaoDetailViewController
@synthesize taskID;
@synthesize isCancel;
@synthesize scrollView;
@synthesize tView;
@synthesize cancelBtn;
@synthesize lotteryImg;
@synthesize lotteryName;
@synthesize jiangqiLab;
@synthesize userLab;
@synthesize timeLab;
@synthesize wanfaLab;
@synthesize modesLab;
@synthesize zhuiHaoJinELab;
@synthesize issueCountLab;
@synthesize finishPriceLab;
@synthesize finishedCountLab;
@synthesize taskSumBonusLab;
@synthesize stopOnWinLab;
@synthesize codesTV;
@synthesize taskIDLab;

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
    if ([isCancel isEqualToString:@"0"])
    {
        cancelBtn.hidden = NO;
    }
    
    [self loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBarTitle:@"追号详情" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    self.scrollView.contentSize = CGSizeMake(320, 978);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] traceDetail_WithTaskId:taskID Block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *itemDic = JSON;
                 zhItemListArr = [[NSMutableArray alloc] init];
                 
                 NSString *lotteryType = [itemDic objectForKey:@"lotteryid"];
                 if ([lotteryType isEqualToString:@"1"])
                 {
                     [lotteryImg setImage:[UIImage imageNamed:@"icon_cq"]];
                 }
                 else if ([lotteryType isEqualToString:@"14"])
                 {
                     [lotteryImg setImage:[UIImage imageNamed:@"icon_henei"]];
                 }
                 
                 lotteryName.text = [itemDic objectForKey:@"cnname"];
                 jiangqiLab.text = [itemDic objectForKey:@"beginissue"];
                 userLab.text = [itemDic objectForKey:@"username"];
                 timeLab.text = [itemDic objectForKey:@"begintime"];
                 wanfaLab.text = [itemDic objectForKey:@"methodname"];
                 modesLab.text = [itemDic objectForKey:@"modes"];
                 zhuiHaoJinELab.text = [itemDic objectForKey:@"taskprice"];
                 issueCountLab.text = [itemDic objectForKey:@"issuecount"];
                 finishPriceLab.text = [itemDic objectForKey:@"finishprice"];
                 finishedCountLab.text = [itemDic objectForKey:@"finishedcount"];
                 
                 id taskSumBonus = [itemDic objectForKey:@"taskSumBonus"];
                 if ([taskSumBonus isKindOfClass:[NSNumber class]])
                 {
                     NSNumber *number = (NSNumber *) taskSumBonus;
                     taskSumBonusLab.text = number.stringValue;
                 }
                 else if ([taskSumBonus isKindOfClass:[NSString class]])
                 {
                     taskSumBonusLab.text = [itemDic objectForKey:@"taskSumBonus"];
                 }                 
                 if ([[itemDic objectForKey:@"stoponwin"] isEqualToString:@"1"])
                 {
                     stopOnWinLab.text = @"是";
                 }
                 else
                 {
                     stopOnWinLab.text = @"否";
                 }
                 codesTV.text = [itemDic objectForKey:@"codes"];
                 taskIDLab.text = [itemDic objectForKey:@"taskid"];
                 
                 //下边列表
                 NSArray *itemArray = [JSON objectForKey:@"taskDetail"];
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         ZhuiHaoItemObject *zhItemListObj = [[ZhuiHaoItemObject alloc] initWithAttribute:oneObjectDict];
                         [zhItemListArr addObject:zhItemListObj];
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
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
-(IBAction)cancelClk:(UIButton *)sender
{
    [Utility showErrorWithMessage:@"您确定要终止追号吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:1 duplicationPrevent:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {}
        else
        {
            cancelBtn.enabled = false;
            
            NSMutableString *entryStr = [NSMutableString string];
            for (int i=0; i<zhItemListArr.count; i++)
            {
                ZhuiHaoItemObject *zhItemObj = [zhItemListArr objectAtIndex:i];
                if ([[zhItemObj status] isEqualToString:@"0"])
                {
                    [entryStr appendString:[[zhItemObj entry] stringByAppendingString:@","]];
                }
            }
            if ([entryStr isEqualToString:@""])
            {
                [Utility showErrorWithMessage:@"该单已撤，请勿重复操作!" delegate:self tag:3];
            }
            else
            {
                [[AppHttpManager sharedManager] cancelTrace_WithTaskId:taskID detailId:[entryStr substringToIndex:entryStr.length-1] Block:^(id JSON, NSError *error)
                 {
                     if (!error)
                     {
                         if ([JSON isKindOfClass:[NSDictionary class]])
                         {
                             NSDictionary *itemDic = JSON;
                             [Utility showErrorWithMessage:[[itemDic objectForKey:@"msg"] stringByAppendingString:@"!"] delegate:self tag:2];
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
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 3)
    {
        if (buttonIndex == 1)
        {
            cancelBtn.hidden = YES;
        }
    }
}

//tableView-begin
-(void)modelCellFill:(UITableViewCell *)cell Object:(ZhuiHaoItemObject *)object rowInd:(NSInteger)rowIndex
{
    UILabel *titleLab = (UILabel *)[cell viewWithTag:BASETAG1];
    if(titleLab == nil)
    {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 106, 25)];
        titleLab.tag = BASETAG1;
        titleLab.font = [UIFont systemFontOfSize:11];
        titleLab.textColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLab];
    }
    if (![[object issue] isKindOfClass:[NSNull class]])
    {
        titleLab.text = [object issue];
    }
    else
    {
        titleLab.text = @"";
    }
    
    UILabel *statusLab = (UILabel *)[cell viewWithTag:BASETAG1+1];
    if(statusLab == nil)
    {
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(106, 2, 106, 25)];
        statusLab.tag = BASETAG1+1;
        statusLab.font = [UIFont systemFontOfSize:11];
        statusLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        statusLab.backgroundColor = [UIColor clearColor];
        statusLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:statusLab];
    }
    if ([[object status] isEqualToString:@"0"])
    {
        statusLab.text = @"进行中";
    }
    else if ([[object status] isEqualToString:@"1"])
    {
        statusLab.text = @"已完成";
    }
    else
    {
        statusLab.text = @"已取消";
    }
    
    UILabel *totalPriceLab = (UILabel *)[cell viewWithTag:BASETAG1+2];
    if(totalPriceLab == nil)
    {
        totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(212, 2, 106, 25)];
        totalPriceLab.tag = BASETAG1+2;
        totalPriceLab.font = [UIFont systemFontOfSize:11];
        totalPriceLab.textColor = [UIColor colorWithRed:(225/255.0) green:(47/255.0) blue:(47/255.0) alpha:1];
        totalPriceLab.backgroundColor = [UIColor clearColor];
        totalPriceLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:totalPriceLab];
    }
    if (![[object issue] isKindOfClass:[NSNull class]])
    {
        totalPriceLab.text = [object bonus];
    }
    else
    {
        totalPriceLab.text = @"";
    }
}
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [zhItemListArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    if(indexPath.row % 2 == 1)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_form_odd"]];
    }
    else if(indexPath.row % 2 == 0)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_form_even"]];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    if (zhItemListArr.count>0 && [zhItemListArr isKindOfClass:[NSArray class]])
    {
        ZhuiHaoItemObject *zhtItemObj = [zhItemListArr objectAtIndex:indexPath.row];
        [self modelCellFill:cell Object:zhtItemObj rowInd:[indexPath row]];
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
    return 30;
}
//tableView-end
@end
