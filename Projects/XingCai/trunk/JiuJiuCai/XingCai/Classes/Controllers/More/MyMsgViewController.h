//
//  MyMsgViewController.h
//  XingCai
//
//  Created by Air.Zhao on 14-1-16.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MyMsgDetailViewController.h"
@interface MyMsgViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *msgListArr;
    
    int totalPage;
    int CurrentPage;
    int myMessPage;
     NSUInteger dataNumber;
     UILabel *loadMoreText;
    
    NSMutableArray *addArray;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    UILabel *myMessagelabel;
}

@property (weak, nonatomic) IBOutlet UITableView *tView;
- (IBAction)returnBtnClk:(UIButton *)sender;

@end
