//
//  BuyViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "BuyViewController.h"
#import "BuyChooseViewController.h"
#import "OpenLotteryObject.h"
#import "OpenLotteryDetailViewController.h"
#import "KindOfLottery.h"
#import "AppCacheManager.h"
#import "LoginViewController.h"
#import "RecordsViewController.h"

#import "MyProfile.h"
#import "NSUserDefaultsManager.h"
#import "UserInfomation.h"
#import "AccountViewController.h"
#import "LoginViewController.h"
#import "AnnouncementViewController.h"
#import "ATMViewController.h"
#import "BetSearchViewController.h"
#import "ZhuiHaoViewController.h"
#import "RecordsViewController.h"
#import "CashViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "UIImageView+WebCache.h"
#define BASETAG1    1024

#define NotificationNameCleanBalance @"NotificationNameCleanBalance"
@implementation BuyViewController
{
    NSMutableArray *timeStringArray;
    NSMutableArray *currentJiangQiArray;
    UIButton *refreshButton;
}
@synthesize tixianPin;

#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        currentJiangQiArray = [[NSMutableArray alloc]initWithArray:@[@"暂无",@"暂无",@"暂无",@"暂无"]];
        timeStringArray = [[NSMutableArray alloc]initWithArray:@[@"暂无",@"暂无",@"暂无",@"暂无"]];
        int y=self.scrollview.frame.origin.y;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
  self.grzxBtn.enabled=YES;
    self.tableView.contentOffset= CGPointZero;
    
    MyProfile *myprofile =[[MyProfile alloc]init];
    
    NSString *name=[myprofile getUserName];
  
    
    UserName.text=name;
    
   self.tixianPin.text=@"";
    self.tianxianView.hidden=YES;
    self.tixianBGView.hidden=YES;
    
    [self getAvatar];
    [self getBalance];
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buyBGView setBackgroundColor:[UIColor colorWithRed:224/255.0 green:221/255.0 blue:213/255.0 alpha:1]];

    if (SystemVersion>=7.0)
    {
        NSLog(@"%f",self.loadingImg.frame.origin.y);
        self.loadingImg.point=CGPointMake(0, -20);
        if (!IS_IPHONE5) {
            self.scrollview.point=CGPointMake(0, 188);
             self.naviBarView.point=CGPointMake(0, 88);
            self.tableView.point=CGPointMake(50, 328);
            self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 100, 0);
            self.kaijiangBtn.point=CGPointMake(69, 290);
            self.tixianBtn.point=CGPointMake(189, 290);
        }
    }
    else
    {
        if (!IS_IPHONE5)
        {
            self.scrollview.point=CGPointMake(0, 168);
            self.naviBarView.point=CGPointMake(0, 68);
            self.tableView.point=CGPointMake(50, 308);
            self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 100, 0);
            self.kaijiangBtn.point=CGPointMake(69, 270);
            self.tixianBtn.point=CGPointMake(189, 270);
        }
    }
    
    // 3.1.下拉刷新
    [self addHeader];
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(getScrollAdInfo)
                                                  name:UIApplicationWillEnterForegroundNotification
                                                object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLotteryList) name:NotificationNameUpdateLotteryList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime:) name:NotificationUpdateTime object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJiangQi:) name:NotificationUpdateJiangQi object:nil];
    tixianPin.delegate = self;
}
-(void)getScrollAdInfo
{
    NSMutableArray*imgviewArr=[[NSMutableArray alloc]init];
  
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getAdWithBlock:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *dictionary = (NSDictionary *)JSON;
                 id resultsObject = [dictionary objectForKey:@"results"];
                 if ([resultsObject isKindOfClass:[NSArray class]]) {
                     NSArray *results = (NSArray *)resultsObject;
                     int a= results.count;
                   
                     NSMutableArray *activity_ids = [NSMutableArray array];
                     for (int i=0; i<results.count; i++) {
                         NSDictionary *dic=[results objectAtIndex:i];
                         
                         NSString *activity_img = [dic objectForKey:@"activity_cover"];
                         NSString *activity_id = [dic objectForKey:@"activity_id"];
                         [activity_ids addObject:activity_id];
                         
                         
                         UIImageView *imgview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 226)];
                         
                         UIButton *item=[UIButton buttonWithType:UIButtonTypeCustom];
                         
                         item.frame=CGRectMake(0, 0, 320, 126);
                         [imgview addSubview:item];
                        
                         NSURL *imgurl =[NSURL URLWithString:activity_img];
//                         UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
//                         imgview.image=img;
                         [imgview setImageWithURL:imgurl];
                         item.tag=i;
                         [item addTarget:self action:@selector(gotoEvent:) forControlEvents:UIControlEventTouchUpInside];
                         [imgviewArr addObject:imgview];
                         
                     }
                     array_id = [NSArray arrayWithArray:activity_ids];
                     
                     [self.mainScorllView removeFromSuperview];
                     if (SystemVersion>=7.0) {
                        
                         self.mainScorllView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, -20, 320, 226) animationDuration:3];
                         
                     }else{
                         self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 226) animationDuration:3];
                     }
                     self.mainScorllView.backgroundColor = [UIColor clearColor];
                     
                     self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                         return imgviewArr[pageIndex];
                     };
                     self.mainScorllView.totalPagesCount = ^NSInteger(void){
                         return a;
                     };
                     //                     self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                     //                         [self gotoEvent:pageIndex];
                     //                         //        NSLog(@"点击了第%d个",pageIndex);
                     //                     };
                     //        [self.view addSubview:self.mainScorllView];
                     [self.scrollview addSubview:self.mainScorllView];
                     
                 }
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
    


}
-(void) getBalance
{
    [[AppHttpManager sharedManager] getBalanceWithBlock:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSString class]])
             {
                 myMoney.text =[@"余额: " stringByAppendingString:JSON];
             }
             else
             {
                 DDLogWarn(@"JSON should be NSString,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
             if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"] && ![UserInfomation sharedInfomation].shouldLoginAgain) {
                 [Utility showErrorWithMessage:[JSON objectForKey:@"msg"]];
                 DDLogDebug(@"Utility showErrorMessage:%@",[JSON objectForKey:@"msg"]);
             }
         }
     }];
}

