//
//  BuyFinishViewController.h
//  XingCai
//
//  Created by Bevis on 14-1-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModeObject;
@class LotteryInformation;
@class BuyChooseViewController;
@interface BuyFinishViewController : UIViewController<UIAlertViewDelegate>
{

}
@property (weak, nonatomic) BuyChooseViewController *buyChooseViewController;

//@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *betNumber;        //投注注数
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *betMoney;         //投注金额
@property (weak, nonatomic) IBOutlet UIView *chooseContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITextField *chaseTimesTF;
@property (weak, nonatomic) IBOutlet UITextField *timesTF;
@property (weak, nonatomic) IBOutlet UIButton *beginChaseSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *stopWhenWinSelectButton;
@property (weak, nonatomic) IBOutlet UIView *chaseView;
@property (weak, nonatomic) IBOutlet UILabel *timesLB;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)gotoRandomLottery:(id)sender;

//下注需要的参数
//@property (nonatomic, strong)NSString *currentJiangQi;                  //当前奖期
@property (nonatomic, strong)NSString *lotteryid;                       //彩种id
@property (nonatomic, assign)NSInteger timeOfChase;                           //追号期数
@property (nonatomic, assign)long long times;                                 //倍数
//@property (nonatomic, strong)NSArray *keZhuiHaoJiangQis;         //可追号奖期
@property (nonatomic, strong)NSString *titleLabelText;

- (void)addLotteryInformation:(LotteryInformation *)lotteryInformation; //增加投注信息

- (IBAction)addMoreNumber:(id)sender;
- (IBAction)returnBtnClk:(id)sender;        //返回按钮事件
- (IBAction)confirmBet:(id)sender;          //确定按钮事件
- (IBAction)removeAllNumbers:(id)sender;

- (IBAction)beginChaseClk:(id)sender;
- (IBAction)stopWhenWinClk:(id)sender;

//手选判断是否有相同的号码
- (BOOL)betNumberExist:(NSString *)betNumber title:(NSString *)title name:(NSString *)name;
//机选计算某种类型已选号码个数
- (NSInteger)totalBetNumberWithTitle:(NSString *)title name:(NSString *)name;

@end
