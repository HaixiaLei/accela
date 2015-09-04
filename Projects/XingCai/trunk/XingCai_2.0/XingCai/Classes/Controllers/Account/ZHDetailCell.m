//
//  ZHDetailCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZHDetailCell.h"
#import "ZhuiHaoItemObject.h"

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
- (void)updateZHDetailObject:(ZhuiHaoItemObject *) zhDetailObj
{
    if (![[zhDetailObj issue] isKindOfClass:[NSNull class]])
    {
        self.issueLab.text = [zhDetailObj.issue stringByAppendingString:@"期"];
    }
    else
    {
        self.issueLab.text = @"";
    }
    
    if ([[zhDetailObj status] isEqualToString:@"0"])
    {
        self.statusLab.text = @"进行中";
    }
    else if ([[zhDetailObj status] isEqualToString:@"1"])
    {
        self.statusLab.text = @"已完成";
    }
    else
    {
        self.statusLab.text = @"已取消";
    }
  
    if (![[zhDetailObj bonus] isKindOfClass:[NSNull class]])
    {
        self.totalPriceLab.text = [zhDetailObj bonus];
    }
    else
    {
        self.totalPriceLab.text = @"------";
    }
}
@end
