//
//  ZHRecordsViewController.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"
#import "LotteryPicker.h"
#import "TDDatePickerController.h"

@interface ZHRecordsViewController : DerivedViewController<UITableViewDataSource, UITableViewDelegate, LotteryPickerDelegate, TDDatePickerControllerDelegate>
{
    NSMutableArray *lotteryArray;
    NSMutableArray *subLotteryArr;
    
    NSString *lotteryTypeStr;
    NSString *lotteryText;
    
    NSDate *_selectedDate;
    TDDatePickerController * _starDatePickerView;
    TDDatePickerController * _endDatePickerView;
}

@property (weak, nonatomic) IBOutlet UITableView *tView;

@property (weak, nonatomic) IBOutlet UIView *lotteryTypeView;
@property (nonatomic, weak) IBOutlet UILabel *lotteryLab;
@property (nonatomic, weak) IBOutlet LotteryPicker *lp;

@property(weak,nonatomic) IBOutlet UILabel *startLab;
@property(weak,nonatomic) IBOutlet UILabel *endLab;

- (IBAction)lotteryTypeClk:(id)sender;
-(IBAction)cancelClick:(id)sender;
-(IBAction)okClick:(id)sender;

- (IBAction)beginDateClk:(id)sender;
- (IBAction)endDateClk:(id)sender;

- (IBAction)searchClk:(id)sender;

@end
