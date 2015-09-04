//
//  BetRecordDetailViewController.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-25.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetRecordDetailViewController.h"

@interface BetRecordDetailViewController ()
@end

@implementation BetRecordDetailViewController
@synthesize scrollView;
@synthesize projectID;
@synthesize issueStr;
@synthesize projectIDLab;
@synthesize cnnameLab;
@synthesize methodnameLab;
@synthesize taskidLab;
@synthesize totalpriceLab;
@synthesize multipleLab;
@synthesize modesLab;
@synthesize statusLab;
@synthesize noImg1;
@synthesize nocodeLab1;
@synthesize noImg2;
@synthesize nocodeLab2;
@synthesize noImg3;
@synthesize nocodeLab3;
@synthesize noImg4;
@synthesize nocodeLab4;
@synthesize noImg5;
@synthesize nocodeLab5;
@synthesize bonusLab;
@synthesize nocodeTV;
@synthesize writetimeLab;
@synthesize cancelBtn;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [issueStr stringByAppendingString:@"期"];
    
    if (!IS_IPHONE5)
    {
        self.scrollView.contentSize = CGSizeMake(320, 617);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(320, 529);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppAPIClient sharedClient] betDetail_with_projectid:projectID block:^(id JSON, NSError *error)
    {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *resultDic = JSON;
                 
                 NSDictionary *itemDic = [resultDic objectForKey:@"result"];
                 
                 projectIDLab.text = [itemDic objectForKey:@"projectid"];
                 cnnameLab.text = [itemDic objectForKey:@"cnname"];
                 methodnameLab.text = [itemDic objectForKey:@"methodname"];
                 if ([[itemDic objectForKey:@"taskid"] isEqualToString:@"0"])
                 {
                     taskidLab.text = @"正常投注";
                 }
                 else
                 {
                     taskidLab.text = @"追号投注";
                 }
                 
                 totalpriceLab.text = [itemDic objectForKey:@"totalprice"];
                 [totalpriceLab sizeToFit];
                 multipleLab.text = [itemDic objectForKey:@"multiple"];
                 modesLab.text = [itemDic objectForKey:@"modes"];
                 if ([[itemDic objectForKey:@"isgetprize"] isEqualToString:@"0"])
                 {
                     statusLab.text = @"未开奖";
                 }
                 else if ([[itemDic objectForKey:@"isgetprize"] isEqualToString:@"2"])
                 {
                     statusLab.text = @"未中奖";
                 }
                 else if ([[itemDic objectForKey:@"isgetprize"] isEqualToString:@"1"])
                 {
                     if ([[itemDic objectForKey:@"prizestatus"] isEqualToString:@"0"])
                     {
                         statusLab.text = @"未派奖";
                     }
                     else
                     {
                         statusLab.text = @"已派奖";
                     }
                 }
                 
                 NSString *iscancel = [itemDic objectForKey:@"iscancel"];
                 switch (iscancel.intValue) {
                     case 1:
                         statusLab.text = @"本人撤单";
                         break;
                         
                     case 2:
                         statusLab.text = @"管理员撤单";
                         break;
                         
                     case 3:
                         statusLab.text = @"开错奖撤单";
                         break;
                         
                     default:
                         break;
                 }
                 
                 
                 if (![[itemDic objectForKey:@"nocode"] isEqualToString:@""])
                 {
                     noImg1.image = [UIImage imageNamed:@"Betting2-No"];
                     nocodeLab1.textColor = [UIColor whiteColor];
                     nocodeLab1.text = [[itemDic objectForKey:@"nocode"] substringWithRange:NSMakeRange(0, 1)];
                     
                     noImg2.image = [UIImage imageNamed:@"Betting2-No"];
                     nocodeLab2.textColor = [UIColor whiteColor];
                     nocodeLab2.text = [[itemDic objectForKey:@"nocode"] substringWithRange:NSMakeRange(1, 1)];
                     
                     noImg3.image = [UIImage imageNamed:@"Betting2-No"];
                     nocodeLab3.textColor = [UIColor whiteColor];
                     nocodeLab3.text = [[itemDic objectForKey:@"nocode"] substringWithRange:NSMakeRange(2, 1)];
                     
                     noImg4.image = [UIImage imageNamed:@"Betting2-No"];
                     nocodeLab4.textColor = [UIColor whiteColor];
                     nocodeLab4.text = [[itemDic objectForKey:@"nocode"] substringWithRange:NSMakeRange(3, 1)];
                     
                     noImg5.image = [UIImage imageNamed:@"Betting2-No"];
                     nocodeLab5.textColor = [UIColor whiteColor];
                     nocodeLab5.text = [[itemDic objectForKey:@"nocode"] substringWithRange:NSMakeRange(4, 1)];
                 }
                 bonusLab.text = [itemDic objectForKey:@"bonus"];
                 [bonusLab sizeToFit];
                 nocodeTV.text = [itemDic objectForKey:@"code"];
                 writetimeLab.text = [itemDic objectForKey:@"writetime"];;
                 //可否撤单
                 NSString *can = [JSON objectForKey:@"can"];
                 if ([can intValue] == 1)
                 {
                     cancelBtn.hidden = NO;
                 }
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
//撤单操作
- (IBAction)cancelClk:(id)sender
{
    [Utility showErrorWithMessage:@"您确定要撤单吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:1 duplicationPrevent:YES];
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
            [[AFAppAPIClient sharedClient] cancelBet_with_projectId:projectID block:^(id JSON, NSError *error)
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
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
