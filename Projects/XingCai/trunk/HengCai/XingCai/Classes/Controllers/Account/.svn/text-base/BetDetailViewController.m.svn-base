//
//  BetDetailViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-6-29.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetDetailViewController.h"

@interface BetDetailViewController ()
@end

@implementation BetDetailViewController
@synthesize containerView;
@synthesize scrollView;
@synthesize projectID;
@synthesize cancelBtn;
@synthesize lotteryName;
@synthesize jiangqiLab;
@synthesize userLab;
@synthesize timeLab;
@synthesize wanfaLab;
@synthesize modesLab;
@synthesize jinELab;
@synthesize multipleLab;
@synthesize bonusLab;
@synthesize statusLab;
@synthesize projectIDLab;
@synthesize codeTV;

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
- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0)
    {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustView];
    if (!IS_IPHONE5)
    {
        self.scrollView.contentSize = CGSizeMake(320, 590);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(320, 505);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBtnClk:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] betDetail_WithProjectid:projectID Block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *itemDic = JSON;
                 
                 lotteryName.text = [itemDic objectForKey:@"cnname"];
                 jiangqiLab.text = [[@"第" stringByAppendingString:[itemDic objectForKey:@"issue"]] stringByAppendingString:@"期"];
                 userLab.text = [itemDic objectForKey:@"username"];
                 timeLab.text = [itemDic objectForKey:@"writetime"];
                 wanfaLab.text = [itemDic objectForKey:@"methodname"];
                 modesLab.text = [itemDic objectForKey:@"modes"];
                 jinELab.text = [itemDic objectForKey:@"totalprice"];
                 multipleLab.text = [[itemDic objectForKey:@"multiple"] stringByAppendingString:@"倍"];
                 bonusLab.text = [itemDic objectForKey:@"bonus"];

                 if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"1"])
                 {
                     statusLab.text = @"本人撤单";
                 }
                 else if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"2"])
                 {
                     statusLab.text = @"平台撤单";
                 }
                 else if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"3"])
                 {
                     statusLab.text = @"错开撤单";
                 }
                 else if ([[itemDic objectForKey:@"iscancel"] isEqualToString:@"0"])
                 {
                     if ([[itemDic objectForKey:@"isgetprize"] isEqualToString:@"0"])
                     {
                         statusLab.text = @"未开奖";
                     }
                     else if ([[itemDic objectForKey:@"isgetprize"] isEqualToString:@"2"])
                     {
                         statusLab.text = @"未中奖";
                     }
                     else
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
                 }
                 projectIDLab.text = [itemDic objectForKey:@"projectid"];
                 codeTV.text = [itemDic objectForKey:@"code"];
                 
                 NSString *canStr;
                 id canFlag = [itemDic objectForKey:@"can"];
                 if ([canFlag isKindOfClass:[NSNumber class]])
                 {
                     NSNumber *number = (NSNumber *) canFlag;
                     canStr = number.stringValue;
                 }
                 else if ([canFlag isKindOfClass:[NSString class]])
                 {
                     canStr = [itemDic objectForKey:@"can"];
                 }
                 if ([canStr isEqualToString:@"1"])
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
-(IBAction)cancelClk:(UIButton *)sender
{
    alertFlag = 1;
    [Utility showErrorWithMessage:@"您确定要撤单吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:1 duplicationPrevent:YES];
}
- (void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertFlag == 1)
    {
        if (buttonIndex == 0)
        {}
        else
        {
            alertFlag = 2;
            cancelBtn.enabled = false;
            
            [[AppHttpManager sharedManager] cancelOrder_WithProjectid:projectID Block:^(id JSON, NSError *error)
             {
                 if (!error)
                 {
                     if ([JSON isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *itemDic = JSON;
                         [Utility showErrorWithMessage:[[itemDic objectForKey:@"msg"] stringByAppendingString:@"!"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil tag:1 duplicationPrevent:YES];
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
    else if (alertFlag == 2)
    {
        if (buttonIndex == 0)
        {
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BetSearchUpdateStatus" object:nil];
            //返回前一页后改状态
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
