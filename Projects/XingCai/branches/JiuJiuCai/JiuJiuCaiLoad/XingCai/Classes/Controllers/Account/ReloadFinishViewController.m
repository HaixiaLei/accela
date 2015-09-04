//
//  ReloadFinishViewController.m
//  JiuJiuCai
//
//  Created by hadis on 15-4-13.
//  Copyright (c) 2015年 weststar. All rights reserved.
//

#import "ReloadFinishViewController.h"

@interface ReloadFinishViewController ()

@end

@implementation ReloadFinishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppHttpManager sharedManager] loadConfirmWithBankCode:self.bankTag bankId:self.bidStr bankIdInBankInfo:self.bankID amount:self.amountStr block:^(id JSON, NSError *error) {
        if (!error) {
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                [self.reloadWebview loadHTMLString:[JSON objectForKey:@"content"] baseURL:nil];
   
                
            }}
        
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
