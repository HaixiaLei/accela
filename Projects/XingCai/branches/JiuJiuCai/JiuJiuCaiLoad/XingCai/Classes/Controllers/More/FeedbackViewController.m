//
//  FeedbackViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "FeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FeedbackViewController ()
@end

@implementation FeedbackViewController
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textView.layer.borderColor = [UIColor clearColor].CGColor;
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 5.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBtnClk:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
