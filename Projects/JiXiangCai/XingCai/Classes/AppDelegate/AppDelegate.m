//
//  AppDelegate.m
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "AppDelegate.h"
#import "GuidePageViewController.h"
#import "BuyViewController.h"
#import "AccountViewController.h"
#import "JiangQiManager.h"
#import "LoginViewController.h"
#import "AppCacheManager.h"
#import "AppAlertView.h"
#import "ServerAddressManager.h"
#import "AppAPITest.h"

#import "MyDrawerController.h"
#import "MMExampleCenterTableViewController.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "MMNavigationController.h"

#import <QuartzCore/QuartzCore.h>

#import "MMRightSideDrawerViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong) MMDrawerController *drawerController;
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //捕获异常
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    //打印app信息
    [self logAppInfomations];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(OSVersionIsAtLeastiOS7){
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self showGuidePage];
    
    [self.window makeKeyAndVisible];
    
    //接口测试
    [AppAPITest start];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSString * key = [identifierComponents lastObject];
    if([key isEqualToString:@"MMDrawer"]){
        return self.window.rootViewController;
    }
    else if ([key isEqualToString:@"MMExampleCenterNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).centerViewController;
    }
    else if ([key isEqualToString:@"MMExampleRightNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
    }
    else if ([key isEqualToString:@"MMExampleLeftNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
    }
    else if ([key isEqualToString:@"MMExampleLeftSideDrawerController"]){
        UIViewController * leftVC = ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
        if([leftVC isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController*)leftVC topViewController];
        }
        else {
            return leftVC;
        }
        
    }
    else if ([key isEqualToString:@"MMExampleRightSideDrawerController"]){
        UIViewController * rightVC = ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
        if([rightVC isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController*)rightVC topViewController];
        }
        else {
            return rightVC;
        }
    }
    return nil;
}

//捕获异常
void uncaughtExceptionHandler(NSException *exception) {
    DDLogCError(@"CRASH: %@", exception);
    DDLogCError(@"Stack Trace: %@", [exception callStackSymbols]);
}

#pragma mark - Application lifecycle methods
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
    //如果用户在别处登陆，就需要重新登录，就不刷新奖期
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

- (MMDrawerController *)drawerController
{
    if (!_drawerController) {
        UIViewController * centerViewController = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
        
        UIViewController * rightSideDrawerViewController = [[MMRightSideDrawerViewController alloc] init];
        
        UINavigationController * centerNavController = [[MMNavigationController alloc] initWithRootViewController:centerViewController];
        [centerNavController setNavigationBarHidden:YES];
        [centerNavController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
        
        UINavigationController * rightSideNavController = [[MMNavigationController alloc] initWithRootViewController:rightSideDrawerViewController];
        [rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
        
        MMDrawerController *drawerController = [[MyDrawerController alloc]
                                                initWithCenterViewController:centerNavController
                                                leftDrawerViewController:nil
                                                rightDrawerViewController:rightSideNavController];
        [drawerController setShowsShadow:YES];
        [drawerController setRestorationIdentifier:@"MMDrawer"];
        [drawerController setMaximumRightDrawerWidth:210.0];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [drawerController
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block){
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
        
        _drawerController = drawerController;
    }
    
    return _drawerController;
}

- (void)logAppInfomations
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [infoDic objectForKey:@"CFBundleName"];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *currentBuild = [infoDic objectForKey:@"CFBundleVersion"];
    DDLogInfo(@"%@ V%@ build%@\n",bundleName,currentVersion,currentBuild);
    
    [UserInfomation sharedInfomation].appVersion = currentVersion;
    [UserInfomation sharedInfomation].appBuild = currentBuild;
}

- (void)showGuidePage
{
    GuidePageViewController *guidePageViewController = [[GuidePageViewController alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
    self.guidePageViewController = guidePageViewController;
    self.window.rootViewController = guidePageViewController;
}

- (void)showHomePage
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.window.rootViewController = self.drawerController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShowLoginNotification:) name:NotificationNameShouldLoginAgain object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewController) name:NotificationNameShowLoginVC object:nil];
}

- (void)loadingViewAnimationDone
{
    self.guidePageViewController = nil;
}

- (void)showLoginViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[AppCacheManager sharedManager] removeAllMenuAndRuleErrorMsg];
    [[JiangQiManager sharedManager] stopAllCountDownTimer];
    [AppAlertView dismissAllAlertViews];
    
    [UserInfomation sharedInfomation].shouldLoginAgain = YES;
    
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:IS_IPHONE4 ? @"LoginViewController_3p5" : @"LoginViewController" bundle:nil];
    UINavigationController *nav = [[MMNavigationController alloc] initWithRootViewController:loginVC];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    
    if (_drawerController) {
        //所有UINavigationController退回到根
        UINavigationController *rightNav;
        UIViewController *vc = self.drawerController.rightDrawerViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            rightNav = (UINavigationController *)vc;
        }
        NSArray *viewControllers =  [(MMRightSideDrawerViewController *)[rightNav.viewControllers firstObject] viewControllers];
        for (UINavigationController *nav in viewControllers)
        {
            [nav popToRootViewControllerAnimated:NO];
        }
        [(MMRightSideDrawerViewController *)[rightNav.viewControllers firstObject] showFirstVC];
    }
}

#pragma mark - NotificationNameShouldLoginAgain
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
            [Utility showErrorWithMessage:@"由于您的登录状态已失效，请重新登录" delegate:self tag:[notification.object integerValue]];
        }
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AppServerErrorKick || alertView.tag == AppServerErrorLongTime) {
        [self showLoginViewController];
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

@end
