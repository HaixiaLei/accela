//
//  BetRecordDetailViewController.h
//  JiXiangCai
//
//  Created by Air.Zhao on 14-9-25.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"

@interface BetRecordDetailViewController : DerivedViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) NSString *projectID;
@property(nonatomic,strong) NSString *issueStr;
@property (nonatomic, weak) IBOutlet UILabel *projectIDLab;
@property (nonatomic, weak) IBOutlet UILabel *cnnameLab;
@property (nonatomic, weak) IBOutlet UILabel *methodnameLab;
//投注方式
@property (nonatomic, weak) IBOutlet UILabel *taskidLab;
@property (nonatomic, weak) IBOutlet UILabel *totalpriceLab;
@property (nonatomic, weak) IBOutlet UILabel *multipleLab;
@property (nonatomic, weak) IBOutlet UILabel *modesLab;
@property (nonatomic, weak) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIImageView *noImg1;
@property (nonatomic, weak) IBOutlet UILabel *nocodeLab1;
@property (weak, nonatomic) IBOutlet UIImageView *noImg2;
@property (nonatomic, weak) IBOutlet UILabel *nocodeLab2;
@property (weak, nonatomic) IBOutlet UIImageView *noImg3;
@property (nonatomic, weak) IBOutlet UILabel *nocodeLab3;
@property (weak, nonatomic) IBOutlet UIImageView *noImg4;
@property (nonatomic, weak) IBOutlet UILabel *nocodeLab4;
@property (weak, nonatomic) IBOutlet UIImageView *noImg5;
@property (nonatomic, weak) IBOutlet UILabel *nocodeLab5;
@property (nonatomic, weak) IBOutlet UILabel *bonusLab;
@property (nonatomic, weak) IBOutlet UITextView *nocodeTV;
@property (nonatomic, weak) IBOutlet UILabel *writetimeLab;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelClk:(id)sender;

@end
