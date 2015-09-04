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

@interface BetSearchViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,TDDatePickerControllerDelegate>
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
}
@property (weak, nonatomic) IBOutlet UIButton *searchButtton;
@property (weak, nonatomic) IBOutlet UITableView *betTabelView;

@property(weak,nonatomic) IBOutlet UILabel *startLab;
@property(weak,nonatomic) IBOutlet UILabel *endLab;

- (IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)startDate:(id)sender;
-(IBAction)endDate:(id)sender;
-(IBAction)searchClk:(id)sender;


//// 创建表格底部
//
//- (void) createTableFooter;
//
//// 开始加载数据
//
//- (void) loadDataBegin;
//
//// 加载数据中
//
//- (void) loadDataing;
//
//// 加载数据完毕
//
//- (void) loadDataEnd;
//

@end
