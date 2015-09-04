//
//  DSLoadingViewController.h
//  iOSUIFrame
//
//  Created by song duan on 12-6-8.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLoadingViewController : UIViewController<UIScrollViewDelegate>
{
//    UIActivityIndicatorView     *_activityIndicatorView;
    
    UIImageView *imageView;
    NSMutableArray *imageArray;
    UIPageControl*guidePAge;
}

@property (nonatomic,strong) UIImageView *left;
@property (nonatomic,strong) UIImageView *right;
@property (weak, nonatomic)  IBOutlet UIScrollView *guideScrollView;

//@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
