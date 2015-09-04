//
//  HeadSelectCell.h
//  XingCai
//
//  Created by Sywine on 12/25/14.
//  Copyright (c) 2014 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadSelectCellButtonEchoProtocol <NSObject>

-(void)HeadSelectCellButtonPressedWithIndex:(NSInteger)index;

@end

@interface HeadSelectCell : UITableViewCell

@property (assign, nonatomic) id<HeadSelectCellButtonEchoProtocol>delegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonChongqing;

- (IBAction)buttonPressed:(UIButton *)button;
@end
