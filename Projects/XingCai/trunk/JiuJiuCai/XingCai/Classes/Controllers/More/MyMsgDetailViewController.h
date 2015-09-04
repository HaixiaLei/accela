//
//  MyMsgDetailViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-17.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMsgDetailViewController : UIViewController
{
    NSMutableArray *msgDetailArr;
}

@property (weak, nonatomic) IBOutlet UILabel *subjectLab;
@property (weak, nonatomic) IBOutlet UIWebView *webV;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLab;
@property(nonatomic,strong) NSString *entryStr;
@property(nonatomic,retain) NSString* fromPush;

- (IBAction)returnBtnClk:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopViewHeight;
@end
