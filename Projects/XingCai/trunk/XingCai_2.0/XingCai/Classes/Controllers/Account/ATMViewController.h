//
//  ATMViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "TDDatePickerController.h"

@interface ATMViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,TDDatePickerControllerDelegate>
{
    NSMutableArray *atmListArr;
    
    int totalPage;
    int tPage;
    int CurrentPage;
    
    BOOL _loadingMore;
    NSUInteger dataNumber;
    UILabel *loadMoreText;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    UILabel *myMessagelabel;
    NSMutableArray *addArray;
    BOOL mark;
    
    UIView *_BGView;
    TDDatePickerController * _starDatePickerView;
    TDDatePickerController * _endDatePickerView;
    NSDate * _selectedDate;
}

@property (weak, nonatomic) IBOutlet UITableView *atmTableView;
@property(weak,nonatomic) IBOutlet UILabel *startLab;
@property(weak,nonatomic) IBOutlet UILabel *endLab;
@property(weak,nonatomic) IBOutlet UIImageView *bannerImg;

-(IBAction)startDate:(id)sender;
-(IBAction)endDate:(id)sender;
-(IBAction)searchClk:(id)sender;

@end
