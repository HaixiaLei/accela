//
//  AnnouncementDetailViewController.h
//  JiXiangCai
//
//  Created by jay on 14-11-19.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"

@interface AnnouncementDetailViewController : DerivedViewController

@property (strong, nonatomic) NSString *urlString;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
