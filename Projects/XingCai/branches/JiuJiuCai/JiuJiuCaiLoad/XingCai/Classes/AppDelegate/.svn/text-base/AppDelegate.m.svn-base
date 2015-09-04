//
//  AppDelegate.m
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "AppDelegate.h"
#import "DSLoadingViewController.h"
#import "BuyViewController.h"
#import "RecordsViewController.h"
#import "AccountViewController.h"
#import "MoreViewController.h"
#import "JiangQiManager.h"
#import "LoginViewController.h"
#import "AppCacheManager.h"
#import "AppAlertView.h"
#import "AccountViewController.h"
#import "ServerAddressManager.h"
#import "AppAPITest.h"

@implementation AppDelegate
{
    UINavigationController *oneNavigationController;
}
void uncaughtExceptionHandler(NSException *exception) {
    DDLogCError(@"CRASH: %@", exception);
    DDLogCError(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

#pragma mark - Application lifecycle methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    //打印app信息
    [self logAppInfomations];
    
    [AppAPITest start];
    
    //    [[ServerAddressManager sharedManager] saveAddressListToFile];
    //    [[ServerAddressManager sharedManager] getAddressList];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self loadLoadingView];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //如果用户在别处登录，就需要重新登录，就不刷新奖期
    if (![UserInfomation sharedInfomation].shouldLoginAgain) {
        [[JiangQiManager sharedManager] updateAllJiangQi];
    }
    
    //    if (![UserInfomation sharedInfomation].latestVersionGot) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetVersion object:nil userInfo:nil];
    //    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Custom methods

- (void)logAppInfomations
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *currentBuild = [infoDic objectForKey:@"CFBundleVersion"];
    DDLogInfo(@"Version:%@\n",currentVersion);
    DDLogInfo(@"Build:%@\n",currentBuild);
}

- (void)loadLoadingView
{
    self.loadingViewController = [[DSLoadingViewController alloc] initWithNibName:@"DSLoadingViewController" bundle:nil];
    //    [self.window addSubview:self.loadingViewController.view];
    self.window.rootViewController = self.loadingViewController;
}
- (void)loadMainView
{
    NSDictionary *attributeSelected = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor colorWithRed:255.0/255.0 green:166.0/255.0 blue:50.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                       //     [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
                                       //     [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                       //     [UIFont fontWithName:@"AmericanTypewriter" size:0.0], UITextAttributeFont,
                                       nil];
    NSDictionary *attributeNormal = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                     nil];
    BuyViewController *buyViewController
    = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
    oneNavigationController
    = [[UINavigationController alloc] initWithRootViewController:buyViewController];
    
    oneNavigationController.delegate = self;
    
    oneNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    oneNavigationController.navigationBarHidden = YES;
    oneNavigationController.tabBarItem.title = @"购彩大厅";
    [oneNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Icon_buy_click"] withFinishedUnselectedImage:[UIImage imageNamed:@"Icon_buy_normal"]];
    [oneNavigationController.tabBarItem setTitleTextAttributes:attributeSelected forState:UIControlStateSelected];
    [oneNavigationController.tabBarItem setTitleTextAttributes:attributeNormal forState:UIControlStateNormal];
    [oneNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    RecordsViewController *recordsViewController
    = [[RecordsViewController alloc] initWithNibName:@"RecordsViewController" bundle:nil];
    UINavigationController *twoNavigationController
    = [[UINavigationController alloc] initWithRootViewController:recordsViewController];
    twoNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    twoNavigationController.navigationBarHidden = YES;
    twoNavigationController.tabBarItem.title = @"开奖信息";
    [twoNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Icon_prize_click"] withFinishedUnselectedImage:[UIImage imageNamed:@"Icon_prize_normal"]];
    [twoNavigationController.tabBarItem setTitleTextAttributes:attributeSelected forState:UIControlStateSelected];
    [twoNavigationController.tabBarItem setTitleTextAttributes:attributeNormal forState:UIControlStateNormal];
    [twoNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    AccountViewController *accountViewController
    = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    UINavigationController *threeNavigationController
    = [[UINavigationController alloc] initWithRootViewController:accountViewController];
    threeNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    threeNavigationController.navigationBarHidden = YES;
    threeNavigationController.tabBarItem.title = @"账户中心";
    [threeNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Icon_user_click"] withFinishedUnselectedImage:[UIImage imageNamed:@"Icon_user_normal"]];
    [threeNavigationController.tabBarItem setTitleTextAttributes:attributeSelected forState:UIControlStateSelected];
    [threeNavigationController.tabBarItem setTitleTextAttributes:attributeNormal forState:UIControlStateNormal];
    [threeNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    MoreViewController *moreViewController
    = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    UINavigationController *fourNavigationController
    = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    fourNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    fourNavigationController.navigationBarHidden = YES;
    fourNavigationController.tabBarItem.title = @"更多";
    [fourNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_more_click"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_more_normal"]];
    [fourNavigationController.tabBarItem setTitleTextAttributes:attributeSelected forState:UIControlStateSelected];
    [fourNavigationController.tabBarItem setTitleTextAttributes:attributeNormal forState:UIControlStateNormal];
    [fourNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
//    self.mainTabBarController = [[UITabBarController alloc] init];
//    self.mainTabBarController.delegate = self;
//    self.mainTabBarController.viewControllers = [NSArray arrayWithObjects:
//                                                 oneNavigationController,
//                                                 //                                                 twoNavigationController,
//                                                 //                                                 threeNavigationController,
//                                                 //                                                 fourNavigationController,
//                                                 nil];
//    [self.mainTabBarController setHidesBottomBarWhenPushed:YES];
//    self.mainTabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"Tab_bar"];
//    self.mainTabBarController.tabBar.hidden = YES;
//    [self.window addSubview:self.mainTabBarController.view];
    
    [self.window addSubview:oneNavigationController.view];
    
    //    [self.window addSubview:buyViewController.view];
    
    //tarbar上端阴影
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -3, 320, 3)];
    //    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Tab_shadow"]];
    //    [self.mainTabBarController.tabBar addSubview:view];
    
    //登录
    [self showLoginViewController];
    
    [self.window bringSubviewToFront:self.loadingViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadingViewAnimationDone)];
    [UIView setAnimationDuration:0.5];
    
    self.loadingViewController.view.alpha = 0;
    
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShowLoginNotification:) name:NotificationNameShowLogin object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFirstPageAfterLogin) name:NotificationNameShowFirstPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewController) name:NotificationNameLogout object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)loadingViewAnimationDone
{
    self.loadingViewController = nil;
}

