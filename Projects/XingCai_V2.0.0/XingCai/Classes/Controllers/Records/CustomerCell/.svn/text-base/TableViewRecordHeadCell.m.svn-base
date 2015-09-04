//
//  TableViewRecordHeadCell.m
//  XingCai
//
//  Created by Villiam on 10/20/14.
//  Copyright (c) 2014 weststar. All rights reserved.
//

#import "TableViewRecordHeadCell.h"

@implementation TableViewRecordHeadCell

- (void)awakeFromNib {
    // Initialization code
    [self rotateLabel:self.firstNum withAngle:45];
    [self rotateLabel:self.secondNum withAngle:120];
    [self rotateLabel:self.thirdNum withAngle:0];
    [self rotateLabel:self.forthNum withAngle:-120];
    [self rotateLabel:self.fifthNum withAngle:-45];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)rotateLabel:(UILabel *)label withAngle:(NSInteger)angle
{
    label.transform=CGAffineTransformMakeRotation(angle);
}
@end
