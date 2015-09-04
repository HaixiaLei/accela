//
//  BetNumberCell.h
//  XingCai
//
//  Created by jay on 14-3-5.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "buyFinshObject.h"
@interface BetNumberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deleBgimg;
@property (weak, nonatomic) IBOutlet UILabel *moneyModesLable;
@property (weak, nonatomic) IBOutlet UILabel *zhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *beiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLable;

@property (weak, nonatomic) IBOutlet UIImageView *cellBottomLine;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *betNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBetLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (nonatomic,assign) BOOL revealing;
@property (nonatomic, weak) buyFinshObject *bfObject;

//- (void)setContent:(NSString *)content;
//- (void)setExpandBtnPositionWithContent:(NSString *)content;
//- (void)setSeparatorLinePositionWithContent:(NSString *)content;
//- (void)setShowDetail:(BOOL)showDetail;
//
//- (CGFloat)cellHeightForContent:(NSString *)content;

@end
