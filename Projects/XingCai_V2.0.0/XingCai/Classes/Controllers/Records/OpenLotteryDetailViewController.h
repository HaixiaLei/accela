//
//  OpenLotteryDetailViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenLotteryDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tView;
    NSMutableArray *openLotteriesDetails;
}

- (IBAction)returnBtnClk:(UIButton *)sender;

@end
