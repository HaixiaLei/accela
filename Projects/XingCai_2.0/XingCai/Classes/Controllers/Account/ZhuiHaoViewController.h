//
//  ZhuiHaoViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-12.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "TDDatePickerController.h"
#import "LotteryPicker.h"

@interface ZhuiHaoViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, TDDatePickerControllerDelegate, LotteryPickerDelegate>
{
    NSMutableArray *zhListArr;
    
    TDDatePickerController * _starDatePickerView;
    TDDatePickerController * _endDatePickerView;
    NSDate * _selectedDate;
    
    int totalPage;
    int zuihaoPage;
    int CurrentPage;
    
    UILabel *loadMoreText;
    
     NSUInteger dataNumber;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    UILabel *myMessagelabel;
    
    NSMutableArray *addArray;
    BOOL mark;
    
    NSMutableArray *lotteryArray;
    NSMutableArray *subLotteryArr;
    
    NSString *lotteryTypeStr;
    NSString *lotteryText;
}
@property (weak, nonatomic) IBOutlet UITableView *zhuihaoTableView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property(weak,nonatomic) IBOutlet UILabel *startLab;
@property(weak,nonatomic) IBOutlet UILabel *endLab;

@property(weak,nonatomic) IBOutlet UIImageView *titleImg;
@property(weak,nonatomic) IBOutlet UILabel *lotteryTypeLab;
@property(weak,nonatomic) IBOutlet UILabel *priceLab;
@property(weak,nonatomic) IBOutlet UILabel *ifWinStopLab;
@property(weak,nonatomic) IBOutlet UILabel *statusLabel;
@property(weak,nonatomic) IBOutlet UIImageView *bannerImg;

@property (weak, nonatomic) IBOutlet UIView *lotteryTypeView;
@property (nonatomic, weak) IBOutlet UILabel *lotteryLab;
@property (nonatomic, weak) IBOutlet LotteryPicker *lp;

-(IBAction)startDate:(id)sender;
-(IBAction)endDate:(id)sender;
-(IBAction)searchClk:(id)sender;

- (IBAction)lotteryTypeClk:(id)sender;
-(IBAction)cancelClick:(id)sender;
-(IBAction)okClick:(id)sender;

@end
