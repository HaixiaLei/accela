//
//  InfoOfPlayMethodViewController.m
//  XingCai
//
//  Created by Bevis on 14-2-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "InfoOfPlayMethodViewController.h"

@interface InfoOfPlayMethodViewController ()
@end

@implementation InfoOfPlayMethodViewController
@synthesize webView;

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
    
    // Do any additional setup after loading the view from its nib.
    [self getPlayInfomation];
    webView.size = CGSizeMake(320, 514);
    [self adjustView];
}
-(void)adjustView
{
    
    if (SystemVersion < 7.0) {
        self.contentView.point = CGPointZero;
        CGRect frame = self.contentView.frame;
        frame.size.height = 568;
        self.contentView.frame = frame;
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bankToBuyChooseView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPlayInfomation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    switch (self.infoType)
    {
        case InfoTypePlayMethod:
        {
            self.titleLabel.text = @"玩法说明";
            //玩法说明
            [[AppHttpManager sharedManager] getPlayInfomationWithBlock:^(id JSON, NSError *error)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 if (!error)
                 {
                     if ([JSON isKindOfClass:[NSArray class]])
                     {
                         for (id object in (NSArray *)JSON)
                         {
                             
                             if ([object isKindOfClass:[NSDictionary class]]) {
                                 NSDictionary *dictionary = (NSDictionary *)object;
                                 if ([[dictionary objectForKey:@"tagname"] isEqualToString:self.tagName]) {
                                     NSString *content = [dictionary objectForKey:@"content"];
                                     [self.webView loadHTMLString:content baseURL:nil];
                                 }
                             }
                         }
                     }
                 }
                 else
                 {
                     DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                 }
             }];
            break;
        }
        case InfoTypeHowToSaving:
        {
            self.titleLabel.text = @"存款说明";
            //存款说明
            [[AppHttpManager sharedManager] getHowToSavingWithBlock:^(id JSON, NSError *error)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 if (!error)
                 {
                     if ([JSON isKindOfClass:[NSArray class]])
                     {
                         for (id object in (NSArray *)JSON) {
                             if ([object isKindOfClass:[NSDictionary class]]) {
                                 NSDictionary *dictionary = (NSDictionary *)object;
                                 if ([[dictionary objectForKey:@"tagname"] isEqualToString:self.tagName]) {
                                     NSString *content = [dictionary objectForKey:@"content"];
                                     [self.webView loadHTMLString:content baseURL:nil];
                                 }
                             }
                         }
                     }
                 }
                 else
                 {
                     DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                 }
             }];
            break;
        }
        case InfoTypeAnswer:
        {
            self.titleLabel.text = @"常见问题说明";
            //常见问题说明
            [[AppHttpManager sharedManager] getAnswerWithBlock:^(id JSON, NSError *error)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 if (!error)
                 {
                     if ([JSON isKindOfClass:[NSString class]])
                     {
                         [self.webView loadHTMLString:JSON baseURL:nil];
                     }
                 }
                 else
                 {
                     DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
                 }
             }];
            break;
        }
        default:
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            break;
        }
    }
}
@end
