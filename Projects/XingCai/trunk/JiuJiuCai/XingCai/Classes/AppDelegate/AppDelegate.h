//
//  AppDelegate.h
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSLoadingViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DSLoadingViewController *loadingViewController;
@property (nonatomic, strong) UITabBarController *mainTabBarController;

- (void)loadLoadingView;
- (void)loadMainView;
@end
