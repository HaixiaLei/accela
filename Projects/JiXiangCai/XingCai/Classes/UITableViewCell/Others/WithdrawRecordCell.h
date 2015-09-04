//
//  WithdrawRecordCell.h
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WithdrawRecordObject;
@interface WithdrawRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *tradeNoLB;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *yueLB;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;

- (void)updateWithWithdrawRecordObject:(WithdrawRecordObject *)withdrawRecordObject;
@end
