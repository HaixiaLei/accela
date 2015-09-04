//
//  MyLotteryViewController.h
//  XingCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLotteryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) BOOL shouldReloadData;

- (IBAction)zhuiHaoAction:(UIButton *)sender;

@end
