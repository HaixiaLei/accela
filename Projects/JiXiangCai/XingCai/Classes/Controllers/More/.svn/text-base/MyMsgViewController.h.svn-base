//
//  MyMsgViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-16.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMsgDetailViewController.h"

@interface MyMsgViewController : DerivedViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *msgListArr;
    
    int totalPage;
    int CurrentPage;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tView;
- (IBAction)returnBtnClk:(UIButton *)sender;

- (void)refreshList;
@end
