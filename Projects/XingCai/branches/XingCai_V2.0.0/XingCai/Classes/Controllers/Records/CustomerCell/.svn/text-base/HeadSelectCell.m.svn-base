//
//  HeadSelectCell.m
//  XingCai
//
//  Created by Sywine on 12/25/14.
//  Copyright (c) 2014 weststar. All rights reserved.
//

#import "HeadSelectCell.h"

@implementation HeadSelectCell{
    UIButton *selectedButton;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    selectedButton = self.buttonChongqing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonPressed:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
//        [button setBackgroundColor:[UIColor redColor]];
        
        selectedButton.selected = NO;
//        [selectedButton setBackgroundColor:[UIColor clearColor]];
        
        selectedButton = button;
        
        if ([self.delegate respondsToSelector:@selector(HeadSelectCellButtonPressedWithIndex:)]) {
            [self.delegate HeadSelectCellButtonPressedWithIndex:button.tag];
        }
    }
}
@end
