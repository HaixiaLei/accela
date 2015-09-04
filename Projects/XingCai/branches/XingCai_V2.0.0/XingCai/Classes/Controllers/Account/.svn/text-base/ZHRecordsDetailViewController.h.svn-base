//
//  ZHRecordsDetailViewController.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHRecordsDetailViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *zhDetailArr;
    
    BOOL hidden;
    BOOL isAnimating;
    CGFloat _lastPosition;
}

@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (nonatomic,strong) NSString *isCancel;
@property (nonatomic,strong) NSString *taskID;
@property (weak,nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *flagBtn;
@property (weak, nonatomic) IBOutlet UIButton *flagTempBtn;

@property(weak,nonatomic) IBOutlet UILabel *lotteryName;
@property(weak,nonatomic) IBOutlet UILabel *userLab;
@property(weak,nonatomic) IBOutlet UILabel *jiangqiLab;
@property(weak,nonatomic) IBOutlet UILabel *timeLab;
@property(weak,nonatomic) IBOutlet UILabel *wanfaLab;
@property(weak,nonatomic) IBOutlet UILabel *modesLab;
@property(weak,nonatomic) IBOutlet UILabel *zhuiHaoJinELab;
@property(weak,nonatomic) IBOutlet UILabel *issueCountLab;
@property(weak,nonatomic) IBOutlet UILabel *finishPriceLab;
@property(weak,nonatomic) IBOutlet UILabel *finishedCountLab;
@property(weak,nonatomic) IBOutlet UILabel *taskSumBonusLab;
@property(weak,nonatomic) IBOutlet UILabel *stopOnWinLab;
@property(weak,nonatomic) IBOutlet UILabel *taskIDLab;
@property(weak,nonatomic) IBOutlet UITextView *codesTV;

- (IBAction)cancelClk:(id)sender;

@end
