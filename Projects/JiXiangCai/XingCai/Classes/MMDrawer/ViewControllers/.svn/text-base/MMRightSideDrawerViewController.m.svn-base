//
//  MMRightSideDrawerViewController.m
//  JiXiangCai
//
//  Created by jay on 14-9-18.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MMRightSideDrawerViewController.h"
#import "MMNavigationController.h"
#import "BuyChooseViewController.h"
#import "BetRecordsViewController.h"
#import "ZHRecordsViewController.h"
#import "OpenNoViewController.h"
#import "MessageViewController.h"
#import "AnnouncementViewController.h"
#import "HowToPlayViewController.h"
#import "SetViewController.h"
#import "RightItemTableViewCell.h"
#import "BalanceObject.h"

@interface RightSideMenuObject : NSObject
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *title;
@end
@implementation RightSideMenuObject
@end

static NSString *RightItemTableViewCellIdentifier = @"RightItemTableViewCellIdentifier";

@interface MMRightSideDrawerViewController ()
{
    NSArray *menuItems;
    NSArray *viewControllers;
    NSString *messageCountString;
    
    NSInteger selectedRow;
}
@end

@implementation MMRightSideDrawerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = [UserInfomation sharedInfomation].nickName;
    [self updateBalance];
    [[MessageManager sharedManager] updateMessages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (IS_IPHONE5) {
        self.bgImgView.image = [UIImage imageNamed:@"rightsidedrawer_bg_4d0"];
    }
    else
    {
        self.bgImgView.image = [UIImage imageNamed:@"rightsidedrawer_bg_3d5"];
    }
    
    //列表数据
    NSMutableArray *items = [NSMutableArray array];
    
    RightSideMenuObject *rightSideMenuObject = [[RightSideMenuObject alloc] init];
    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
    rightSideMenuObject.title = @"彩种选择";
    [items addObject:rightSideMenuObject];
    
    rightSideMenuObject = [[RightSideMenuObject alloc] init];
    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
    rightSideMenuObject.title = @"投注记录";
    [items addObject:rightSideMenuObject];
    
    rightSideMenuObject = [[RightSideMenuObject alloc] init];
    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
    rightSideMenuObject.title = @"追号记录";
    [items addObject:rightSideMenuObject];
    
    rightSideMenuObject = [[RightSideMenuObject alloc] init];
    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
    rightSideMenuObject.title = @"开奖号码";
    [items addObject:rightSideMenuObject];
    
    rightSideMenuObject = [[RightSideMenuObject alloc] init];
    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
    rightSideMenuObject.title = @"站内短信";
    [items addObject:rightSideMenuObject];
    
//    rightSideMenuObject = [[RightSideMenuObject alloc] init];
//    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
//    rightSideMenuObject.title = @"系统公告";
//    [items addObject:rightSideMenuObject];
    
    rightSideMenuObject = [[RightSideMenuObject alloc] init];
    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
    rightSideMenuObject.title = @"新手帮助";
    [items addObject:rightSideMenuObject];
    
    rightSideMenuObject = [[RightSideMenuObject alloc] init];
    rightSideMenuObject.iconImage = [UIImage imageNamed:@""];
    rightSideMenuObject.title = @"设置";
    [items addObject:rightSideMenuObject];
    
    menuItems = [NSArray arrayWithArray:items];
    
    //视图控制器
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:self.mm_drawerController.centerViewController];
    
    UIViewController *betRecordsVC = [[BetRecordsViewController alloc] init];
    UINavigationController *betNavViewController = [[MMNavigationController alloc] initWithRootViewController:betRecordsVC];
    [controllers addObject:betNavViewController];
    
    UIViewController *zhRcdViewController = [[ZHRecordsViewController alloc] init];
    UINavigationController *zhRcdNavController = [[MMNavigationController alloc] initWithRootViewController:zhRcdViewController];
    [controllers addObject:zhRcdNavController];
    
    UIViewController *openNoViewController = [[OpenNoViewController alloc] init];
    UINavigationController *openNoNavController = [[MMNavigationController alloc] initWithRootViewController:openNoViewController];
    [controllers addObject:openNoNavController];
    
    UIViewController *messageViewController = [[MessageViewController alloc] init];
    UINavigationController *messageNavController = [[MMNavigationController alloc] initWithRootViewController:messageViewController];
    [controllers addObject:messageNavController];
    
