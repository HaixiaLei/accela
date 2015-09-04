//
//  MyMsgCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MyMsgCell.h"
#import "MsgListObject.h"

@implementation MyMsgCell

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
- (void)updateMsgObject:(MsgListObject *) msgObject
{
    if ([msgObject subject].length==0)
    {
        self.contentLab.text =@"无标题";
    }
    else
    {
        self.contentLab.text = [msgObject subject];
    }
    
    self.dateLab.text = [[msgObject sendtime] substringToIndex:10];
}
@end
