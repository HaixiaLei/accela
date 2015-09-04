//
//  AppDelegate.h
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuidePageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) GuidePageViewController *guidePageViewController;
@property (nonatomic, strong) UITabBarController *mainTabBarController;

- (void)showHomePage;
- (void)showLoginViewController;
@end
