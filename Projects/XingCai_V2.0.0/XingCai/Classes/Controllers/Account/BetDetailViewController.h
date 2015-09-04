//
//  BetDetailViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-6-29.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetDetailViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate>
{
    int alertFlag;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) NSString *projectID;
@property(weak,nonatomic) IBOutlet UIButton *cancelBtn;
@property(weak,nonatomic) IBOutlet UILabel *lotteryName;
@property(weak,nonatomic) IBOutlet UIImageView *lotteryIcon;
@property(weak,nonatomic) IBOutlet UILabel *jiangqiLab;
@property(weak,nonatomic) IBOutlet UILabel *userLab;
@property(weak,nonatomic) IBOutlet UILabel *timeLab;
@property(weak,nonatomic) IBOutlet UILabel *wanfaLab;
@property(weak,nonatomic) IBOutlet UILabel *modesLab;
@property(weak,nonatomic) IBOutlet UILabel *jinELab;
@property(weak,nonatomic) IBOutlet UILabel *multipleLab;
@property(weak,nonatomic) IBOutlet UILabel *bonusLab;
@property(weak,nonatomic) IBOutlet UILabel *statusLab;
@property(weak,nonatomic) IBOutlet UILabel *projectIDLab;
@property(weak,nonatomic) IBOutlet UITextView *codeTV;

-(IBAction)cancelClk:(UIButton *)sender;

@end
