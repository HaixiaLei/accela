//
//  GuidePageViewController.m
//  JiXiangCai
//
//  Created by jay on 14-9-28.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "GuidePageViewController.h"

#import "AppDelegate.h"

#define Key_GuideAlreadyShow @"GuideAlreadyShow"

#define Key_LastVersion @"LastVersion"
#define Key_LastBuild @"LastBuild"

#define Key_Version @"CFBundleShortVersionString"
#define Key_Build @"CFBundleVersion"

@implementation GuidePageViewController
{
    IBOutletCollection(UIImageView) NSArray *images;
    BOOL shouldGoToMainView;
    BOOL showGuide;
}

#pragma mark - View lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:Key_Version];
    NSString *currentBuild = [infoDic objectForKey:Key_Build];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:Key_LastVersion];
    NSString *lastBuild = [[NSUserDefaults standardUserDefaults] objectForKey:Key_LastBuild];
    
    //判断是否是第一次启动应用
    BOOL guideAlreadyShow = [[NSUserDefaults standardUserDefaults] boolForKey:Key_GuideAlreadyShow];
    
    if (!guideAlreadyShow || !lastVersion || !lastBuild || ![currentVersion isEqualToString:lastVersion] || ![currentBuild isEqualToString:lastBuild])
    {
        showGuide = YES;
        for (int i = 0; i < 3; ++i) {
            NSString *prefix = IS_IPHONE5 ? @"guidePage_4p0_" : @"guidePage_3p5_";
            NSString *imageName = [NSString stringWithFormat:@"%@%d",prefix,i+1];
            UIImage *image = [UIImage imageNamed:imageName];
            
            UIImageView *imageView = [images objectAtIndex:i];
            imageView.image = image;
        }
    }
    else
    {
        showGuide = NO;
        [self gotoMainView];
    }
}

- (void)gotoMainView
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:Key_Version];
    NSString *currentBuild = [infoDic objectForKey:Key_Build];
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:Key_LastVersion];
    [[NSUserDefaults standardUserDefaults] setObject:currentBuild forKey:Key_LastBuild];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Key_GuideAlreadyShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadingDone];
}

- (void)loadingDone
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [(AppDelegate *)[UIApplication sharedApplication].delegate showLoginViewController];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x > 660) {
        scrollView.userInteractionEnabled = NO;
        shouldGoToMainView = YES;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (shouldGoToMainView) {
        shouldGoToMainView = NO;
        [self performSelector:@selector(gotoMainView) withObject:nil afterDelay:0.1f];
    }
}

- (IBAction)beginButtonAction:(id)sender {
    [self gotoMainView];
}
@end
