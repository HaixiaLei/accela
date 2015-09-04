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

@interface ZhuiHaoViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,TDDatePickerControllerDelegate>
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
}
@property (weak, nonatomic) IBOutlet UITableView *zhuihaoTableView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property(weak,nonatomic) IBOutlet UILabel *startLab;
@property(weak,nonatomic) IBOutlet UILabel *endLab;

- (IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)startDate:(id)sender;
-(IBAction)endDate:(id)sender;
-(IBAction)searchClk:(id)sender;

@end