- (void)getAvatar
{
    [[AppHttpManager sharedManager] getAvatarWithBlock:^(id JSON, NSError *error)
     {
        
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *dictionary = (NSDictionary *)JSON;
                 if ([dictionary.allKeys containsObject:@"head_portrait"]) {
                     NSString *avatarId = [dictionary objectForKey:@"head_portrait"];
                     [self setAvatarImageWithIndex:[avatarId integerValue]];
                 }
             }
         }
         else
         {
             [self.photo setImage:[UIImage imageNamed:@"user_portrait"]];
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}

- (void)setAvatarImageWithIndex:(NSInteger)avatarId
{
    NSString *imageName = [AvatarView avatarImageNameFromIndex:avatarId];
    self.photo.image = [UIImage imageNamed:imageName];
    [[NSUserDefaults standardUserDefaults]setObject:imageName forKey:@"myPhoto"];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoEvent:(id)sender
{
    UIButton *button=(UIButton *)sender;
    NSLog(@"%ld",(long)button.tag);
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.5;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    transition.type = kCATransitionFade; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //将动画添加在视图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
//    [self.navigationController popViewControllerAnimated:NO];

    eventView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,IS_IPHONE5?568:480)];
    
    [self.view addSubview:eventView];
    
    UIImageView *backimg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [backimg setImage:[UIImage imageNamed:@"bk_login"]];
    [eventView addSubview:backimg];
    
    UIImageView *Navigekimg =[[UIImageView alloc]init];
    [Navigekimg setImage:[UIImage imageNamed:@"Top_bar"]];
    [eventView addSubview:Navigekimg];
    
    UIButton *backtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [backtn setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [eventView addSubview:backtn];
    [backtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *kindLable =[[UILabel alloc] init];
    kindLable.text=@"99彩活动";
    [kindLable setBackgroundColor:[UIColor clearColor]];
    kindLable.font = [UIFont systemFontOfSize:17];
    kindLable.textAlignment=UITextAlignmentCenter;
    kindLable.textColor=[UIColor whiteColor];
    [eventView addSubview:kindLable];
        adWebVeiwe =[[UIWebView alloc]init];
        adWebVeiwe.delegate=self;
        [eventView addSubview:adWebVeiwe];
    if (SystemVersion>=7.0)
    {
        Navigekimg.frame = CGRectMake(0, 0, 320, 69);
        backtn.frame = CGRectMake(0, 22, 40, 40);
        kindLable.frame = CGRectMake(60, 27, 200, 30);
        adWebVeiwe.frame=CGRectMake(0, 64, 320, IS_IPHONE5?504:416);
    }
    else
    {
        Navigekimg.frame = CGRectMake(0, 0, 320, 44);
        backtn.frame = CGRectMake(0, 2, 40, 40);
        kindLable.frame = CGRectMake(60, 7, 200, 30);
        adWebVeiwe.frame=CGRectMake(0, 44, 320, IS_IPHONE5?504:416);
    }
  
    [[AppHttpManager sharedManager] getAdDetailWithActivityId:[array_id objectAtIndex:button.tag] Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 
                 NSDictionary *dictionary = (NSDictionary *)JSON;
                 NSLog(@"%@",dictionary);
                 NSString *content = [dictionary objectForKey:@"activity_content"];
                
                 [adWebVeiwe loadHTMLString:content baseURL:nil];
        
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
-(void)gotoBack{
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.5;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    transition.type = kCATransitionReveal; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //将动画添加在视图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    

    eventView.hidden=YES;
}
#pragma mark - 获取数据
- (void)getLotteryList
{
    kindOfLotteries = [[AppCacheManager sharedManager] getLotteryList];

    [self.tableView reloadData];
    
    if (kindOfLotteries.count == 0) {
        if (!refreshButton) {
            refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            [refreshButton setTitle:@"点击刷新" forState:UIControlStateNormal];
            [refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [refreshButton addTarget:self action:@selector(updateLotteryList) forControlEvents:UIControlEventTouchUpInside];
            refreshButton.center = self.view.center;
            [self.view addSubview:refreshButton];
        }
        refreshButton.hidden = NO;
    }
    else
    {
        refreshButton.hidden = YES;
        [self tryToGetJiangqi];
    }
}

- (void)updateLotteryList
{
    refreshButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppCacheManager sharedManager] updateLotteryListWithBlock:^(NSError *error){
        //如果没有错，或者错误不是LotteryList报的（可能是玩法获取报错）
        if (!error || (error && ![error.domain isEqualToString:AppCacheManagerErrorDomain])) {
            [self getLotteryList];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        refreshButton.enabled = YES;
    }];
}
#pragma mark - UI数据刷新
-(void)showKindOfLotteryInTopCell:(UITableViewCell*)topCell Object:(KindOfLottery *)object WithIndexRow:(int)indexPath
{
    
    UIView *bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 10, 265, 97)];
    bgView.layer.cornerRadius=5;
//    lotteryView.layer.cornerRadius=5;
//    lotteryView.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:.9];

    [topCell addSubview:bgView];
//     [topCell addSubview:lotteryView];
    KindOfLottery *kindlottery = [kindOfLotteries objectAtIndex:indexPath];
    UIButton *caiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    caiBtn.frame = CGRectMake(10 ,12, 68.5, 68.5);
//    caiBtn.enabled=NO;
    UIImage *backgroundImage;
    
    UILabel *tipslabel =[[UILabel alloc]initWithFrame:CGRectMake(80, 43,170, 30)];
    tipslabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17.0f];
    tipslabel.textAlignment = NSTextAlignmentCenter;
    tipslabel.textColor =[UIColor lightGrayColor];
    [tipslabel setBackgroundColor:[UIColor clearColor]];
    
    [bgView addSubview:tipslabel];
    
    
    UILabel *kindOtteryname =[[UILabel alloc]initWithFrame:CGRectMake(80,20, 150, 30)];
    kindOtteryname.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    kindOtteryname.textAlignment = NSTextAlignmentCenter;
    [kindOtteryname setBackgroundColor:[UIColor clearColor]];
    kindOtteryname.text=object.cnname;
    
    //写死，不要问。
    if([object.cnname isEqualToString:@"印尼五分彩"])
    {
        kindOtteryname.text = @"印尼五分彩";
    }
    kindOtteryname.textColor=[UIColor whiteColor];
    [topCell addSubview:kindOtteryname];

    
    if ([kindlottery.cnname isEqualToString:@"重庆时时彩"]) {
        backgroundImage = [UIImage imageNamed:@"icon_cq"];
         bgView.backgroundColor=[UIColor colorWithRed:10/255.0 green:89/255.0 blue:187/255.0 alpha:.7];
    }
    if ([kindlottery.cnname isEqualToString:@"印尼五分彩"]) {
        backgroundImage = [UIImage imageNamed:@"icon_henei"];
        bgView.backgroundColor=[UIColor colorWithRed:8/255.0 green:163/255.0 blue:196/255.0 alpha:.7];
    }
    if ([kindlottery.cnname isEqualToString:@"江西时时彩"]) {
        backgroundImage = [UIImage imageNamed:@"icon_jx"];
        tipslabel.text=@"敬请期待 即将上线....";
        tipslabel.textColor = [UIColor colorWithRed:232/255.0 green:177/255.0 blue:255/255.0 alpha:.7];
        bgView.backgroundColor=[UIColor colorWithRed:135/255.0 green:23/255.0 blue:182/255.0 alpha:.7];
    }
    if ([kindlottery.cnname isEqualToString:@"新疆时时彩"]) {
        backgroundImage = [UIImage imageNamed:@"icon_xj"];
        tipslabel.text=@"敬请期待 即将上线....";
        tipslabel.textColor = [UIColor colorWithRed:255/255.0 green:193/255.0 blue:203/255.0 alpha:.7];
         bgView.backgroundColor=[UIColor colorWithRed:203/255.0 green:7/255.0 blue:44/255.0 alpha:.7];
    }
    [caiBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    [bgView addSubview:caiBtn];
}

//-(void)modelCellFill:(UITableViewCell *)cell Object:(KindOfLottery *)object rowInd:(int)rowIndex
//{
//    UILabel *typeLab = (UILabel *)[cell viewWithTag:BASETAG1];
//    if(typeLab == nil)
//    {
//        typeLab = [[UILabel alloc] initWithFrame:CGRectMake(86, 22, 90, 20)];
//        typeLab.tag = BASETAG1;
//        typeLab.font = [UIFont systemFontOfSize:18];
//        typeLab.textColor = [UIColor purpleColor];
//        typeLab.backgroundColor = [UIColor clearColor];
//        [cell addSubview:typeLab];
//    }
//    typeLab.text = object.cnname;
//}
//

#pragma mark - UITableView Delegate
//返回某个表视图有多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return [kindOfLotteries count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *HeadCellIdentifier = @"HeadCell";
//    static NSString *CellIdentifier = @"Cell";
    
    
//    UITableViewCell *cell;
   
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (!cell) {
    //cell 设置成不可重用
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
              
             KindOfLottery *kindOfLottery = [kindOfLotteries objectAtIndex:[indexPath row]];
            [self showKindOfLotteryInTopCell:cell Object:kindOfLottery WithIndexRow:(int)(indexPath.row)];
    
            UILabel *djsLabel;
            UILabel *jqLabel;
            if (indexPath.row == 0 || indexPath.row == 1) {
                djsLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 200, 20)];
                djsLabel.font = [UIFont systemFontOfSize:13];
                djsLabel.textColor = [UIColor whiteColor];
                djsLabel.backgroundColor = [UIColor clearColor];
                djsLabel.numberOfLines = 0;
                [cell addSubview:djsLabel];
                jqLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 52, 150, 20)];
                jqLabel.font = [UIFont systemFontOfSize:13];
                jqLabel.textColor = [UIColor whiteColor];
                jqLabel.backgroundColor = [UIColor clearColor];
                jqLabel.numberOfLines = 0;
                [cell addSubview:jqLabel];
            }
            
