//
//  BetRecordsCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetRecordsCell.h"
#import "BetRecordsObject.h"

@implementation BetRecordsCell

- (void)awakeFromNib{}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    //点击变色
    [super setHighlighted:highlighted animated:animated];
    self.arrowImg.highlighted = highlighted;
}
- (void)updateBetRecordsObject:(BetRecordsObject *) betRecordsObject
{
    self.issueLab.text = [betRecordsObject.issue stringByAppendingString:@"期"];
    
    //重庆
    if ([betRecordsObject.lotteryid isEqualToString:@"1"])
    {
        _japanOrCq.image = [UIImage imageNamed:@"CQ-Lottery-icon"];
    }
    //日本
    else if ([betRecordsObject.lotteryid isEqualToString:@"15"])
    {
        _japanOrCq.image = [UIImage imageNamed:@"JP-Lottery-icon"];
    }
    
    self.methodNameLab.text = betRecordsObject.methodname;
    
    if ([[betRecordsObject iscancel] isEqualToString:@"1"])
    {
        self.statusLab.text = @"本人撤单";
        self.statusLab.textColor = [UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:1];
        
        if ([betRecordsObject.isgetprize isEqualToString:@"0"])
        {
            _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
            self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.oneLab.text = @"--";
            
            _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
            self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.twoLab.text = @"--";
            
            _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
            self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.threeLab.text = @"--";
            
            _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
            self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fourLab.text = @"--";
            
            _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
            self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fiveLab.text = @"--";
        }
        else if ([betRecordsObject.isgetprize isEqualToString:@"2"])
        {
            if ([betRecordsObject.nocode isEqualToString:@""])
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.oneLab.text = @"--";
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.twoLab.text = @"--";
                
                _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.threeLab.text = @"--";
                
                _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fourLab.text = @"--";
                
                _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fiveLab.text = @"--";
            }
            else
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting2-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.oneLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(0, 1)];
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting2-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.twoLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(1, 1)];
                
                
                _noImgThree.image = [UIImage imageNamed:@"Betting2-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.threeLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(2, 1)];
                
                
                _noImgFour.image = [UIImage imageNamed:@"Betting2-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fourLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(3, 1)];
                
                
                _noImgFive.image = [UIImage imageNamed:@"Betting2-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fiveLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(4, 1)];
            }
        }
    }
    else if ([[betRecordsObject iscancel] isEqualToString:@"2"])
    {
        self.statusLab.text = @"管理员撤单";
        self.statusLab.textColor = [UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:1];
        
        if ([betRecordsObject.isgetprize isEqualToString:@"0"])
        {
            _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
            self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.oneLab.text = @"--";
            
            _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
            self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.twoLab.text = @"--";
            
            _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
            self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.threeLab.text = @"--";
            
            _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
            self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fourLab.text = @"--";
            
            _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
            self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fiveLab.text = @"--";
        }
        else if ([betRecordsObject.isgetprize isEqualToString:@"2"])
        {
            if ([betRecordsObject.nocode isEqualToString:@""])
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.oneLab.text = @"--";
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.twoLab.text = @"--";
                
                _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.threeLab.text = @"--";
                
                _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fourLab.text = @"--";
                
                _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fiveLab.text = @"--";
            }
            else
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting2-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.oneLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(0, 1)];
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting2-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.twoLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(1, 1)];
                
                
                _noImgThree.image = [UIImage imageNamed:@"Betting2-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.threeLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(2, 1)];
                
                
                _noImgFour.image = [UIImage imageNamed:@"Betting2-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fourLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(3, 1)];
                
                
                _noImgFive.image = [UIImage imageNamed:@"Betting2-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fiveLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(4, 1)];
            }
        }
    }
    else if ([[betRecordsObject iscancel] isEqualToString:@"3"])
    {
        self.statusLab.text = @"开错奖撤单";
        self.statusLab.textColor = [UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:1];
        
        if ([betRecordsObject.isgetprize isEqualToString:@"0"])
        {
            _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
            self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.oneLab.text = @"--";
            
            _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
            self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.twoLab.text = @"--";
            
            _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
            self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.threeLab.text = @"--";
            
            _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
            self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fourLab.text = @"--";
            
            _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
            self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fiveLab.text = @"--";
        }
        else if ([betRecordsObject.isgetprize isEqualToString:@"2"])
        {
            if ([betRecordsObject.nocode isEqualToString:@""])
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.oneLab.text = @"--";
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.twoLab.text = @"--";
                
                _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.threeLab.text = @"--";
                
                _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fourLab.text = @"--";
                
                _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fiveLab.text = @"--";
            }
            else
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting2-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.oneLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(0, 1)];
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting2-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.twoLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(1, 1)];
                
                
                _noImgThree.image = [UIImage imageNamed:@"Betting2-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.threeLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(2, 1)];
                
                
                _noImgFour.image = [UIImage imageNamed:@"Betting2-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fourLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(3, 1)];
                
                
                _noImgFive.image = [UIImage imageNamed:@"Betting2-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fiveLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(4, 1)];
            }
        }
    }
    else if ([[betRecordsObject iscancel] isEqualToString:@"0"])
    {
        if ([[betRecordsObject isgetprize] isEqualToString:@"0"])
        {
            self.statusLab.text = @"未开奖";
            self.statusLab.textColor = [UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:1];
            
            _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
            self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.oneLab.text = @"--";
            
            _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
            self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.twoLab.text = @"--";
            
            _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
            self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.threeLab.text = @"--";
            
            _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
            self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fourLab.text = @"--";
            
            _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
            self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
            self.fiveLab.text = @"--";
        }
        else if ([[betRecordsObject isgetprize] isEqualToString:@"2"])
        {
            self.statusLab.text = @"未中奖";
            self.statusLab.textColor = [UIColor colorWithRed:(85/255.0) green:(85/255.0) blue:(85/255.0) alpha:1];
            
            if ([betRecordsObject.nocode isEqualToString:@""])
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.oneLab.text = @"--";
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.twoLab.text = @"--";
                
                _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.threeLab.text = @"--";
                
                _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fourLab.text = @"--";
                
                _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                self.fiveLab.text = @"--";
            }
            else
            {
                _noImgOne.image = [UIImage imageNamed:@"Betting2-No"];
                self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.oneLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(0, 1)];
                
                _noImgTwo.image = [UIImage imageNamed:@"Betting2-No"];
                self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.twoLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(1, 1)];
                
                
                _noImgThree.image = [UIImage imageNamed:@"Betting2-No"];
                self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.threeLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(2, 1)];
                
                
                _noImgFour.image = [UIImage imageNamed:@"Betting2-No"];
                self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fourLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(3, 1)];
                
                
                _noImgFive.image = [UIImage imageNamed:@"Betting2-No"];
                self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                self.fiveLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(4, 1)];
            }
        }
        else
        {
            if ([[betRecordsObject prizestatus] isEqualToString:@"0"])
            {
                self.statusLab.text = @"未派奖";
                self.statusLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                
                if ([betRecordsObject.nocode isEqualToString:@""])
                {
                    _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
                    self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.oneLab.text = @"--";
                    
                    _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
                    self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.twoLab.text = @"--";
                    
                    _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
                    self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.threeLab.text = @"--";
                    
                    _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
                    self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.fourLab.text = @"--";
                    
                    _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
                    self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.fiveLab.text = @"--";
                }
                else
                {
                    _noImgOne.image = [UIImage imageNamed:@"Betting2-No"];
                    self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.oneLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(0, 1)];
                    
                    _noImgTwo.image = [UIImage imageNamed:@"Betting2-No"];
                    self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.twoLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(1, 1)];
                    
                    
                    _noImgThree.image = [UIImage imageNamed:@"Betting2-No"];
                    self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.threeLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(2, 1)];
                    
                    
                    _noImgFour.image = [UIImage imageNamed:@"Betting2-No"];
                    self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.fourLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(3, 1)];
                    
                    
                    _noImgFive.image = [UIImage imageNamed:@"Betting2-No"];
                    self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.fiveLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(4, 1)];
                }
            }
            else
            {
                self.statusLab.text = @"已派奖";
                self.statusLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                
                if ([betRecordsObject.nocode isEqualToString:@""])
                {
                    _noImgOne.image = [UIImage imageNamed:@"Betting1-No"];
                    self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.oneLab.text = @"--";
                    
                    _noImgTwo.image = [UIImage imageNamed:@"Betting1-No"];
                    self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.twoLab.text = @"--";
                    
                    _noImgThree.image = [UIImage imageNamed:@"Betting1-No"];
                    self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.threeLab.text = @"--";
                    
                    _noImgFour.image = [UIImage imageNamed:@"Betting1-No"];
                    self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.fourLab.text = @"--";
                    
                    _noImgFive.image = [UIImage imageNamed:@"Betting1-No"];
                    self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(114/255.0) blue:(6/255.0) alpha:1];
                    self.fiveLab.text = @"--";
                }
                else
                {
                    _noImgOne.image = [UIImage imageNamed:@"Betting2-No"];
                    self.oneLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.oneLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(0, 1)];
                    
                    _noImgTwo.image = [UIImage imageNamed:@"Betting2-No"];
                    self.twoLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.twoLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(1, 1)];
                    
                    
                    _noImgThree.image = [UIImage imageNamed:@"Betting2-No"];
                    self.threeLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.threeLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(2, 1)];
                    
                    
                    _noImgFour.image = [UIImage imageNamed:@"Betting2-No"];
                    self.fourLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.fourLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(3, 1)];
                    
                    
                    _noImgFive.image = [UIImage imageNamed:@"Betting2-No"];
                    self.fiveLab.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
                    self.fiveLab.text = [betRecordsObject.nocode substringWithRange:NSMakeRange(4, 1)];
                }
            }
        }
    }
    
    self.codeLab.text = betRecordsObject.code;
    
    self.totalpriceLab.text = betRecordsObject.totalprice;
    
    self.multipleLab.text = betRecordsObject.multiple;
    
    self.bonusLab.text = betRecordsObject.bonus;
}
@end
