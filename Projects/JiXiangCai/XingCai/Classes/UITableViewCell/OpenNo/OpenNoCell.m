//
//  ZHDetailCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "OpenNoCell.h"
#import "OpenNoObject.h"

@implementation OpenNoCell

- (void)awakeFromNib{}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    //点击变色
    [super setHighlighted:highlighted animated:animated];
}
- (void)updateOpenNoObject:(OpenNoObject *) openNoObj
{
    self.issueLab.text = [openNoObj.issue stringByAppendingString:@"期"];
    
    //重庆
    if ([openNoObj.lotteryid isEqualToString:@"1"])
    {
        _japanOrCq.image = [UIImage imageNamed:@"CQ-Lottery-icon"];
    }
    //日本
    else if ([openNoObj.lotteryid isEqualToString:@"15"])
    {
        _japanOrCq.image = [UIImage imageNamed:@"JP-Lottery-icon"];
    }
    
    if ([[openNoObj statuscode] isEqualToString:@"0"])
    {
        self.statuscodeLab.text = @"未写入";
    }
    else if ([[openNoObj statuscode] isEqualToString:@"1"])
    {
        self.statuscodeLab.text = @"待验证";
    }
    else if ([[openNoObj statuscode] isEqualToString:@"2"])
    {
        //self.statuscodeLab.text = @"已验证";
        self.statuscodeLab.text = @"";
    }
    else if ([[openNoObj statuscode] isEqualToString:@"3"])
    {
        self.statuscodeLab.text = @"未开奖";
    }
    
    if ([openNoObj.statuscode isEqualToString:@"2"])
    {
        _noImgOne.image = [UIImage imageNamed:@"open-No-Yes"];
        self.oneLab.textColor = [UIColor whiteColor];
        self.oneLab.text = [openNoObj.code substringWithRange:NSMakeRange(0, 1)];
        
        _noImgTwo.image = [UIImage imageNamed:@"open-No-Yes"];
        self.twoLab.textColor = [UIColor whiteColor];
        self.twoLab.text = [openNoObj.code substringWithRange:NSMakeRange(1, 1)];
        
        _noImgThree.image = [UIImage imageNamed:@"open-No-Yes"];
        self.threeLab.textColor = [UIColor whiteColor];
        self.threeLab.text = [openNoObj.code substringWithRange:NSMakeRange(2, 1)];
        
        _noImgFour.image = [UIImage imageNamed:@"open-No-Yes"];
        self.fourLab.textColor = [UIColor whiteColor];
        self.fourLab.text = [openNoObj.code substringWithRange:NSMakeRange(3, 1)];
        
        _noImgFive.image = [UIImage imageNamed:@"open-No-Yes"];
        self.fiveLab.textColor = [UIColor whiteColor];
        self.fiveLab.text = [openNoObj.code substringWithRange:NSMakeRange(4, 1)];
    }
}
@end
