//
//  AnnouncementDetailViewController.m
//  JiXiangCai
//
//  Created by jay on 14-11-19.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AnnouncementDetailViewController.h"

@interface AnnouncementDetailViewController ()

@end

@implementation AnnouncementDetailViewController

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
    
    self.title = @"系统公告详情";
    NSURLRequest *request = [[AFAppAPIClient sharedClient] noticeDetailRequestWithURLString:self.urlString];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