//        }
    
        djsLabel.text =[NSString stringWithFormat:@"投注截止:%@",timeStringArray[indexPath.row]];
        jqLabel.text =[NSString stringWithFormat:@"奖期:%@",currentJiangQiArray[indexPath.row]];
    return  cell;
}

//设置每行缩进级别
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 106;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //没有奖期跳转会cash
    if (indexPath.row == 0 || indexPath.row == 1) {
        KindOfLottery *kindOfLottery = [kindOfLotteries objectAtIndex:indexPath.row];
        NSArray *ruleAndMenuArray = [[AppCacheManager sharedManager] getMenuAndRuleWithKindOfLottery:kindOfLottery];
        
        if (ruleAndMenuArray.count > 0) {
            
            if (!kindOfLottery.currentJiangQi) {
                [Utility showErrorWithMessage:@"奖期未获取成功，请稍后重试"];
                [[JiangQiManager sharedManager] updateAllJiangQi];
                return;
            }
            else if(!kindOfLottery.keZhuiHaoJiangQis.count) {
                [Utility showErrorWithMessage:@"可追号奖期未获取成功，请稍后重试"];
                [[JiangQiManager sharedManager] updateAllJiangQi];
                return;
            }
            [self jumpToBuyLotteryAtIndex:(int)(indexPath.row)];
        }
        else
        {
           
            [Utility showErrorWithMessage:[[AppCacheManager sharedManager] menuAndRuleErrorMsgWithKindOfLottery:kindOfLottery] delegate:self tag:AlertViewTypeMenuAndRuleError];
            
        }
    }
}
#pragma mark - 动作事件
//跳转到购彩大厅
-(void)jumpToBuyLotteryAtIndex:(int)index
{
    BuyChooseViewController *bcVC = [[BuyChooseViewController alloc] initWithNibName:@"BuyChooseViewController" bundle:nil];
    bcVC.hidesBottomBarWhenPushed = YES;
    bcVC.kindOfLottery = [kindOfLotteries objectAtIndex:index];
    [self.navigationController pushViewController:bcVC animated:YES];
}
//-(void)kindOfLotteryClicked:(UIButton *)sender
//{
//    [self jumpToBuyLotteryAtIndex:sender.tag];
//}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    float y=scrollView.contentOffset.y;
  
