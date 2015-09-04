//
//  WithdrawViewController.h
//  HengCai
//
//  Created by jay on 14-8-7.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"

@class WithdrawObject;
@interface WithdrawViewController : UIViewController<PagedFlowViewDelegate,PagedFlowViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_vertical;
@property (weak, nonatomic) IBOutlet PagedFlowView *pagedFlowView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLB;
@property (weak, nonatomic) IBOutlet UILabel *monyScopeLB;
@property (weak, nonatomic) IBOutlet UILabel *timeCountLB;
@property (weak, nonatomic) IBOutlet UILabel *timeScopeLB;
@property (weak, nonatomic) IBOutlet UIImageView *moneyAmountBg;
@property (weak, nonatomic) IBOutlet UITextField *moneyAmountTF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) NSString *check;
@property (strong, nonatomic) WithdrawObject *withdrawObject;
@end
