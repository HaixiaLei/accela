//
//  OpenNoViewController.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-10-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"
#import "LotteryPicker.h"

@interface OpenNoViewController : DerivedViewController<UITableViewDataSource, UITableViewDelegate, LotteryPickerDelegate>
{
    NSMutableArray *openNoArr;
    
    UIView *topTitleView;
    UIButton *topBtn;
    UIButton *arrowBtn;
    
    NSMutableArray *lotteryArray;
    NSMutableArray *subLotteryArr;
    
    NSString *lotteryTypeStr;
    NSString *lotteryTypeName;
}

@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UIView *lotteryTypeView;
@property (nonatomic, weak) IBOutlet LotteryPicker *lp;

- (IBAction)cancelClick:(id)sender;
- (IBAction)okClick:(id)sender;

@end
