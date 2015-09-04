//
//  LoginViewController.m
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "LoginViewController.h"
#import "FogetPasswordViewController.h"
#import "AFNetworking.h"
#import "MyMD5.h"
#import "AppCacheManager.h"
#import "NSUserDefaultsManager.h"
#import "BuyViewController.h"
#import "AccountViewController.h"
#import "ResetPasswordViewController.h"
#import "ServerAddressManager.h"


#define PasswordKey         @"PasswordKey"
#define RememberPasswordKey @"RememberPasswordKey"

@interface LoginViewController ()
{
    NSString *downloadURLString;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.userNameTF.delegate=self;
//    self.passwordTF.delegate=self;
    
    [UserInfomation sharedInfomation].loginVCVisible = YES;
    
    [self adjustView];
    self.userNameTF.text = [NSUserDefaultsManager getUsername];
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:RememberPasswordKey]);
    
// [[NSUserDefaults standardUserDefaults] boolForKey:RememberPasswordKey]为nil，表示钩不隐藏
    if ([[NSUserDefaults standardUserDefaults] boolForKey:RememberPasswordKey]) {
        self.tickIV.hidden=NO;
        self.passwordTF.text = [NSUserDefaultsManager getPassword];
    }

#ifdef OnLine
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersion) name:NotificationNameGetVersion object:nil];
    
    //本地保存正式服务器列表
    //    [[ServerAddressManager sharedManager] saveAddressListToFile];
    
    //获取服务器地址(目前会获取http://192.168.40.100/feed/作为接口地址，等运帷给出接口正式地址列表后，会获取一个最快的)
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    [[ServerAddressManager sharedManager] getAddressList];
#else
    //版本检查
    [self checkVersion];
#endif
    
    if (ScreenSize.height<568) {
        self.tab_logo.transform = CGAffineTransformMakeTranslation(0, 27);
    }
}

- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (!IS_IPHONE5) {
        if (SystemVersion >= 7.0) {
            CGPoint point = self.versonext.point;
            point.y -= 46;
            self.versonext.point = point;
        }else
        {
            CGPoint point = self.versonext.point;
            point.y -= 46;
            self.versonext.point = point;

        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    // Dispose of any resources that can be recreated.
}

- (void)checkVersion
{
//    [UserInfomation sharedInfomation].latestVersionGot = NO;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *currentBuild = [infoDic objectForKey:@"CFBundleVersion"];
    self.versonext.text = [NSString stringWithFormat:@"Ver.:%@(%@)",currentVersion,currentBuild];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] getVersionNumberWithBlock:^(id JSON, NSError *error){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
//            [UserInfomation sharedInfomation].latestVersionGot = YES;
            self.loginButton.enabled = YES;
            self.forgetPassword.enabled = YES;
            
            NSString* appStoreVersion = [JSON objectForKey:@"version"];
            if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)
            {
                downloadURLString = [[NSString alloc] initWithString:[JSON objectForKey:@"url"]];
                
                [Utility showErrorWithTittle:@"版本升级" message:[NSString stringWithFormat:@"发现新版本:%@\n当前版本:%@",appStoreVersion,currentVersion] delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上升级" tag:AlertViewTypeNewVersion duplicationPrevent:YES];
            }
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            
            if (error.domain == NSCocoaErrorDomain && error.code == 3840) {
                [Utility showErrorWithMessage:@"网络连接不可用，请检查网络设置" delegate:self tag:AlertViewTypeVersionError duplicationPrevent:NO];
            }
            else if ([JSON isKindOfClass:[NSDictionary class]] && [JSON objectForKey:@"msg"])
            {
                [Utility showErrorWithMessage:[JSON objectForKey:@"msg"] delegate:self tag:AlertViewTypeVersionError duplicationPrevent:NO];
            }
            else
            {
                [Utility showErrorWithMessage:error.localizedDescription delegate:self tag:AlertViewTypeVersionError duplicationPrevent:NO];
            }
        }
    }];
}
- (IBAction)fogetPasswordAction:(id)sender {
    FogetPasswordViewController *vc = [[FogetPasswordViewController alloc] initWithNibName:@"FogetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
        [Utility showErrorWithMessage:@"请输入密码"];
    }
    
    return isCorrect;
}

