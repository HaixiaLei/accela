//
//  DerivedViewController.m
//  JiXiangCai
//
//  Created by jay on 14-9-19.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"

@interface DerivedViewController ()

@end

@implementation DerivedViewController

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
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setLeftBarButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftBarButton
{
    UIImage *barButtonImage = [UIImage imageNamed:@"buttonItem_back_n"];
    UIImage *barButtonImage_h = [UIImage imageNamed:@"buttonItem_back_h"];
    UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barButtonImage.size.width, barButtonImage.size.height)];
    containingView.backgroundColor = [UIColor clearColor];
    UIButton *barUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barUIButton.frame = CGRectMake(0, 0, barButtonImage.size.width, barButtonImage.size.height);
    [barUIButton setBackgroundImage:barButtonImage forState:UIControlStateNormal];
    [barUIButton setBackgroundImage:barButtonImage_h forState:UIControlStateHighlighted];
    [barUIButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containingView addSubview:barUIButton];
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:containingView];
    
    if(SystemVersion >= 7.0){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = backNavigationItem;
    }
}

- (void)setRightBarButton
{
    RightNavButton *rightNavButton = [[MessageManager sharedManager] rightNavButtonWithTarget:self action:@selector(rightDrawerButtonPress:)];
    
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavButton];
    
    if(SystemVersion >= 7.0){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, backNavigationItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = backNavigationItem;
    }
}

- (void)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightDrawerButtonPress:(UIButton *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

@end
