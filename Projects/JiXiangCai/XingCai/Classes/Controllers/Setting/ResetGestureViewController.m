//
//  ResetGestureViewController.m
//  JiXiangCai
//
//  Created by jay on 14-10-27.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ResetGestureViewController.h"
#import "GestureViewController.h"
#import "ValidatePwdViewController.h"
@interface ResetGestureViewController ()
{
    GestureViewController *gestureViewController;
}

@end

@implementation ResetGestureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!gestureViewController) {
        gestureViewController = [[GestureViewController alloc] initWithNibName:@"GestureViewController" bundle:nil];
        gestureViewController.view.frame = IS_IPHONE4 ? CGRectMake(0, 168, 320, 288) : CGRectMake(0, 240, 320, 288);
    }
    [gestureViewController setType:GestureTypeReset];
    
    [self.view addSubview:gestureViewController.view];
    [self addChildViewController:gestureViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetGestureFinish
{
    [Utility showErrorWithMessage:@"手势密码重置成功" delegate:self];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self popToRoot];
}

- (void)popToRoot
{
    [self.parentVC.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
