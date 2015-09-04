//
//  MyMsgDetailViewController.m
//  XingCai
//
//  Created by Air.Zhao on 14-1-17.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MyMsgDetailViewController.h"
#import "MsgDetailObject.h"

@interface MyMsgDetailViewController ()
@end

@implementation MyMsgDetailViewController
@synthesize subjectLab;
@synthesize webV;
@synthesize sendTimeLab;
@synthesize entryStr;

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

    if (IOS_VERSION < 7.0) {
        self.constraintTopViewHeight.constant = 44;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnBtnClk:(UIButton *)sender
{
    NSString *mark=@"1";
    [[NSUserDefaults standardUserDefaults]setObject:mark forKey:@"PushMark"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getMessageContentWithMessageId:entryStr Block:^(id JSON, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error)
        {
            if ([JSON isKindOfClass:[NSDictionary class]])
            {
                msgDetailArr = [[NSMutableArray alloc] init];
                
                NSDictionary *itemDic = JSON;
                /*MsgDetailObject *msgDetailObj = [[MsgDetailObject alloc] init];
                [msgDetailObj setContent:[itemDic objectForKey:@"content"]];
                [msgDetailObj setEntry:[itemDic objectForKey:@"entry"]];
                [msgDetailObj setSendtime:[itemDic objectForKey:@"sendtime"]];
                [msgDetailObj setSubject:[itemDic objectForKey:@"subject"]];
                [msgDetailObj setTitle:[itemDic objectForKey:@"title"]];
                [msgDetailArr addObject:msgDetailObj];*/
                
                subjectLab.text = [itemDic objectForKey:@"subject"];
                subjectLab.lineBreakMode = UILineBreakModeWordWrap;
                subjectLab.numberOfLines = 0;
                
                sendTimeLab.text = [itemDic objectForKey:@"sendtime"];
                
                [webV loadHTMLString:[itemDic objectForKey:@"content"] baseURL:nil];
            }
            else
            {
                DDLogWarn(@"JSON should be NSDictionary,%@:%@", NSStringFromSelector(_cmd),[self class]);
            }
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        }
    }];
}

@end
