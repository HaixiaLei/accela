//
//  AvatarSetViewController.m
//  JiuJiuCai
//
//  Created by jay on 14-6-20.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AvatarSetViewController.h"
#import "AvatarView.h"
#import "AccountViewController.h"
@interface AvatarSetViewController ()
{
    IBOutletCollection(UIButton) NSArray *topButtons;
    
    NSMutableArray *allAvatars;
    NSInteger selectedAvatarIndex;
    NSInteger currentGroup;
}
@end

@implementation AvatarSetViewController

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
    selectedAvatarIndex = -1;
    self.scrollView.contentSize = CGSizeMake(320 * 4, self.scrollView.frame.size.height);
    
    [self initElements];
    
    [self selectAtGroup:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initElements
{
    if (!allAvatars) {
        allAvatars = [NSMutableArray array];
    }
    else
    {
        [allAvatars removeAllObjects];
    }
    
    //group a
    for (int i = 0; i < 6; ++i) {
        NSInteger avatarIndex = AvatarViewGroupA + i + 1;
        NSString *imageName = [AvatarView avatarImageNameFromIndex:avatarIndex];
        UIImage *image = [UIImage imageNamed:imageName];
        AvatarView *avatarView = [AvatarView instanceAvatarView];
        [avatarView setImage:image];
        [avatarView.button addTarget:self action:@selector(avatarAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarView.button.tag = avatarIndex;
        
        NSInteger xIndex = i % 4;
        NSInteger yIndex = i / 4;
        CGPoint origin = CGPointMake(14 + xIndex * (64 + 12), 14 + yIndex * (64 + 12));
        CGRect frame;
        frame.origin = origin;
        frame.size = CGSizeMake(64, 64);
        
        avatarView.frame = frame;
        [self.scrollView addSubview:avatarView];
        [allAvatars addObject:avatarView];
    }
    
    //group b
    for (int i = 0; i < 12; ++i) {
        NSInteger avatarIndex = AvatarViewGroupB + i + 1;
        NSString *imageName = [AvatarView avatarImageNameFromIndex:avatarIndex];
        UIImage *image = [UIImage imageNamed:imageName];
        AvatarView *avatarView = [AvatarView instanceAvatarView];
        [avatarView setImage:image];
        [avatarView.button addTarget:self action:@selector(avatarAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarView.button.tag = avatarIndex;
        
        NSInteger xIndex = i % 4;
        NSInteger yIndex = i / 4;
        CGPoint origin = CGPointMake(320 + 14 + xIndex * (64 + 12), 14 + yIndex * (64 + 12));
        CGRect frame;
        frame.origin = origin;
        frame.size = CGSizeMake(64, 64);
        
        avatarView.frame = frame;
        [self.scrollView addSubview:avatarView];
        [allAvatars addObject:avatarView];
    }
    
    //group c
    for (int i = 0; i < 10; ++i) {
        NSInteger avatarIndex = AvatarViewGroupC + i + 1;
        NSString *imageName = [AvatarView avatarImageNameFromIndex:avatarIndex];
        UIImage *image = [UIImage imageNamed:imageName];
        AvatarView *avatarView = [AvatarView instanceAvatarView];
        [avatarView setImage:image];
        [avatarView.button addTarget:self action:@selector(avatarAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarView.button.tag = avatarIndex;
        
        NSInteger xIndex = i % 4;
        NSInteger yIndex = i / 4;
        CGPoint origin = CGPointMake(320 * 2 + 14 + xIndex * (64 + 12), 14 + yIndex * (64 + 12));
        CGRect frame;
        frame.origin = origin;
        frame.size = CGSizeMake(64, 64);
        
        avatarView.frame = frame;
        [self.scrollView addSubview:avatarView];
        [allAvatars addObject:avatarView];
    }
    
    //group d
    for (int i = 0; i < 8; ++i) {
        NSInteger avatarIndex = AvatarViewGroupD + i + 1;
        NSString *imageName = [AvatarView avatarImageNameFromIndex:avatarIndex];
        UIImage *image = [UIImage imageNamed:imageName];
        AvatarView *avatarView = [AvatarView instanceAvatarView];
        [avatarView setImage:image];
        [avatarView.button addTarget:self action:@selector(avatarAction:) forControlEvents:UIControlEventTouchUpInside];
        avatarView.button.tag = avatarIndex;
        
        NSInteger xIndex = i % 4;
        NSInteger yIndex = i / 4;
        CGPoint origin = CGPointMake(320 * 3 + 14 + xIndex * (64 + 12), 14 + yIndex * (64 + 12));
        CGRect frame;
        frame.origin = origin;
        frame.size = CGSizeMake(64, 64);
        
        avatarView.frame = frame;
        [self.scrollView addSubview:avatarView];
        [allAvatars addObject:avatarView];
    }
}

- (void)selectAtGroup:(NSInteger)group
{
    for (UIButton *button in topButtons)
    {
        button.selected = button.tag == group ? YES : NO;
    }
    CGRect frame = CGRectMake(320 * group, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)avatarAction:(UIButton *)sender
{
    for (AvatarView *avatarView in allAvatars) {
        avatarView.selected = NO;
    }
    sender.selected = YES;
    selectedAvatarIndex = sender.tag;
//    NSLog(@"selectedAvatarIndex = %ld",(long)selectedAvatarIndex);
}

- (IBAction)returnBtnClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureButtonAction:(id)sender
{
    if (selectedAvatarIndex != -1)
    {
        NSString *avatarIndex = [NSString stringWithFormat:@"%ld",(long)selectedAvatarIndex];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AppHttpManager sharedManager] updateAvatarWithId:avatarIndex Block:^(id JSON, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (!error)
             {
                 if ([JSON isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *dictionary = (NSDictionary *)JSON;
                     if ([dictionary.allKeys containsObject:@"msg"])
                     {
                         NSString *msg = [dictionary objectForKey:@"msg"];
                         [Utility showErrorWithMessage:msg delegate:self tag:0];
                     }
                 }
             }
             else
             {
                 DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
             }
         }];
    }
    else
    {
        [Utility showErrorWithMessage:@"请选择一个头像" delegate:self tag:1];
    }
}

- (IBAction)tabSelectAction:(UIButton *)sender
{
    [self selectAtGroup:sender.tag];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentGroup = scrollView.contentOffset.x / 320;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self selectAtGroup:currentGroup];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag  == 0)
    {
        NSArray *vcs = self.navigationController.viewControllers;
        for(UIViewController *vc in vcs)
        {
            if ([vc isKindOfClass:[AccountViewController class]])
            {
                AccountViewController *accVC = (AccountViewController *)vc;
                [accVC setAvatarImageWithIndex:selectedAvatarIndex];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
@end
