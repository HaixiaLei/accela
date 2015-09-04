//
//  BetSearchViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGOViewCommon.h"
//#import "EGORefreshTableFooterView.h"
#import "MJRefresh.h"
#import "TDDatePickerController.h"
#import "LotteryPicker.h"

@interface BetSearchViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,TDDatePickerControllerDelegate,LotteryPickerDelegate>
{
    NSMutableArray *betListArr;
    TDDatePickerController * _starDatePickerView;
    TDDatePickerController * _endDatePickerView;
    NSDate * _selectedDate;
    
    int totalPage;
    int CurrentPage;
    
    
    BOOL _loadingMore;
    NSUInteger dataNumber;
    NSMutableArray *tableMoreData;
    UILabel *loadMoreText;
    
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
@property (weak, nonatomic) IBOutlet UITableView *betTabelView;

@property(weak,nonatomic) IBOutlet UILabel *startLab;
@property(weak,nonatomic) IBOutlet UILabel *endLab;

@property(weak,nonatomic) IBOutlet UIImageView *titleImg;
@property(weak,nonatomic) IBOutlet UILabel *lotteryTypeLab;
@property(weak,nonatomic) IBOutlet UILabel *priceLab;
@property(weak,nonatomic) IBOutlet UILabel *bonusLabel;
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
