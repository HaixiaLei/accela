//
//  MyMsgCell.h
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MsgListObject;

@interface MyMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

- (void)updateMsgObject:(MsgListObject *) msgObject;
@end
