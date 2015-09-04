//
//  GoBindBankcardViewController.m
//  JiuJiuCai
//
//  Created by 维德 on 15-4-24.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "GoBindBankcardViewController.h"
#import "BindBankCardViewController.h"
@interface GoBindBankcardViewController ()

@end

@implementation GoBindBankcardViewController

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

- (IBAction)gotoReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)gotoBindBankCard:(id)sender {
    
    BindBankCardViewController *Bcv = [[BindBankCardViewController alloc] init];
    [self.navigationController pushViewController:Bcv animated:YES];

}
@end
