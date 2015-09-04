//
//  WithdrawRecordCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "WithdrawRecordCell.h"
#import "WithdrawRecordObject.h"

@implementation WithdrawRecordCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    //self.tradeNoLB.textColor = highlighted ? [UIColor colorWithRed:255.0/255 green:203.0/255 blue:46.0/255 alpha:1.0] : [UIColor colorWithRed:143.0/255 green:143.0/255 blue:143.0/255 alpha:1.0];
}

- (void)updateWithWithdrawRecordObject:(WithdrawRecordObject *)withdrawRecordObject
{
    self.timeLB.text = withdrawRecordObject.times;
    self.tradeNoLB.text = [NSString stringWithFormat:@"交易编号:%@",withdrawRecordObject.orderno];
    
    self.typeLB.text = withdrawRecordObject.cntitle;

    if ([withdrawRecordObject.transferstatus intValue] == 1 || [withdrawRecordObject.transferstatus intValue] == 3)
    {
        self.statusLB.text = @"失败";
    }
    else
    {
        self.statusLB.text = @"成功";
    }
    self.balanceLB.text = withdrawRecordObject.availablebalance;
    
    CGRect frame = self.balanceLB.frame;
    [self.balanceLB sizeToFit];
    CGRect frameFit = self.balanceLB.frame;
    frame.size.width = frameFit.size.width;
    frame.origin.x = 320 - 20 - frame.size.width;
    self.balanceLB.frame = frame;
    
    CGRect frameYE = self.yueLB.frame;
    frameYE.origin.x = frame.origin.x - frameYE.size.width;
    self.yueLB.frame = frameYE;
    
    int operations = [withdrawRecordObject.operations intValue];
    NSString *amountString = withdrawRecordObject.amount;
    if (operations == 0)
    {
        amountString = [@"-" stringByAppendingString:amountString];
    }
    else
    {
        amountString = [@"+" stringByAppendingString:amountString];
    }
    self.amountLB.text = amountString;
}
@end
