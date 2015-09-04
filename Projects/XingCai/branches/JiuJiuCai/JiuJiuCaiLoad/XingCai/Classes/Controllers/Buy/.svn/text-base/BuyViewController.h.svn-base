//
//  BuyViewController.h
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiangQiManager.h"
#import "CycleScrollView.h"
#import "MJRefresh.h"
//#import "SDWebImageDownloaderDelegate.h"
#define NotificationNameUpdateLotteryList @"NotificationNameUpdateLotteryList"
//#define NotificationNameUpdateLotteryList @"NotificationNameUpdateAddNumber"
@interface BuyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,UITextFieldDelegate>
{
    //奖期倒数计时计时器
    NSTimer *countdownTimer;
    //当前奖期开始时间
    NSDate *currentDate;
    //当前奖期结束时间
    NSDate *endDate;
    //彩种信息
    NSArray *kindOfLotteries;
    //开奖信息
    NSMutableArray *openLotteries;
    UIScrollView *bannerScrollView;
    __weak IBOutlet UIImageView *myPhoto;
    __weak IBOutlet UILabel *UserName;
    __weak IBOutlet UILabel *myMoney;
    
    UIWebView *adWebVeiwe;
    UIView *eventView;
//    UILabel * daoJiShiLabel;
//    UILabel * jiangQiLabel;
    UIImage *addImg;
    NSArray *array_id;
    NSMutableArray *array_img;
//    NSMutableArray *imgviewArr;
    NSMutableArray *imgUrlArray;
    
     MJRefreshHeaderView *_header;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *naviBarView;
@property (weak, nonatomic)  UIImageView *photoBack;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImg;

@property (strong, nonatomic) UIImageView *photoImgView;
@property (strong, nonatomic) UITableViewCell *bannerCell;
@property (nonatomic , strong) CycleScrollView *mainScorllView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *guangaoview;
@property (weak, nonatomic) IBOutlet UIView *buyBGView;
@property (weak, nonatomic) IBOutlet UIView *checkButtonBg;
@property (weak, nonatomic) IBOutlet UITextField *tixianPin;
@property (weak, nonatomic) IBOutlet UIView *tianxianView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *tixianBGView;
@property (weak, nonatomic) IBOutlet UIButton *kaijiangBtn;
@property (weak, nonatomic) IBOutlet UIButton *tixianBtn;
@property (weak, nonatomic) IBOutlet UIButton *grzxBtn;

@property (assign, nonatomic) NSInteger addnum;
- (IBAction)gotoGeRenZhongXin:(id)sender;
- (IBAction)gotoKaijiangInfo:(id)sender;
- (IBAction)gotoQuxian:(id)sender;

- (IBAction)gotoAnnouncementViewcontroller:(id)sender;
- (IBAction)gotoATMviewController:(id)sender;
- (IBAction)gotoBetSearchViewController:(id)sender;
- (IBAction)gotoZhuiHaoViewController:(id)sender;
- (IBAction)confirmToTixian:(id)sender;
- (IBAction)cancleForTixian:(id)sender;
-(IBAction)bindBankCardVC:(id)sender;

//-(void)loadWebPageWithString:(NSString*)urlString;

@end
