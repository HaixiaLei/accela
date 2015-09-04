//
//  ResetSuccessViewController.m
//  XingCai
//
//  Created by jay on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ResetSuccessViewController.h"
#import "LoginViewController.h"
@interface ResetSuccessViewController ()

@end

@implementation ResetSuccessViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backToLoginAction:(id)sender {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            LoginViewController *loginVC = (LoginViewController *)vc;
            [self.navigationController popToViewController:loginVC animated:YES];
            break;
        }
    }
}
@end
