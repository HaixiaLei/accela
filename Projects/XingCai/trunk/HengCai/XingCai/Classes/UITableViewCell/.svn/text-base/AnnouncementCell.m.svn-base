//
//  AnnouncementCell.m
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AnnouncementCell.h"
#import "NoticeListObject.h"

@implementation AnnouncementCell

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
- (void)updateAnnouncementObject:(NoticeListObject *) nlObject index:(int) ind
{
    self.contentLab.lineBreakMode = UILineBreakModeWordWrap;
    self.contentLab.numberOfLines = 0;
    self.contentLab.text = [[[NSString stringWithFormat:@"%i",ind] stringByAppendingString:@"、"] stringByAppendingString:[nlObject subject]];
}
@end
