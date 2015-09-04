//
//  AnnouncementViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface AnnouncementViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableViewCell *headCell;
//    IBOutlet UITableView *tView;
    NSMutableArray *noticeListArr;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;

}
@property (weak, nonatomic) IBOutlet UITableView *tView;

@property (strong, nonatomic) IBOutlet UITableViewCell *headCell;

- (IBAction)returnBtnClk:(UIButton *)sender;
@end
