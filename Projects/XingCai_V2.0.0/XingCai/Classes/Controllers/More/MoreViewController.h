//
//  MoreViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController<UIAlertViewDelegate>
{
   
}

@property (weak, nonatomic) IBOutlet UIButton *btnMyMessage;
@property (weak, nonatomic) IBOutlet UIImageView *msgIV;
@property (weak, nonatomic) IBOutlet UIImageView *noticeIV;
@property (weak, nonatomic) IBOutlet UIImageView *playIV;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bgscrollview;
@property (weak, nonatomic) IBOutlet UILabel *unReadInfo;

- (IBAction)myMsgTouchDown:(id)sender;
- (IBAction)myMsgTouchExit:(id)sender;
- (IBAction)myMsgAction:(id)sender;

- (IBAction)announcementTouchDown:(id)sender;
- (IBAction)announcementTouchExit:(id)sender;
- (IBAction)announcementAction:(id)sender;

- (IBAction)feedbackAction:(id)sender;

- (IBAction)playTouchDown:(id)sender;
- (IBAction)playTouchExit:(id)sender;
- (IBAction)play:(id)sender;

- (IBAction)answer:(id)sender;
- (IBAction)logout:(id)sender;

- (IBAction)test:(id)sender;
@end
