//
//  ZhuiHaoDetailViewController.h
//  JiuJiuCai
//
//  Created by Air.Zhao on 14-6-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuiHaoDetailViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *zhItemListArr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) NSString *taskID;
@property(nonatomic,strong) NSString *isCancel;

@property(weak,nonatomic) IBOutlet UILabel *lotteryName;
@property(weak,nonatomic) IBOutlet UILabel *wanfaLab;
@property(weak,nonatomic) IBOutlet UILabel *jiangqiLab;
@property(weak,nonatomic) IBOutlet UILabel *timeLab;
@property(weak,nonatomic) IBOutlet UILabel *userLab;
@property(weak,nonatomic) IBOutlet UILabel *zhuiHaoJinELab;
@property(weak,nonatomic) IBOutlet UILabel *finishPriceLab;
@property(weak,nonatomic) IBOutlet UILabel *modesLab;
@property(weak,nonatomic) IBOutlet UILabel *issueCountLab;
@property(weak,nonatomic) IBOutlet UILabel *finishedCountLab;
@property(weak,nonatomic) IBOutlet UILabel *stopOnWinLab;
@property(weak,nonatomic) IBOutlet UITextView *codesTV;
@property(weak,nonatomic) IBOutlet UILabel *taskIDLab;
@property(weak,nonatomic) IBOutlet UILabel *taskSumBonusLab;
@property(nonatomic,retain) UIAlertView *askAlertView;
@property(nonatomic,retain) UIAlertView *confirmAlertView;
@property(nonatomic,retain) UIAlertView *alreadyStopAlertView;
@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)returnBtnClk:(UIButton *)sender;
-(IBAction)cancelClk:(UIButton *)sender;

@end
