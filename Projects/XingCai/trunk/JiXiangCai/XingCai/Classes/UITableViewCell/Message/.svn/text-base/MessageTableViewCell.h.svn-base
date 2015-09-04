//
//  MessageTableViewCell.h
//  JiXiangCai
//
//  Created by jay on 14-11-20.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgView;

- (void)setTitle:(NSString *)title;
- (void)setStatusWithReadTime:(NSString *)readtime;
- (void)setTime:(NSString *)timeString;
- (void)setContent:(NSString *)content;
- (void)setExpandBtnPositionWithContent:(NSString *)content;
- (void)setSeparatorLinePositionWithContent:(NSString *)content;
- (void)setShowDetail:(BOOL)showDetail;

- (CGFloat)cellHeightForContent:(NSString *)content;
@end
