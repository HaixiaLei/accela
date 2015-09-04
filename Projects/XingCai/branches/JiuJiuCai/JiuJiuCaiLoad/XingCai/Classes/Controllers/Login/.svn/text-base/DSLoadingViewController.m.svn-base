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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]||(![latestBuild isEqualToString:build]||![latestVersion isEqualToString:vesion]))
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIImage *image1 =[UIImage imageNamed:@"activity_bk01@2x.jpg"];
        UIImage *image2 =[UIImage imageNamed:@"activity_bk02@2x.jpg"];
        UIImage *image3 =[UIImage imageNamed:@"activity_bk03@2x.jpg"];
        NSMutableArray*imagArray =[[NSMutableArray alloc]initWithObjects:image1,image2,image3, nil];
        
        UIImage *image4 =[UIImage imageNamed:@"activity_bk01_4s@2x.jpg"];
        UIImage *image5 =[UIImage imageNamed:@"activity_bk02_4s@2x.jpg"];
        UIImage *image6 =[UIImage imageNamed:@"activity_bk03_4s@2x.jpg"];
        NSMutableArray*imagArray2 =[[NSMutableArray alloc]initWithObjects:image4,image5,image6, nil];

        
        if (!IS_IPHONE5)
        {
            for (int a=0; a<imagArray2.count; a++)
            {
                UIImageView *imgview2 = [[UIImageView alloc]initWithFrame:CGRectMake(320*a,0, 320, 480)];
                UIImage *img=[imagArray2 objectAtIndex:a];
                [imgview2 setImage:img];
                [self.guideScrollView addSubview:imgview2];
                
                UIButton* gotoMainViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
                gotoMainViewButton.frame=CGRectMake(250+320*a, 440,56, 30);
                [gotoMainViewButton addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
                
                [gotoMainViewButton setBackgroundImage:[UIImage imageNamed:@"btn_skip_normal"] forState:UIControlStateNormal];
                [gotoMainViewButton setBackgroundImage:[UIImage imageNamed:@"btn_skip_click"] forState:UIControlStateHighlighted];
                gotoMainViewButton.hidden=YES;
                [gotoMainViewButton setBackgroundColor:[UIColor clearColor]];
                [self.guideScrollView addSubview:gotoMainViewButton];
                
                gotoMainViewButton.hidden=NO;
            }
        }
        else
        {
            for (int a=0; a<imagArray.count; a++)
            {
                
               
                UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(320*a,0, 320, 568)];
                UIImage *img=[imagArray objectAtIndex:a];
                [imgview setImage:img];
                [self.guideScrollView addSubview:imgview];
                
                UIButton* gotoMainViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
                gotoMainViewButton.frame=CGRectMake(250+320*a,504,56, 30);
                [gotoMainViewButton addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
                [gotoMainViewButton setBackgroundImage:[UIImage imageNamed:@"btn_skip_normal"] forState:UIControlStateNormal];
                [gotoMainViewButton setBackgroundImage:[UIImage imageNamed:@"btn_skip_click"] forState:UIControlStateHighlighted];
                gotoMainViewButton.hidden=YES;
                [gotoMainViewButton setBackgroundColor:[UIColor clearColor]];
                [self.guideScrollView addSubview:gotoMainViewButton];
                
                gotoMainViewButton.hidden=NO;
            }
        }
        
        self.guideScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3,480+(IS_IPHONE5?88:0));
        self.guideScrollView.delegate=self;
        
        self.guidePAge= [[UIPageControl alloc]initWithFrame:CGRectMake(100, 373+(IS_IPHONE5?75:0), 120, 30)];
//        [self.guidePAge setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.996 green:0.788 blue:0.180 alpha:1.000]];
        self.guidePAge.currentPage=0;
        self.guidePAge.numberOfPages=3;
     
        [self.guidePAge setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:self.guidePAge];
        
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
    self.guidePAge.hidden=YES;
    
    
    if (self.guideScrollView!=nil) {
        [self.guideScrollView removeFromSuperview];
        [self.guidePAge removeFromSuperview];
        self.guideScrollView=nil;
    }
    
    [self loadingDone];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat y= scrollView.contentOffset.x;
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.guidePAge.currentPage = page;
   
//    if (700<y) {
//        [self gotoMainView];
//    }
//    if (y<0||640<y) {
//        scrollView.scrollEnabled=NO;
//    }else
//        scrollView.scrollEnabled=YES;
    
}
@end
