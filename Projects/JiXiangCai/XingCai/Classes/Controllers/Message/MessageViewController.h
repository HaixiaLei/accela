//
//  MessageViewController.h
//  JiXiangCai
//
//  Created by jay on 14-11-7.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "DerivedViewController.h"

@interface MessageViewController : DerivedViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)refreshList;
@end
