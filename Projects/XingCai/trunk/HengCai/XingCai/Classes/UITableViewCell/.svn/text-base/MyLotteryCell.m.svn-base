//
//  MyLotteryCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MyLotteryCell.h"
#import "MyLotteryObject.h"

@implementation MyLotteryCell

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
    
    self.bgImageView.highlighted = highlighted;
    
    self.lotteryName.textColor = highlighted ? [UIColor colorWithRed:255.0/255 green:203.0/255 blue:46.0/255 alpha:1.0] : [UIColor colorWithRed:163.0/255 green:156.0/255 blue:156.0/255 alpha:1.0];
    self.price.textColor = highlighted ? [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] : [UIColor colorWithRed:163/255.0 green:156/255.0 blue:156/255.0 alpha:1.0];
    self.time.textColor = highlighted ? [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] : [UIColor colorWithRed:163/255.0 green:156/255.0 blue:156/255.0 alpha:1.0];
    self.numberLB.textColor = [UIColor colorWithRed:163/255.0 green:156/255.0 blue:156/255.0 alpha:1.0];
    self.lotteryNumber.textColor = [UIColor greenColor];
    
    if (highlighted) {
//        self.status.textColor = [UIColor greenColor];
    }
    else
    {
        switch (self.isgetprize) {
            case 1:
            {
                self.status.textColor = [UIColor colorWithRed:255.0/255 green:203.0/255 blue:46.0/255 alpha:1.0];
                break;
            }
            default:
            {
                self.status.textColor = [UIColor colorWithRed:163.0/255 green:156.0/255 blue:156.0/255 alpha:1.0];
                break;
            }
        }
    }
}

- (void)updateWithMyLotteryObject:(MyLotteryObject *)myLotteryObject
{
    self.lotteryName.text = myLotteryObject.cnname;
    self.lotteryNumber.text = myLotteryObject.issue;
    self.time.text = myLotteryObject.writetime;
    self.price.text = myLotteryObject.totalprice;
    
    NSInteger isgetprize = [myLotteryObject.isgetprize integerValue];
    self.isgetprize = isgetprize;
//    switch (isgetprize) {
//        case 0:
//        {
//            self.status.text = @"未开奖";
//            break;
//        }
//        case 1:
//        {
//            NSInteger prizestatus = [myLotteryObject.prizestatus integerValue];
//            switch (prizestatus) {
//                case 0:
//                {
//                    self.status.text = @"未派奖";
//                    break;
//                }
//                default:
//                {
//                    self.status.text = @"已派奖";
//                    break;
//                }
//            }
//            break;
//        }
//        case 2:
//        {
//            self.status.text = @"未中奖";
//            break;
//        }
//        default:
//            break;
//    }
    
    if ([[myLotteryObject iscancel] isEqualToString:@"1"])
    {
        self.status.text = @"本人撤单";
    }
    else if ([[myLotteryObject iscancel] isEqualToString:@"2"])
    {
        self.status.text = @"平台撤单";
    }
    else if ([[myLotteryObject iscancel] isEqualToString:@"3"])
    {
        self.status.text = @"错开撤单";
    }
    else if ([[myLotteryObject iscancel] isEqualToString:@"0"])
    {
        if ([[myLotteryObject isgetprize] isEqualToString:@"0"])
        {
            self.status.text = @"未开奖";
        }
        else if ([[myLotteryObject isgetprize] isEqualToString:@"2"])
        {
            self.status.text = @"未中奖";
        }
        else
        {
            if ([[myLotteryObject prizestatus] isEqualToString:@"0"])
            {
                self.status.text = @"未派奖";
            }
            else
            {
                self.status.text = @"已派奖";
            }
        }
    }
    
    if (isgetprize == 1) {
        self.bonusLB.text = myLotteryObject.bonus;
        CGRect frame = self.bonusLB.frame;
        [self.bonusLB sizeToFit];
        CGRect frameB = self.bonusLB.frame;
        frame.size.width = frameB.size.width;
        self.bonusLB.frame = frame;
        
        CGRect frameY = self.yuanLB.frame;
        frameY.origin.x = frame.origin.x + frame.size.width;
        self.yuanLB.frame = frameY;
        
        self.bonusLB.hidden = NO;
        self.yuanLB.hidden = NO;
    }
    else
    {
        self.bonusLB.hidden = YES;
        self.yuanLB.hidden = YES;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"mylottery_icon_%d",[myLotteryObject.lotteryid intValue]];
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        self.lotteryIcon.image = image;
    }
    else
    {
        self.lotteryIcon.image = [UIImage imageNamed:@"mylottery_icon_default"];
    }
}
@end