//    UIViewController *announcementViewController = [[AnnouncementViewController alloc] init];
//    UINavigationController *announcementNavController = [[MMNavigationController alloc] initWithRootViewController:announcementViewController];
//    [controllers addObject:announcementNavController];
    
    UIViewController *howToPlayViewController = [[HowToPlayViewController alloc] init];
    UINavigationController *howToPlayNavController = [[MMNavigationController alloc] initWithRootViewController:howToPlayViewController];
    [controllers addObject:howToPlayNavController];
    
    UIViewController *setViewController = [[SetViewController alloc] init];
    UINavigationController *setNavController = [[MMNavigationController alloc] initWithRootViewController:setViewController];
    [controllers addObject:setNavController];
    
    viewControllers = [NSArray arrayWithArray:controllers];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightItemTableViewCell" bundle:nil]  forCellReuseIdentifier:RightItemTableViewCellIdentifier];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanBalance) name:NotificationNameCleanBalance object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageCount:) name:NotificationNameNewMessageCount object:nil];
    
    if(IS_IPHONE4)
    {
        CGRect frame = self.tableView.frame;
        frame.size.height = 384;
        self.tableView.frame = frame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击余额按钮刷新余额
- (IBAction)btnBanlencePressed:(UIButton *)sender {
    sender.enabled = NO;
    NSString *temp = self.balanceLB.text;
    self.balanceLB.text = @"0";
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = CGRectMake(8, 3, 18, 18);
    [indicator startAnimating];
    [sender addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.1];
        [self updateBalance]; //刷新余额
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            sender.enabled = YES;
            if ([self.balanceLB.text isEqualToString:@"0"]) {
                self.balanceLB.text = temp;
            }
        });
    });
}

- (NSArray *)viewControllers
{
    return viewControllers;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:RightItemTableViewCellIdentifier];
    RightSideMenuObject *rightSideMenuObject = [menuItems objectAtIndex:indexPath.row];
    RightItemTableViewCell *rightItemTableViewCell = (RightItemTableViewCell *)cell;
    rightItemTableViewCell.contentLB.text = rightSideMenuObject.title;
    [rightItemTableViewCell setIconImagesWithIndex:indexPath.row + 1];
    rightItemTableViewCell.numberLB.hidden = indexPath.row == 4 ? ([messageCountString integerValue] == 0 ? YES : NO) : YES;
    [rightItemTableViewCell setNumber:messageCountString];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    for (UINavigationController *nav in viewControllers) {
        //防止某些时候viewDidDisappear不被系统调用，这里主动调用一下
        UIViewController *vc = nav.topViewController;
        if ([vc respondsToSelector:@selector(viewDidDisappear:)]) {
            [vc viewDidDisappear:YES];
        }
        [nav popToRootViewControllerAnimated:NO];
    }
    
    UINavigationController *nav = [viewControllers objectAtIndex:indexPath.row];
    DDLogDebug(@"viewControllers=%@,index=%ld,nav=%p,nav=%@",viewControllers,(long)indexPath.row,nav,nav);
    
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
}

- (void)updateBalance
{
    [[AFAppAPIClient sharedClient] getBalance_with_block:^(id JSON, NSError *error)
    {
        if (!error)
        {
            BalanceObject *balanceObject = [[BalanceObject alloc] initWithDictionary:JSON];
            
//            //格式化，加入逗号分隔
//            NSNumberFormatter *formatter = [NSNumberFormatter new];
//            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
//            [formatter setMinimumFractionDigits:4];
//            [formatter setMaximumFractionDigits:4];
//            [formatter setLocale:[NSLocale currentLocale]];
//            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:[balanceObject.money doubleValue]]];
//            self.balanceLB.text = formatted;
            
            self.balanceLB.text = balanceObject.money;
        }
    }];
}

/**
 *  余额归零，防止因切换账号等原因造成显示旧账号余额
 */
- (void)cleanBalance
{
    self.balanceLB.text = @"0.0000";
}

- (void)updateMessageCount:(NSNotification *)notification
{
    messageCountString = notification.object;
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)showFirstVC
{
    selectedRow = 0;
    UINavigationController *nav = [viewControllers objectAtIndex:0];
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}
@end
