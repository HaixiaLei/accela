//
//  BetDetailViewController.m
//  JiuJiuCai
//
//  Created by Air.Zhao on 14-6-19.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetDetailViewController.h"

@interface BetDetailViewController ()
@end

@implementation BetDetailViewController
@synthesize scrollView;
@synthesize projectID;
@synthesize lotteryName;
@synthesize wanfaLab;
@synthesize jiangqiLab;
@synthesize timeLab;
@synthesize userLab;
@synthesize jinELab;
@synthesize bonusLab;
@synthesize modesLab;
@synthesize multipleLab;
@synthesize statusLab;
@synthesize codeTV;
@synthesize projectIDLab;
@synthesize cancelBtn;

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
//    if (!IS_IPHONE5)
//    {
        self.scrollView.contentSize = CGSizeMake(320, 525);
//    }
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
                 wanfaLab.text = [itemDic objectForKey:@"methodname"];
                 jiangqiLab.text = [itemDic objectForKey:@"issue"];
                 timeLab.text = [itemDic objectForKey:@"writetime"];
                 userLab.text = [itemDic objectForKey:@"username"];
                 jinELab.text = [itemDic objectForKey:@"totalprice"];
                 bonusLab.text = [itemDic objectForKey:@"bonus"];
                 modesLab.text = [itemDic objectForKey:@"modes"];
                 multipleLab.text = [itemDic objectForKey:@"multiple"];
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
                 codeTV.text = [itemDic objectForKey:@"code"];
                 projectIDLab.text = [itemDic objectForKey:@"projectid"];
                 
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
             DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}

-(IBAction)cancelClk:(UIButton *)sender
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
            
            [[AppHttpManager sharedManager] cancelOrder_WithProjectid:projectID Block:^(id JSON, NSError *error)
             {
                 if (!error)
                 {
                     if ([JSON isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *itemDic = JSON;
//                         confirmAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[[itemDic objectForKey:@"msg"] stringByAppendingString:@"!"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                         confirmAlertView.delegate = self;
//                         [confirmAlertView show];
                         
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
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
