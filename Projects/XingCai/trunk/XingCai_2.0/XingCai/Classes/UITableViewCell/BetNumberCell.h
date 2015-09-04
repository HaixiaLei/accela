//
//  BetNumberCell.h
//  XingCai
//
//  Created by jay on 14-3-5.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetNumberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *betNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBetLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end
