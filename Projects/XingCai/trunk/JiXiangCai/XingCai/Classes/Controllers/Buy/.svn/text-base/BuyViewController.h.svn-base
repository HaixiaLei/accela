//
//  BuyViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol buyViewControllerDelegate <NSObject>

-(void)jumpToNextVC;

@end
@interface BuyViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *bgImgView; 
@property (weak, nonatomic) IBOutlet UIView *eventButton;
@property (weak, nonatomic) IBOutlet UIView *betButtonLayer;
@property (nonatomic, strong) KindOfLottery *kindOfLottery;
@property (nonatomic, weak) id<buyViewControllerDelegate> delegate;
- (void)showEventButton;

@end
