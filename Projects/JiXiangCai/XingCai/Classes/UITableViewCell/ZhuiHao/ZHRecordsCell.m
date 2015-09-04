//
//  ZHRecordsCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZHRecordsCell.h"
#import "ZHRecordsObject.h"

@implementation ZHRecordsCell

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
- (void)updateZHRecordsObject:(ZHRecordsObject *) zhRecordsObj
{
    self.beginissueLab.text = [zhRecordsObj.beginissue stringByAppendingString:@"期"];
    
    //重庆
    if ([zhRecordsObj.lotteryid isEqualToString:@"1"])
    {
        _japanOrCq.image = [UIImage imageNamed:@"CQ-Lottery-icon"];
    }
    //日本
    else if ([zhRecordsObj.lotteryid isEqualToString:@"15"])
    {
        _japanOrCq.image = [UIImage imageNamed:@"JP-Lottery-icon"];
    }
    
    self.methodnameLab.text = zhRecordsObj.methodname;
    
    if ([zhRecordsObj.status isEqualToString:@"0"])
    {
        self.statusLab.text = @"追号中";
    }
    else if ([zhRecordsObj.status isEqualToString:@"1"])
    {
        self.statusLab.text = @"已取消";
    }
    else if ([zhRecordsObj.status isEqualToString:@"2"])
    {
        self.statusLab.text = @"已完成";
    }
    
    self.codesLab.text = zhRecordsObj.codes;
    
    self.betDateLab.text = [zhRecordsObj begintime];
    NSLog(@"%@",zhRecordsObj);
    if ([zhRecordsObj.stoponwin isEqualToString:@"1"])
    {
        self.stoponwinLab.text = @"是";
    }
    else
    {
        self.stoponwinLab.text = @"否";
    }
    
    self.taskpriceLab.text = zhRecordsObj.taskprice;
}
@end