- (IBAction)loginAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;

    if (![self userInputCorrect]) {
        sender.userInteractionEnabled = YES;
        return;
    }

    NSString *account = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] loginWithAccount:account password:password Block:^(id JSON, NSError *error){
        sender.userInteractionEnabled = YES;
        
        if (!error) {
//            //本地存储sessionID
//            NSString *sessionId = [JSON objectForKey:@"sess"];
//            [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:USER_STORE_SESSIONID];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            //储存昵称
            [UserInfomation sharedInfomation].nickName = [JSON objectForKey:@"nickname"];
            //记住用户名
            [NSUserDefaultsManager setUsername:account];
            //记住密码
            if ([[NSUserDefaults standardUserDefaults] boolForKey:RememberPasswordKey]) {
                [NSUserDefaultsManager setPassword:password];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCleanBalance object:nil];
            
            NSString *type = [JSON objectForKey:@"type"];
            if (type && [type isEqualToString:@"change"]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Utility showErrorWithMessage:@"因为您以资金密码登录，所以您需要修改密码后重新登录！"];
                //跳到重置密码页
                ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
                vc.account = account;
                vc.password = password;
                [self.navigationController pushViewController:vc animated:YES];
                return ;
            }
            
            //更新彩种列表
            [[AppCacheManager sharedManager] updateLotteryListWithBlock:^(NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                //是否需要重新登陆标志
                [UserInfomation sharedInfomation].shouldLoginAgain = NO;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSucceeded object:nil];
                [self dismissViewControllerAnimated:YES completion:^(void){
                    [UserInfomation sharedInfomation].loginVCVisible = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUpdateLotteryList object:nil];
                }];
            }];
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_SESSIONID];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (error.code == 407) {
                [self cancelRememberPassword];
            }

        }
    }];

}

- (IBAction)rememberAction:(UIButton *)sender {
    self.tickIV.hidden=!self.tickIV.hidden;
    [[NSUserDefaults standardUserDefaults] setBool:!self.tickIV.hidden forKey:RememberPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.userNameTF) {
        self.userNameTFImage.image=[UIImage imageNamed:@"textField_bg_click1"];
    }
    if (textField==self.passwordTF) {
        self.passwordTFImage.image=[UIImage imageNamed:@"textField_bg_click2"];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField==self.userNameTF) {
        self.userNameTFImage.image=[UIImage imageNamed:@"textField_bg1"];
    }
    if (textField==self.passwordTF) {
        self.passwordTFImage.image=[UIImage imageNamed:@"textField_bg2"];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameTF) {
        [self.passwordTF becomeFirstResponder];
    
    }
    else if (textField == self.passwordTF)
    {
        [self.passwordTF resignFirstResponder];
        [self loginAction:nil];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //改变用户名自动清除密码，取消勾选记住密码
    if (textField == self.userNameTF) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self checkIfCancelRememberPassword:newText];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self checkIfCancelRememberPassword:@""];
    return YES;
}

- (void)checkIfCancelRememberPassword:(NSString *)newString
{
    if (![newString isEqualToString:[NSUserDefaultsManager getUsername]]) {
        [self cancelRememberPassword];
    }
}

- (void)cancelRememberPassword
{
//    self.rememberPassword.selected = NO;
    self.tickIV.hidden=YES;
    [[NSUserDefaults standardUserDefaults] setBool:!self.tickIV.hidden forKey:RememberPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.passwordTF.text = @"";
    [NSUserDefaultsManager setPassword:nil];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertViewTypeNewVersion)
    {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:downloadURLString]];
        
        //退出程序
        abort();
    }
    else if(alertView.tag == AlertViewTypeVersionError)
    {
        [self checkVersion];
    }
}
@end
