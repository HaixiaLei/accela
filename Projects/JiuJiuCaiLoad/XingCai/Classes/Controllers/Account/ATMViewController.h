//
//  ATMViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-3-10.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "AtmPicker.h"

@interface ATMViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AtmPickerDelegate>
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
    
    NSArray *dateArray;
    NSString *startDate;
    NSString *endDate;
}
@property (weak, nonatomic) IBOutlet UITableView *atmTableView;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (nonatomic, weak) IBOutlet AtmPicker *pv;

-(IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)selectDate:(id)sender;
-(IBAction)okClick:(id)sender;

@end
