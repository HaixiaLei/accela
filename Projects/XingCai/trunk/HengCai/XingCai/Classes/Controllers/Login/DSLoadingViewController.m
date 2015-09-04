//
//  DSLoadingViewController.m
//  iOSUIFrame
//
//  Created by song duan on 12-6-8.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import "DSLoadingViewController.h"
#import "AppDelegate.h"

@implementation DSLoadingViewController


#pragma mark - View lifecycle methods

- (void)viewDidLoad
{
   
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *latestVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *latestBuild = [infoDic objectForKey:@"CFBundleVersion"];
  
    NSString *vesion=[[NSUserDefaults standardUserDefaults]objectForKey:@"currenVersion"];
    NSString *build=[[NSUserDefaults standardUserDefaults]objectForKey:@"currentBuild"];
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]||(![latestBuild isEqualToString:build]||![latestVersion isEqualToString:vesion])) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIImage *image1 =[UIImage imageNamed:@"guiding1136_01@2x.jpg"];
        UIImage *image2 =[UIImage imageNamed:@"guiding1136_02@2x.jpg"];
        UIImage *image3 =[UIImage imageNamed:@"guiding1136_03@2x.jpg"];
        NSMutableArray*imagArray =[[NSMutableArray alloc]initWithObjects:image1,image2,image3, nil];
        
        
        for (int a=0; a<imagArray.count; a++) {
             UIImageView *imgview;
         imgview  = [[UIImageView alloc]initWithFrame:CGRectMake(320*a,(IS_IPHONE5?0:-44), 320, 568)];
           
            UIImage *img=[imagArray objectAtIndex:a];
            [imgview setImage:img];
            [self.guideScrollView addSubview:imgview];
            
            if (a==2) {
                UIButton* gotoMainViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
                
                if (SystemVersion>7.0) {
                    gotoMainViewButton.frame=CGRectMake(230+320*a, 370+(IS_IPHONE5?134:0),71, 31);
                }else
                {
                    gotoMainViewButton.frame=CGRectMake(230+320*a, 450+(IS_IPHONE5?64:0),71, 31);
                }
                [gotoMainViewButton addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
                
                [gotoMainViewButton setBackgroundImage:[UIImage imageNamed:@"btn_enjoy_normal"] forState:UIControlStateNormal];
                [gotoMainViewButton setBackgroundImage:[UIImage imageNamed:@"btn_enjoy_click"] forState:UIControlStateHighlighted];
                 gotoMainViewButton.hidden=YES;
                [gotoMainViewButton setBackgroundColor:[UIColor clearColor]];
                [self.guideScrollView addSubview:gotoMainViewButton];
                
                gotoMainViewButton.hidden=NO;

            }
            
            
        }
        
        self.guideScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3,480+(IS_IPHONE5?88:0));
        guidePAge= [[UIPageControl alloc]initWithFrame:CGRectMake(100, 445+(IS_IPHONE5?64:0), 120, 30)];

        self.guideScrollView.delegate=self;
        
        
        guidePAge.currentPage=0;
        guidePAge.numberOfPages=3;
        [guidePAge setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:guidePAge];
        
    }
    else
    {
        [self gotoMainView];
    }
    NSDictionary *curreninfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [curreninfoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *currentBuild = [curreninfoDic objectForKey:@"CFBundleVersion"];

    
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"currenVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:currentBuild forKey:@"currentBuild"];

    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)loadingDone
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [(AppDelegate *)[UIApplication sharedApplication].delegate loadMainView];
}

- (void)gotoMainView {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.guideScrollView.hidden=YES;
    guidePAge.hidden=YES;
    
    
    if (self.guideScrollView!=nil) {
        [self.guideScrollView removeFromSuperview];
        [guidePAge removeFromSuperview];
        self.guideScrollView=nil;
    }
    
    [self loadingDone];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat y= scrollView.contentOffset.x;
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    guidePAge.currentPage = page;
   
//    if (700<y) {
//        [self gotoMainView];
//    }
//    if (y<0||640<y) {
//        scrollView.scrollEnabled=NO;
//    }else
//        scrollView.scrollEnabled=YES;
    
}
@end