//    self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+y, self.tableView.frame.size.width, self.tableView.frame.size.height+y);

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float y=scrollView.contentOffset.y;
   
    
}
#pragma mark - 奖期
//获取奖期
- (void)tryToGetJiangqi
{
    [[JiangQiManager sharedManager] updateAllJiangQi];
}

//- (void)error:(NSError *)error Json:(id)JSON
//{
//    if ([JSON containsObject:@"msg"]) {
//        if (error.code == AppServerErrorIssueEmpty1 || error.code == AppServerErrorIssueEmpty2)
//        {
//            [Utility showErrorWithMessage:[JSON objectForKey:@"msg"] delegate:self tag:AlertViewTypeErrorIssueEmpty];
//        }
//        else if (error.code == AppServerErrorIssueNotEnough)
//        {
//            [Utility showErrorWithMessage:[JSON objectForKey:@"msg"] delegate:self tag:AlertViewTypeErrorIssueNotEnough];
//        }
//    }
//}
- (void)updateTime:(NSNotification *)notification
{
    if (![notification.object isKindOfClass:[KindOfLottery class]]) return;
    KindOfLottery *kindOfLottery = notification.object;
    if ([kindOfLottery.cnname isEqualToString:@"重庆时时彩"]) {
        [timeStringArray replaceObjectAtIndex:0 withObject:kindOfLottery.timeString];
    } else if ([kindOfLottery.cnname isEqualToString:@"印尼五分彩"]) {
        [timeStringArray replaceObjectAtIndex:1 withObject:kindOfLottery.timeString];
    }
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}
- (void)updateJiangQi:(NSNotification *)notification
{
    if (![notification.object isKindOfClass:[KindOfLottery class]]) return;
    KindOfLottery *kindOfLottery = notification.object;
    if ([kindOfLottery.cnname isEqualToString:@"重庆时时彩"]) {
        [currentJiangQiArray replaceObjectAtIndex:0 withObject:kindOfLottery.currentJiangQi];
    } else if ([kindOfLottery.cnname isEqualToString:@"印尼五分彩"]) {
        [currentJiangQiArray replaceObjectAtIndex:1 withObject:kindOfLottery.currentJiangQi];
    }
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    DDLogDebug(@"setTime = %f",startTime);
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertViewTypeMenuAndRuleError) {
        [self updateLotteryList];
    }
}
- (IBAction)gotoDengLu:(id)sender {
    
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.5;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    transition.type = kCATransitionPush; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //将动画添加在视图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController pushViewController:loginVC animated:NO];
    [self presentViewController:loginVC animated:NO completion:nil];
    
}

