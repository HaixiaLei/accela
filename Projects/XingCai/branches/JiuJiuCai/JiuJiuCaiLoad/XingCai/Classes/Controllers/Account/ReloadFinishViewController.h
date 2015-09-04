//
//  ReloadFinishViewController.h
//  JiuJiuCai
//
//  Created by hadis on 15-4-13.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReloadFinishViewController : UIViewController

@property (weak, nonatomic) NSString *bankTag;
@property (weak, nonatomic) NSString *flagStr;
@property (weak, nonatomic) NSString *bidStr;
@property (weak, nonatomic) NSString *bankID;
@property (weak, nonatomic) NSString *amountStr;



@property (weak, nonatomic) IBOutlet UIWebView *reloadWebview;
- (IBAction)returnBack:(id)sender;

@end
