//
//  TableViewRecordHeadCell.h
//  XingCai
//
//  Created by Villiam on 10/20/14.
//  Copyright (c) 2014 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewRecordHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *awardDate;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *firstNum;
@property (weak, nonatomic) IBOutlet UILabel *secondNum;
@property (weak, nonatomic) IBOutlet UILabel *thirdNum;
@property (weak, nonatomic) IBOutlet UILabel *forthNum;
@property (weak, nonatomic) IBOutlet UILabel *fifthNum;

@property (weak, nonatomic) IBOutlet UILabel *lotteryType;
@end
