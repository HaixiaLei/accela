//
//  ZHDetailCell.h
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHDetailObject;

@interface ZHDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImg;
@property (weak, nonatomic) IBOutlet UIImageView *itemBtn;
@property (weak, nonatomic) IBOutlet UILabel *issueLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *multipleLab;

@property (weak, nonatomic) IBOutlet UILabel *flagLab;

- (void)updateZHDetailObject:(ZHDetailObject *) zhDetailObj;

@end
