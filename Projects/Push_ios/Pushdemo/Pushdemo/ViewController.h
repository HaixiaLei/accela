//
//  ViewController.h
//  Pushdemo
//
//  Created by Luke on 15/3/24.
//  Copyright (c) 2015年 Luke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)getUserPushSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;

@property (weak, nonatomic) IBOutlet UILabel *laugchLabel;
@end

