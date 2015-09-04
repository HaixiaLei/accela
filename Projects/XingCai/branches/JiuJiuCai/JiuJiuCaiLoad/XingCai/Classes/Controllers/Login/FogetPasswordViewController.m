//
//  FogetPasswordViewController.m
//  XingCai
//
//  Created by jay on 13-12-25.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "FogetPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "NSUserDefaultsManager.h"
#import "BuyViewController.h"
#import "AccountViewController.h"
@interface FogetPasswordViewController ()

@end

@implementation FogetPasswordViewController

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
    // Do any additional setup after loading the view from its nib.
    
//    self.userNameTF.text = @"weststar";
//    self.passwordTF.text = @"123qwe";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)userInputCorrect
{
    BOOL isCorrect = YES;
    NSString *account = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    if (!account || account.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入用户名"];
    }
    else if (!password || password.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入资金密码"];
    }
    
    return isCorrect;
}

- (IBAction)resetPasswordAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    
    if (![self userInputCorrect]) {
        sender.userInteractionEnabled = YES;
        return;
    }
    
    NSString *account = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] loginWithAccount:account password:password Block:^(id JSON, NSError *error){
        
        if (!error) {
            
            NSString *type = [JSON objectForKey:@"type"];
            if (type && [type isEqualToString:@"change"]) {
                
                sender.userInteractionEnabled = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                //跳到重置密码页
                [Utility showErrorWithMessage:@"因为您以资金密码登录，所以您需要修改密码后重新登录！"];
                ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
                vc.account = account;
                vc.password = password;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (type && [type isEqualToString:@"play"])
            {
//                //本地存储sessionID
//                NSString *sessionId = [JSON objectForKey:@"sess"];
//                [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:USER_STORE_SESSIONID];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                //储存昵称
                [UserInfomation sharedInfomation].nickName = [JSON objectForKey:@"nickname"];
                //记住用户名
                if (![[NSUserDefaultsManager getUsername] isEqualToString:account]) {
                    [NSUserDefaultsManager setPassword:@""];
                }
                [NSUserDefaultsManager setUsername:account];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCleanBalance object:nil];
                
                [[AppCacheManager sharedManager] updateLotteryListWithBlock:^(NSError *error){
                    sender.userInteractionEnabled = YES;
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    //是否需要重新登录
                    [UserInfomation sharedInfomation].shouldLoginAgain = NO;
                    DDLogDebug(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
                    
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }];
            }
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%d,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            
            sender.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if ([error.domain isEqualToString:AppServerErrorDomain]) {
//                NSString *message = [JSON objectForKey:@"msg"];
//                switch (error.code) {
//                    case 404:
//                    {
//                        [Utility showErrorWithMessage:message];
//                        break;
//                    }
//                    case 405:
//                    {
//                        [Utility showErrorWithMessage:message];
//                        break;
//                    }
//                    case 406:
//                    {
//                        [Utility showErrorWithMessage:message];
//                        break;
//                    }
//                    case 407:
//                    {
//                        [Utility showErrorWithMessage:message];
//                        break;
//                    }
//                    case 408:
//                    {
//                        [Utility showErrorWithMessage:message];
//                        break;
//                    }
//                    case 409:
//                    {
//                        [Utility showErrorWithMessage:message];
//                        break;
//                    }
//                    default:
//                    {
//                        [Utility showErrorWithMessage:message];
//                        break;
//                    }
//                };
//            }
        }
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameTF) {
        [self.passwordTF becomeFirstResponder];
    }
    else if (textField == self.passwordTF)
    {
        [self.passwordTF resignFirstResponder];
    }
    return YES;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}
@end
