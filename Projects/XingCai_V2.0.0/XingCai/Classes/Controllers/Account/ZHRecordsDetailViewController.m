//
//  ZHRecordsDetailViewController.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZHRecordsDetailViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "ZhuiHaoItemObject.h"
#import "ZHDetailCell.h"

static NSString *CellIdentifier = @"ZHDetailCell";

#define anim_time 0.5

@interface ZHRecordsDetailViewController ()
@end

@implementation ZHRecordsDetailViewController
@synthesize tView;
@synthesize isCancel;
@synthesize taskID;
@synthesize cancelBtn;
@synthesize detailView;
@synthesize flagBtn;
@synthesize flagTempBtn;

@synthesize lotteryName;
@synthesize userLab;
@synthesize jiangqiLab;
@synthesize timeLab;
@synthesize wanfaLab;
@synthesize modesLab;
@synthesize zhuiHaoJinELab;
@synthesize issueCountLab;
@synthesize finishPriceLab;
@synthesize finishedCountLab;
@synthesize taskSumBonusLab;
@synthesize stopOnWinLab;
@synthesize taskIDLab;
@synthesize codesTV;

- (void)viewWillAppear:(BOOL)animated
{
    if ([isCancel isEqualToString:@"0"])
    {
        cancelBtn.hidden = NO;
    }else{
        self.revokeView.hidden = YES;
        self.scroBG.frame = self.view.bounds;
        self.tView.frame = self.scroBG.bounds;
    }
    
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBarTitle:@"追号详情" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    if (!IS_IPHONE5)
    {
        tView.size = CGSizeMake(320, 371);
    }
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
                 zhDetailArr = [[NSMutableArray alloc] init];
                 
                 lotteryName.text = [itemDic objectForKey:@"cnname"];
                 userLab.text = [itemDic objectForKey:@"username"];
                 jiangqiLab.text = [itemDic objectForKey:@"beginissue"];
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
                 
                 taskIDLab.text = [itemDic objectForKey:@"taskid"];
                 codesTV.text = [itemDic objectForKey:@"codes"];
                 
                 //下边列表
                 NSArray *itemArray = [JSON objectForKey:@"taskDetail"];
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         ZhuiHaoItemObject *zhItemListObj = [[ZhuiHaoItemObject alloc] initWithAttribute:oneObjectDict];
                         [zhDetailArr addObject:zhItemListObj];
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
//tableView-begin
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [zhDetailArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerNib:[UINib nibWithNibName:@"ZHDetailCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    ZHDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //去掉UITableView中cell的边框和分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (zhDetailArr.count>0)
    {
        ZhuiHaoItemObject *zhDetailObj = [zhDetailArr objectAtIndex:indexPath.row];
        [cell updateZHDetailObject:zhDetailObj];
    }
    return cell;
}

//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPa
{
    return 0;
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}
//tableView-end


//撤单操作
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
            for (int i=0; i<zhDetailArr.count; i++)
            {
                ZhuiHaoItemObject *zhItemObj = [zhDetailArr objectAtIndex:i];
                if ([[zhItemObj status] isEqualToString:@"0"])
                {
                    [entryStr appendString:[[zhItemObj entry] stringByAppendingString:@","]];
                }
            }
            if ([entryStr isEqualToString:@""])
            {
                [Utility showErrorWithMessage:@"该单已撤，请勿重复操作!" delegate:self tag:3];
                self.revokeView.hidden = YES;
                self.scroBG.frame = self.view.bounds;
                self.tView.frame = self.scroBG.bounds;
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

//抽屉------------------------------------------------------begin
-(void) showView
{
    flagTempBtn.hidden = YES;
    flagBtn.hidden = NO;
    
    hidden = YES;
    isAnimating = YES;
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:anim_time];
    [UIView animateWithDuration:anim_time animations:^(void)
    {
        [self.tView setFrame:CGRectMake(0, self.tView.frame.origin.y+320, 320, self.tView.frame.size.height)];
        [self.detailView setFrame:CGRectMake(0, self.detailView.frame.origin.y+320, 320, self.detailView.frame.size.height)];
    }];
    [flagBtn setFrame:CGRectMake(145, self.detailView.frame.origin.y+320, 23, 9)];
    [flagBtn setImage:[UIImage imageNamed:@"Dropdown-pressed"] forState:UIControlStateNormal];
}

-(void) hideView
{
    hidden = NO;
    isAnimating = YES;
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:anim_time];
    [UIView animateWithDuration:anim_time animations:^(void)
    {
        [self.tView setFrame:CGRectMake(0, self.tView.frame.origin.y-320, 320, self.tView.frame.size.height)];
        [self.detailView setFrame:CGRectMake(0, self.detailView.frame.origin.y-320, 320, self.detailView.frame.size.height)];
    }
    completion:^(BOOL finished)
    {
        //滚动的顶部
        [self.tView  setContentOffset:CGPointMake(0, 0) animated:YES];
        
        flagTempBtn.hidden = NO;
        flagBtn.hidden = YES;
        [flagBtn setFrame:CGRectMake(145, 0, 23, 9)];
        [flagBtn setImage:[UIImage imageNamed:@"Dropdown-nomal"] forState:UIControlStateNormal];
    }];
}

-(void)endAnimation:(id)sender
{
    @synchronized(self)
    {
        isAnimating = NO;
    }
}

#pragma mark - scroll

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 25)
    {
        _lastPosition = currentPostion;
        
        if (isAnimating)
        {
            return;
        }
        if (hidden)
        {
            [self hideView];
        }
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        
        if (isAnimating)
        {
            return;
        }
        if (scrollView.contentOffset.y < 0 && !hidden)
        {
            [self showView];
        }
    }
}
//抽屉------------------------------------------------------end
@end
