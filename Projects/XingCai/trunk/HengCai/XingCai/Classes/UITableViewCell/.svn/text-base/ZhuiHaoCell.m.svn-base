//
//  ZhuiHaoCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ZhuiHaoCell.h"
#import "ZhuiHaoObject.h"

@implementation ZhuiHaoCell

- (void)awakeFromNib{}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    //点击变色
    [super setHighlighted:highlighted animated:animated];
    self.bgImageView.highlighted = highlighted;
}
- (void)updateZHObject:(ZhuiHaoObject *) zhObject
{
    self.cnnameLab.text = [zhObject cnname];
    self.beginIssueLab.text = [[@"第" stringByAppendingString:[zhObject beginissue]] stringByAppendingString:@"期"];
    self.taskPriceLab.text = [zhObject taskprice];
    self.finishPriceLab.text = [zhObject finishprice];
    if ([[zhObject status] isEqualToString:@"0"])
    {
        self.statusLab.text = @"进行中";
    }
    else if ([[zhObject status] isEqualToString:@"1"])
    {
        self.statusLab.text = @"已取消";
    }
    else if ([[zhObject status] isEqualToString:@"2"])
    {
        self.statusLab.text = @"已完成";
    }
    
    if ([[zhObject stoponwin] isEqualToString:@"1"])
    {
        self.stoponWinLab.text = @"是";
    }
    else
    {
        self.stoponWinLab.text = @"否";
    }
    
    self.beginTimeLab.text = [zhObject begintime];
}
@end
