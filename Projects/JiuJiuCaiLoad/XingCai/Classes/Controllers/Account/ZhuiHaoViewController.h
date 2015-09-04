//
//  ZhuiHaoViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-12.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "ZhuiHaoPicker.h"
#import "LotteryPicker.h"

@interface ZhuiHaoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ZhuiHaoPickerDelegate,LotteryPickerDelegate>
{
    NSMutableArray *zhListArr;
    
    int totalPage;
    int zuihaoPage;
    int CurrentPage;
    
    UILabel *loadMoreText;
    
    NSUInteger dataNumber;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    UILabel *myMessagelabel;

    BOOL mark;
    
    NSArray *dateArray;
    NSString *startDate;
    NSString *endDate;
    
    NSMutableArray *lotteryArray;
    NSMutableArray *subLotteryArr;

    NSString *lotteryTypeStr;
    NSString *lotteryText;

}
@property (nonatomic, weak) IBOutlet LotteryPicker *lp;
@property (weak, nonatomic) IBOutlet UIView *lotteryTypeView;
- (IBAction)cancel2Click:(id)sender;
- (IBAction)ok2Click:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lotteryLab;
@property (weak, nonatomic) IBOutlet UITableView *zhuihaoTableView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (nonatomic, weak) IBOutlet ZhuiHaoPicker *pv;
- (IBAction)lotteryTypeClk:(id)sender;
- (IBAction)returnBtnClk:(UIButton *)sender;

- (IBAction)selectDate:(id)sender;
-(IBAction)okClick:(id)sender;

@end
