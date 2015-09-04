//
//  RightItemTableViewCell.m
//  JiXiangCai
//
//  Created by jay on 14-9-25.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "RightItemTableViewCell.h"

@implementation RightItemTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.numberLB.layer.cornerRadius = 5;
    self.numberLB.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    self.iconButton.selected = selected;
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ff7204"];
        self.contentLB.textColor = [UIColor whiteColor];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentLB.textColor = [UIColor colorWithHexString:@"#d3d4d5"];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}
- (void)setIconImagesWithIndex:(NSInteger)index
{
    NSString *imgName_n = [NSString stringWithFormat:@"rightsidedrawer_item_%ld_n",(long)index];
    NSString *imgName_s = [NSString stringWithFormat:@"rightsidedrawer_item_%ld_s",(long)index];
    UIImage *image_n = [UIImage imageNamed:imgName_n];
    UIImage *image_s = [UIImage imageNamed:imgName_s];
    
    [self.iconButton setImage:image_n forState:UIControlStateNormal];
    [self.iconButton setImage:image_s forState:UIControlStateSelected];
}

- (void)setNumber:(NSString *)number
{
    if ([number respondsToSelector:@selector(stringValue)]) {
        number = [number performSelector:@selector(stringValue)];
    }
    CGPoint center = self.numberLB.center;
    self.numberLB.text = number;
    [self.numberLB sizeToFit];
    CGRect frame = self.numberLB.frame;
    frame.size.width += 6;
    self.numberLB.frame = frame;
    self.numberLB.center = center;
}
@end
