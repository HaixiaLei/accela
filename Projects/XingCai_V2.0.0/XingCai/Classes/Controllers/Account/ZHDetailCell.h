//
//  ZHDetailCell.h
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhuiHaoItemObject;

@interface ZHDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *issueLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

- (void)updateZHDetailObject:(ZhuiHaoItemObject *) zhDetailObj;

@end
