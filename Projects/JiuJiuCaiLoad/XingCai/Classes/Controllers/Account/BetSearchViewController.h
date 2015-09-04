//
//  BetSearchViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "BetPicker.h"
#import "LotteryPicker.h"

@interface BetSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BetPickerDelegate, LotteryPickerDelegate>
{
    NSMutableArray *betListArr;
     
    int totalPage;
    int CurrentPage;
   
    
     BOOL _loadingMore;
    NSUInteger dataNumber;
    NSMutableArray *tableMoreData;
    UILabel *loadMoreText;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    UILabel *myMessagelabel;
    
    NSArray *dateArray;
    
    NSString *startDate;
    NSString *endDate;
    BOOL mark;
    
    NSMutableArray *lotteryArray;
    NSMutableArray *subLotteryArr;
    
    NSString *lotteryTypeStr;
    NSString *lotteryText;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UITableView *betTabelView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (nonatomic, weak) IBOutlet BetPicker *pv;

@property (weak, nonatomic) IBOutlet UIView *lotteryTypeView;
@property (nonatomic, weak) IBOutlet UILabel *lotteryLab;
@property (nonatomic, weak) IBOutlet LotteryPicker *lp;

- (IBAction)returnBtnClk:(UIButton *)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)okClick:(id)sender;

- (IBAction)lotteryTypeClk:(id)sender;
- (IBAction)cancel2Click:(id)sender;
- (IBAction)ok2Click:(id)sender;

@end
