//
//  MessageTableViewCell.m
//  JiXiangCai
//
//  Created by jay on 14-11-20.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title
{
    self.titleLB.text = title;
}

- (void)setStatusWithReadTime:(NSString *)readtime
{
    BOOL isRead = [readtime integerValue];
    self.statusLB.text = isRead ? @"已读" : @"未读";
    self.statusLB.hidden = isRead;
}

- (void)setTime:(NSString *)timeString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate = [df dateFromString:timeString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:myDate];
    
    BOOL isToday = (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
    
    NSArray *components = [timeString componentsSeparatedByString:@" "];
    if (isToday) {
        self.timeLB.text = [components lastObject];
    }
    else
    {
        self.timeLB.text = [components firstObject];
    }
}

- (void)setContent:(NSString *)content
{
    //adjust the label the the new height.
    CGRect newFrame = self.contentLB.frame;
    CGFloat height = [self contentLBHeightForContent:content];
    newFrame.size.height = height;
    self.contentLB.frame = newFrame;
    
    self.contentLB.text = content;
}

- (void)setExpandBtnPositionWithContent:(NSString *)content
{
    CGRect newFrame = self.expandBtn.frame;
    CGFloat height = [self cellHeightForContent:content];
    newFrame.origin.y = height - 31;
    self.expandBtn.frame = newFrame;
}

- (void)setSeparatorLinePositionWithContent:(NSString *)content
{
    CGRect newFrame = self.lineImgView.frame;
    CGFloat height = [self cellHeightForContent:content];
    newFrame.origin.y = height - 1;
    self.lineImgView.frame = newFrame;
}

- (void)setShowDetail:(BOOL)showDetail
{
    self.contentLB.hidden = !showDetail;
    self.expandBtn.selected = showDetail;
}

- (CGFloat)contentLBHeightForContent:(NSString *)content
{
    CGSize maximumLabelSize = CGSizeMake(self.contentLB.frame.size.width, FLT_MAX);
    CGSize expectedLabelSize = [content sizeWithFont:self.contentLB.font constrainedToSize:maximumLabelSize lineBreakMode:self.contentLB.lineBreakMode];
    return expectedLabelSize.height;
}
- (CGFloat)cellHeightForContent:(NSString *)content
{
    CGFloat expectedLabelHeight = [self contentLBHeightForContent:content];
    CGFloat height = 30 + expectedLabelHeight + 10;
    height = MAX(61, height);
    
    return height;
}
@end
