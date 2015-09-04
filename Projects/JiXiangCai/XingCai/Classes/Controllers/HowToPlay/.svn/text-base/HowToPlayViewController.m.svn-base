//
//  HowToPlayViewController.m
//  XingCai
//
//  Created by Bevis on 14-2-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "HowToPlayViewController.h"

@interface HowToPlayViewController ()
@end

@implementation HowToPlayViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新手帮助";
    
    [self.webView loadRequest:[[AFAppAPIClient sharedClient] userHelpRequest]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//不显示左箭头
- (void)setLeftBarButton{}

@end
