//
//  ZHDetailCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZHDetailCell.h"
#import "ZHDetailObject.h"

@implementation ZHDetailCell

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
- (void)updateZHDetailObject:(ZHDetailObject *) zhDetailObj
{
    self.issueLab.text = [zhDetailObj.issue stringByAppendingString:@"期"];
    
    if ([zhDetailObj.status isEqualToString:@"0"])
    {
        self.statusLab.text = @"追号中";
    }
    else if ([zhDetailObj.status isEqualToString:@"1"])
    {
        self.statusLab.text = @"已完成";
    }
    else if ([zhDetailObj.status isEqualToString:@"2"])
    {
        self.statusLab.text = @"已取消";
    }
    
    self.multipleLab.text = zhDetailObj.multiple;
    
    self.flagLab.text = zhDetailObj.flag;
}
@end
