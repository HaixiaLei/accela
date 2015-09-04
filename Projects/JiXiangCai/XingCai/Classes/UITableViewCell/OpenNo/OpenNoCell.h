//
//  OpenNoCell.h
//  HengCai
//
//  Created by jay on 14-8-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpenNoObject;

@interface OpenNoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *issueLab;
@property (weak, nonatomic) IBOutlet UIImageView *japanOrCq;
@property (weak, nonatomic) IBOutlet UILabel *statuscodeLab;

@property (weak, nonatomic) IBOutlet UIImageView *noImgOne;
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UIImageView *noImgTwo;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UIImageView *noImgThree;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UIImageView *noImgFour;
@property (weak, nonatomic) IBOutlet UILabel *fourLab;
@property (weak, nonatomic) IBOutlet UIImageView *noImgFive;
@property (weak, nonatomic) IBOutlet UILabel *fiveLab;

- (void)updateOpenNoObject:(OpenNoObject *) openNoObj;
@end
