//
//  ZHRecordsDetailViewController.m
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZHRecordsDetailViewController.h"
#import "ZHDetailObject.h"
#import "ZHDetailCell.h"

static NSString *CellIdentifier = @"ZHDetailCell";

#define anim_time 0.5

@interface ZHRecordsDetailViewController ()
@end

@implementation ZHRecordsDetailViewController
@synthesize tView;
@synthesize selectAllBtn;
@synthesize isCancel;
@synthesize taskidcode;
@synthesize cancelBtn;
@synthesize detailView;
@synthesize flagBtn;
@synthesize flagTempBtn;
@synthesize cnnameLab;
@synthesize methodnameLab;
@synthesize beginissueLab;
@synthesize taskpriceLab;
@synthesize modesLab;
@synthesize codesTV;
@synthesize begintimeLab;
@synthesize issuecountLab;
@synthesize finishedcountLab;
@synthesize cancelcountLab;
@synthesize statusLab;
@synthesize bottomLab;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([isCancel isEqualToString:@"0"])
    {
        selectAllBtn.hidden = NO;
        cancelBtn.hidden = NO;
        cancelBtn.enabled = false;
    }
    [self loadData];
    
    if (cellArray == nil)
    {
        cellArray = [[NSMutableArray alloc] init];
    }
    if (beanTwoArray == nil)
    {
        beanTwoArray = [[NSMutableArray alloc] init];
    }
    if (tempArray == nil)
    {
        tempArray = [[NSMutableArray alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"追号详情";
    
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
    [[AFAppAPIClient sharedClient] traceDetail_with_taskId:taskidcode block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 zhDetailArr = [[NSMutableArray alloc] init];
                 
                 NSArray *itemArray = [JSON objectForKey:@"aTaskdetail"];
                 for (int i = 0; i < itemArray.count; ++i)
                 {
                     id oneObject = [itemArray objectAtIndex:i];
                     if ([oneObject isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *oneObjectDict = (NSDictionary *) oneObject;
                         ZHDetailObject *zhDetailObj = [[ZHDetailObject alloc] initWithAttribute:oneObjectDict];
                         [zhDetailArr addObject:zhDetailObj];
                     }
                     else
                     {
                         DDLogWarn(@"oneObject should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
                     }
                 }
                 
                 [tView reloadData];
                 
                 for (ZHDetailObject *zhObj in zhDetailArr)
                 {
                     id iscanStr = [zhObj iscan];
                     NSString *isCanFlag = @"";
                     if ([iscanStr isKindOfClass:[NSNumber class]])
                     {
                         NSNumber *number = (NSNumber *) iscanStr;
                         isCanFlag = number.stringValue;
                     }
                     else if ([iscanStr isKindOfClass:[NSString class]])
                     {
                         isCanFlag = [zhObj iscan];
                     }
                     if ([isCanFlag isEqualToString:@"0"])
                     {
                         [tempArray addObject:zhObj];
                     }
                 }
                 
                 //加载下拉数据-begin
                 NSDictionary *taskDic = [JSON objectForKey:@"task"];
                 cnnameLab.text = [taskDic objectForKey:@"cnname"];
                 methodnameLab.text = [taskDic objectForKey:@"methodname"];
                 beginissueLab.text = [[taskDic objectForKey:@"beginissue"] stringByAppendingString:@"期"];
                 taskpriceLab.text = [taskDic objectForKey:@"taskprice"];
                 modesLab.text = [taskDic objectForKey:@"modes"];
                 codesTV.text = [taskDic objectForKey:@"codes"];
                 begintimeLab.text = [taskDic objectForKey:@"begintime"];
                 issuecountLab.text = [taskDic objectForKey:@"issuecount"];
                 finishedcountLab.text = [taskDic objectForKey:@"finishedcount"];
                 cancelcountLab.text = [taskDic objectForKey:@"cancelcount"];
                 if ([[taskDic objectForKey:@"status"] isEqualToString:@"0"])
                 {
                     statusLab.text = @"追号中";
                 }
                 else if ([[taskDic objectForKey:@"status"] isEqualToString:@"1"])
                 {
                     statusLab.text = @"已取消";
                 }
                 else
                 {
                     statusLab.text = @"已完成";
                 }
                 bottomLab.text = [[[taskDic objectForKey:@"finishedcount"] stringByAppendingString:@"/"] stringByAppendingString:[taskDic objectForKey:@"issuecount"]];
                 //加载下拉数据-end
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
        ZHDetailObject *zhDetailObj = [zhDetailArr objectAtIndex:indexPath.row];
        cell.itemBtn.tag = indexPath.row;
        //----------------------------------------全/不选时改变每个cell的状态-begin
        NSString *img = nil;
        NSString *imgName = nil;
        
        id iscanStr = [zhDetailObj iscan];
        NSString *isCanFlag = @"";
        if ([iscanStr isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber *) iscanStr;
            isCanFlag = number.stringValue;
        }
        else if ([iscanStr isKindOfClass:[NSString class]])
        {
            isCanFlag = [zhDetailObj iscan];
        }
        
        //页面初始化时，全部未选中
        if (cellArray.count == 0)
        {
            if ([zhDetailObj.flag isEqualToString:@"未选"])
            {
                if ([isCanFlag isEqualToString:@"0"])
                {
                    img = @"Multi-nomal";
                    imgName = @"Delete-bar-nomal";
                }
                else
                {
                    img = @"Multi-select-nomal";
                    imgName = @"Delete-bar-nomal";
                }
            }
            else
            {
                if ([isCanFlag isEqualToString:@"0"])
                {
                    img = @"Multi-nomal";
                    imgName = @"Delete-bar-nomal";
                }
                else
                {
                    img = @"Multi-select-nomal";
                    imgName = @"Delete-bar-nomal";
                }
            }
        }
        //滑动页面之后，记录之前的状态
        else
        {
            if ([isCanFlag isEqualToString:@"0"])
            {
                img = @"Multi-nomal";//空心
                imgName = @"Delete-bar-nomal";
            }
            else
            {
                img = @"Multi-select-nomal";//带灰心
                imgName = @"Delete-bar-nomal";
            }
            for(NSString *string in cellArray)
            {
                if ([string intValue] == indexPath.row)
                {
                    if ([isCanFlag isEqualToString:@"1"])//0-追号中
                    {
                        if ([zhDetailObj.flag isEqualToString:@"未选"])
                        {
                            img = @"Multi-select-nomal";//带灰心
                            imgName = @"Delete-bar-nomal";
                        }
                        else
                        {
                            img = @"Multi-select-pressed";//红心
                            imgName = @"Delete-bar-pressed";
                        }
                    }
                }
            }
        }
        [cell.itemBtn setImage:[UIImage imageNamed:img]];
        [cell.itemImg setImage:[UIImage imageNamed:imgName]];
        //----------------------------------------全/不选时改变每个cell的状态-end
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHDetailObject *zhObj = [zhDetailArr objectAtIndex:indexPath.row];
    
    id iscanStr = [zhObj iscan];
    NSString *isCanFlag = @"";
    if ([iscanStr isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = (NSNumber *) iscanStr;
        isCanFlag = number.stringValue;
    }
    else if ([iscanStr isKindOfClass:[NSString class]])
    {
        isCanFlag = [zhObj iscan];
    }
    
    if ([isCanFlag isEqualToString:@"1"])
    {
        [cellArray addObject:[NSString stringWithFormat:@"%li", indexPath.row]];
        
        if ([zhObj.flag isEqualToString:@"未选"])
        {
            [zhObj setFlag:@"已选"];
        }
        else
        {
            [zhObj setFlag:@"未选"];
        }
        
        int times = 0;
        [beanTwoArray removeAllObjects];
        for (ZHDetailObject *zhObj in zhDetailArr)
        {
            if ([zhObj.flag isEqualToString:@"已选"])
            {
                [beanTwoArray addObject:zhObj];
                ++times;
            }
        }
        zhTimes = zhDetailArr.count - tempArray.count;
        //DLog(@"-------------------zhTimes---------------------%i", zhDetailArr.count - tempArray.count);
        //DLog(@"--------------------times----------------------%i", times);
        if (zhTimes == times)
        {
            selectAllBtn.selected  = YES;
        }
        else
        {
            selectAllBtn.selected = NO;
        }
        
        [tView reloadData];
        
        if (beanTwoArray.count == 0)
        {
            cancelBtn.enabled = false;
        }
        else
        {
            cancelBtn.enabled = true;
        }
    }
}
//tableView-end

//全选
- (IBAction)btnSelectAllClick:(id)sender
{
    [cellArray removeAllObjects];
    [beanTwoArray removeAllObjects];
    
    selectAllBtn.selected = !selectAllBtn.selected;
    
    if (selectAllBtn.selected)
    {
        for(int i=0; i<zhDetailArr.count; i++)
        {
            [cellArray addObject:[NSString stringWithFormat:@"%i", i]];
            ZHDetailObject *zhObj = [zhDetailArr objectAtIndex:i];
            
            id iscanStr = [zhObj iscan];
            NSString *isCanFlag = @"";
            if ([iscanStr isKindOfClass:[NSNumber class]])
            {
                NSNumber *number = (NSNumber *) iscanStr;
                isCanFlag = number.stringValue;
            }
            else if ([iscanStr isKindOfClass:[NSString class]])
            {
                isCanFlag = [zhObj iscan];
            }
            
            if ([isCanFlag isEqualToString:@"1"])
            {
                [zhObj setFlag:@"已选"];
            }
            //全选时，把数据装到beanTwoArray
            [beanTwoArray removeAllObjects];
            for (ZHDetailObject *zhObj in zhDetailArr)
            {
                if ([zhObj.flag isEqualToString:@"已选"])
                {
                    [beanTwoArray addObject:zhObj];
                }
            }
        }
    }
    else
    {
        for(int i=0; i<zhDetailArr.count; i++)
        {
            ZHDetailObject *zhObj = [zhDetailArr objectAtIndex:i];
            
            id iscanStr = [zhObj iscan];
            NSString *isCanFlag = @"";
            if ([iscanStr isKindOfClass:[NSNumber class]])
            {
                NSNumber *number = (NSNumber *) iscanStr;
                isCanFlag = number.stringValue;
            }
            else if ([iscanStr isKindOfClass:[NSString class]])
            {
                isCanFlag = [zhObj iscan];
            }
            
            if ([isCanFlag isEqualToString:@"1"])
            {
                [zhObj setFlag:@"未选"];
            }
        }
    }
    //NSLog(@"---数组大小--->%i", [beanTwoArray count]);
    [tView reloadData];
    
    if (beanTwoArray.count == 0)
    {
        cancelBtn.enabled = false;
    }
    else
    {
        cancelBtn.enabled = true;
    }
}

//撤单操作
- (IBAction)cancelClk:(id)sender
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
            for (ZHDetailObject *zhObj in beanTwoArray)
            {
                [entryStr appendString:[zhObj.entry stringByAppendingString:@","]];
            }
            [[AFAppAPIClient sharedClient] cancelTrace_with_taskId:taskidcode detailId:[entryStr substringToIndex:entryStr.length-1] block:^(id JSON, NSError *error)
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
    else if (alertView.tag == 2)
    {
        [self.navigationController popViewControllerAnimated:YES];
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