- (IBAction)gotoGeRenZhongXin:(id)sender {
    self.grzxBtn.enabled=NO;
    AccountViewController *accountVC=[[AccountViewController alloc]initWithNibName:@"AccountViewController" bundle:nil];
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.6;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //将动画添加在视图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController pushViewController:accountVC animated:NO];
}

- (IBAction)gotoKaijiangInfo:(id)sender
{
    RecordsViewController *recordsVC=[[RecordsViewController alloc]initWithNibName:@"RecordsViewController" bundle:nil];
    [self.navigationController pushViewController:recordsVC animated:YES];
}

- (IBAction)gotoQuxian:(id)sender
{
    if (!IS_IPHONE5)
    {
        self.tixianBGView.point=CGPointMake(0, 90);
    }
    self.tianxianView.hidden=NO;
    self.tixianBGView.hidden=NO;
}


- (IBAction)gotoAnnouncementViewcontroller:(id)sender {
    AnnouncementViewController *announcementVC=[[AnnouncementViewController alloc]initWithNibName:@"AnnouncementViewController" bundle:nil];
    [self.navigationController pushViewController:announcementVC animated:YES];
}

- (IBAction)gotoATMviewController:(id)sender {
    
    ATMViewController *atmVC =[[ATMViewController alloc]initWithNibName:@"ATMViewController" bundle:nil];

    [self.navigationController pushViewController:atmVC animated:YES];
}

