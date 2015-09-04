//
//  RecordsViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tView;
    //NSMutableArray *openLotteries;
    NSMutableArray *openLotteriesDetails;
    UITableViewCell *headCell;
}
- (IBAction)gotoChangeKindOfLottery:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chongqingBtn;
@property (weak, nonatomic) IBOutlet UIButton *quick5Btn;

- (IBAction)gotoBuyController:(id)sender;
@property (strong, nonatomic) IBOutlet UITableViewCell *headCell;
//@property (strong, nonatomic) NSString *issueNumber;
@end
