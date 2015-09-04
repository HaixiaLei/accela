//
//  InfoOfPlayMethodViewController.h
//  XingCai
//
//  Created by Bevis on 14-2-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InfoType)
{
    InfoTypePlayMethod,
    InfoTypeHowToSaving,
    InfoTypeAnswer,
};

@interface InfoOfPlayMethodViewController : DerivedViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) InfoType infoType;
@property (strong, nonatomic) NSString *tagName;
- (IBAction)bankToBuyChooseView:(id)sender;

@end