- (IBAction)gotoBetSearchViewController:(id)sender {
    BetSearchViewController *betVC= [[BetSearchViewController alloc]initWithNibName:@"BetSearchViewController" bundle:nil];
    [self.navigationController pushViewController:betVC animated:YES];
}

- (IBAction)gotoZhuiHaoViewController:(id)sender {
    ZhuiHaoViewController *zhuihaoVC =[[ZhuiHaoViewController alloc]initWithNibName:@"ZhuiHaoViewController" bundle:nil];
    [self.navigationController pushViewController:zhuihaoVC animated:YES];
}

- (IBAction)confirmToTixian:(id)sender
{
    [self.tixianPin resignFirstResponder];
    if ([self.tixianPin.text isEqualToString:@""])
    {
        [Utility showErrorWithMessage:@"提款密码不能为空!"];
        return;
    }
    
    self.confirmButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] ziJinMiMaYanZhengWithPassword:self.tixianPin.text Block:^(id JSON, NSError *error)
     {
         if (!error)
         {
             NSString *check = [JSON objectForKey:@"check"];
             [[AppHttpManager sharedManager] tiKuangKeYongYinHangKaXinXiWithPassword:check Block:^(id JSON, NSError *error)
              {
                  self.confirmButton.enabled = YES;
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  if (!error)
                  {
                      CashViewController *cashVC = [[CashViewController alloc] init];
                      cashVC.hidesBottomBarWhenPushed = YES;
                      cashVC.JSON = JSON;
                      cashVC.check = check;
                      cashVC.shouldPopToRoot = YES;
                      [self.navigationController pushViewController:cashVC animated:YES];
                  }
                  else
                  {
                      DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                  }
              }];
         }
         else
         {
             self.confirmButton.enabled = YES;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [tixianPin resignFirstResponder];
    [self confirmToTixian:nil];
    return true;
}
- (IBAction)cancleForTixian:(id)sender
{
    [self.tixianPin resignFirstResponder];
    self.tixianPin.text = @"";
    self.tianxianView.hidden  = YES;
    self.tixianBGView.hidden=YES;
}

- (void)addHeader
{
    __unsafe_unretained ATMViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 进入刷新状态就会回调这个Block
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
      
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
         [self getBalance];
        [self getScrollAdInfo];

     };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state)
    {
        // 控件的刷新状态切换了就会调用这个block
        switch (state)
        {
            case MJRefreshStateNormal:
//                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
//                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
//                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
@end
