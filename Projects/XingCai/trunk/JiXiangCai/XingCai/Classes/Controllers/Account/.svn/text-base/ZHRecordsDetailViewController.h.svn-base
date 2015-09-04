//
//  ZHRecordsDetailViewController.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"

@interface ZHRecordsDetailViewController : DerivedViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *zhDetailArr;
    NSMutableArray *cellArray;
    NSMutableArray *beanTwoArray;
    NSMutableArray *tempArray;
    NSInteger zhTimes;
    
    BOOL hidden;
    BOOL isAnimating;
    CGFloat _lastPosition;
}

@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak,nonatomic) IBOutlet UIButton *selectAllBtn;
@property (nonatomic,strong) NSString *isCancel;
@property (nonatomic,strong) NSString *taskidcode;
@property (weak,nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *flagBtn;
@property (weak, nonatomic) IBOutlet UIButton *flagTempBtn;

@property (weak,nonatomic) IBOutlet UILabel *cnnameLab;
@property (weak,nonatomic) IBOutlet UILabel *methodnameLab;
@property (weak,nonatomic) IBOutlet UILabel *beginissueLab;
@property (weak,nonatomic) IBOutlet UILabel *taskpriceLab;
@property (weak,nonatomic) IBOutlet UILabel *modesLab;
@property (weak,nonatomic) IBOutlet UITextView *codesTV;
@property (weak,nonatomic) IBOutlet UILabel *begintimeLab;
@property (weak,nonatomic) IBOutlet UILabel *issuecountLab;
@property (weak,nonatomic) IBOutlet UILabel *finishedcountLab;
@property (weak,nonatomic) IBOutlet UILabel *cancelcountLab;
@property (weak,nonatomic) IBOutlet UILabel *statusLab;
@property (weak,nonatomic) IBOutlet UILabel *bottomLab;

- (IBAction)btnSelectAllClick:(id)sender;
- (IBAction)cancelClk:(id)sender;

@end
