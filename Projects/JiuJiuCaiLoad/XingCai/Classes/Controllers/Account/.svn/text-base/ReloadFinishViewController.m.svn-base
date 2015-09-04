//
//  ReloadFinishViewController.m
//  JiuJiuCai
//
//  Created by hadis on 15-4-13.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "ReloadFinishViewController.h"
#import "AccountViewController.h"

@interface ReloadFinishViewController ()

@end

@implementation ReloadFinishViewController

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

    [self.reloadWebview loadHTMLString:[_JSON objectForKey:@"content"] baseURL:nil];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBack:(id)sender {
    __block AccountViewController *accountVc = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[AccountViewController class]]) {
            accountVc = (AccountViewController *)obj;
            *stop = YES;
        }
    }];
    [self.navigationController popToViewController:accountVc animated:YES];
}
@end
