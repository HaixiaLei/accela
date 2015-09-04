//
//  ZhuiHaoDetailViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-6-29.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuiHaoDetailViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *zhItemListArr;
    int alertFlag;
}

@property(nonatomic,strong) NSString *taskID;
@property(nonatomic,strong) NSString *isCancel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lotteryImg;
@property(weak,nonatomic) IBOutlet UILabel *lotteryName;
@property(weak,nonatomic) IBOutlet UILabel *jiangqiLab;
@property(weak,nonatomic) IBOutlet UILabel *userLab;
@property(weak,nonatomic) IBOutlet UILabel *timeLab;
@property(weak,nonatomic) IBOutlet UILabel *wanfaLab;
@property(weak,nonatomic) IBOutlet UILabel *modesLab;
@property(weak,nonatomic) IBOutlet UILabel *zhuiHaoJinELab;
@property(weak,nonatomic) IBOutlet UILabel *issueCountLab;
@property(weak,nonatomic) IBOutlet UILabel *finishPriceLab;
@property(weak,nonatomic) IBOutlet UILabel *finishedCountLab;
@property(weak,nonatomic) IBOutlet UILabel *taskSumBonusLab;
@property(weak,nonatomic) IBOutlet UILabel *stopOnWinLab;
@property(weak,nonatomic) IBOutlet UITextView *codesTV;
@property(weak,nonatomic) IBOutlet UILabel *taskIDLab;

-(IBAction)cancelClk:(UIButton *)sender;

@end