- (void)showLoginViewController
{
    [[AppCacheManager sharedManager] removeAllMenuAndRuleErrorMsg];
    [[JiangQiManager sharedManager] stopAllCountDownTimer];
    [AppAlertView dismissAllAlertViews];

    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    nav.navigationBarHidden = YES;
//    [self.mainTabBarController presentViewController:nav animated:NO completion:^(void){
//        //所有UINavigationController退回到根
//        self.mainTabBarController.selectedIndex = 0;
//        for (UINavigationController *nav in self.mainTabBarController.viewControllers) {
//            [nav popToRootViewControllerAnimated:NO];
//        }
//    }];
    [oneNavigationController popToRootViewControllerAnimated:NO];
    [oneNavigationController pushViewController:loginVC animated:NO];
}

#pragma mark - NotificationNameShowLogin
- (void)receiveShowLoginNotification:(NSNotification*)notification
{
    if ([notification.object integerValue] == AppServerErrorKick) {
        if (![UserInfomation sharedInfomation].loginVCVisible)
        {
            [Utility showErrorWithMessage:@"您的账号在别处登录" delegate:self tag:[notification.object integerValue]];
        }
    }
    else if ([notification.object integerValue] == AppServerErrorLongTime) {
        if (![UserInfomation sharedInfomation].loginVCVisible)
        {
            [Utility showErrorWithMessage:@"由于您长时间未操作，请重新登录" delegate:self tag:[notification.object integerValue]];
        }
    }
}

//#pragma mark - NotificationNameShowFirstPage
//- (void)showFirstPageAfterLogin
//{
//    self.mainTabBarController.selectedIndex = 0;
//}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == AppServerErrorKick || alertView.tag == AppServerErrorLongTime) {
            [self showLoginViewController];
        }
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)viewController) popToRootViewControllerAnimated:NO];
    }
    else if([viewController isKindOfClass:[UIViewController class]])
    {
        [viewController.navigationController popToRootViewControllerAnimated:NO];
    }
}
//http://feed.sincaitest.com/feed/?controller=default&action=login
//{"username":"weststar","loginpass":"d3ad4cee4afad22711421f651119d0d4"}
//8f5ebac63229363e460e9a85c21ef581435659ef
//http://feed.sincaitest.com/feed/?nav=ssc&sess=8f5ebac63229363e460e9a85c21ef581435659ef

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[BuyViewController class]] && !animated) {
        [UserInfomation sharedInfomation].loginVCVisible = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUpdateLotteryList object:nil];
    }
    else if ([viewController isKindOfClass:[AccountViewController class]] && !animated && [UserInfomation sharedInfomation].loginVCVisible) {
        [viewController.navigationController popToRootViewControllerAnimated:NO];
        [UserInfomation sharedInfomation].loginVCVisible = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUpdateLotteryList object:nil];
    }
}
@end
