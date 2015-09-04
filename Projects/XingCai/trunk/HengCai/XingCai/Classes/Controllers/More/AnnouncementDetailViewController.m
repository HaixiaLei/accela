//
//  AnnouncementDetailViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AnnouncementDetailViewController.h"
#import "AnnouncementDetailObject.h"

@interface AnnouncementDetailViewController ()
@end

@implementation AnnouncementDetailViewController
@synthesize containerView;
@synthesize subjectLab;
@synthesize webV;
@synthesize sendTimeLab;
@synthesize idd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0)
    {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustView];
    if (!IS_IPHONE5)
    {
        webV.size = CGSizeMake(320, 353);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnBtnClk:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getNoticeContentWithNoticeId:idd Block:^(id JSON, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([JSON isKindOfClass:[NSDictionary class]])
             {
                 announcementDetailArr = [[NSMutableArray alloc] init];
                 
                 NSDictionary *itemDic = JSON;
                 AnnouncementDetailObject *announcementDetailObj = [[AnnouncementDetailObject alloc] init];
                 [announcementDetailObj setContent:[itemDic objectForKey:@"content"]];
                 [announcementDetailObj setIdd:[itemDic objectForKey:@"id"]];
                 [announcementDetailObj setSendtime:[itemDic objectForKey:@"sendtime"]];
                 [announcementDetailObj setSubject:[itemDic objectForKey:@"subject"]];
                 [announcementDetailArr addObject:announcementDetailObj];
                 
                 subjectLab.text = [itemDic objectForKey:@"subject"];
                 [webV loadHTMLString:[itemDic objectForKey:@"content"] baseURL:nil];
                 sendTimeLab.text = [itemDic objectForKey:@"sendtime"];
             }
             else
             {
                 DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
             }
         }
         else
         {
             DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
         }
     }];
}
@end
