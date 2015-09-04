//
//  MMRightSideDrawerViewController.h
//  JiXiangCai
//
//  Created by jay on 14-9-18.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRightSideDrawerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *balanceLB;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

- (IBAction)btnBanlencePressed:(UIButton *)sender;

- (NSArray *)viewControllers;
- (void)showFirstVC;
@end
