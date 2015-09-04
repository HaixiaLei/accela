//
//  LoginViewController.m
//  XingCai
//
//  Created by jay on 13-12-24.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "LoginViewController.h"
#import "FogetPasswordViewController.h"
#import "AppCacheManager.h"
#import "BuyViewController.h"
#import "AccountViewController.h"
#import "ResetPasswordViewController.h"
#import "ServerAddressManager.h"
#import "AppDelegate.h"
#import "GestureViewController.h"
#import "MethodVersionObject.h"
#import "SelectedNumber.h"
@interface LoginViewController ()
{
    NSString *downloadURLString;
    GestureViewController *gestureViewController;
    
    id methodversion; //玩法版本号
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endEditing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [UserInfomation sharedInfomation].loginVCVisible = YES;
    if ([SelectedNumber getInstance].infoArray.count>0) {
        [[SelectedNumber getInstance].infoArray removeAllObjects];
    }


#ifdef OnLine
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersion) name:NotificationNameGetVersion object:nil];
    
    //获取一个最快的服务器地址
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ServerAddressManager sharedManager].loginVC = self;
    [[ServerAddressManager sharedManager] getBestServer];
#else
    //版本检查
    [self checkVersion];
#endif
    
    //如果没有设置手势密码，只显示登录按钮
    if ([UserInfomation sharedInfomation].account && [UserInfomation sharedInfomation].password && [UserInfomation sharedInfomation].gesturePassword) {
        [self showGestrueViewWithType:GestureTypeLogin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    // Dispose of any resources that can be recreated.
}

- (void)checkVersion
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppAPIClient sharedClient] version_with_block:^(id JSON, NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.loginButton.userInteractionEnabled = YES;
        self.forgetPassword.userInteractionEnabled = YES;
        if (!error) {
            NSString *latestVersion = [[JSON objectForKey:@"results"] objectForKey:@"version"];
            NSString *currentVersion = [UserInfomation sharedInfomation].appVersion;
            if ([latestVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)
            {
                downloadURLString = [[NSString alloc] initWithString:[[JSON objectForKey:@"results"] objectForKey:@"downurl"]];
                
                [Utility showErrorWithTittle:@"版本升级" message:[NSString stringWithFormat:@"发现新版本:V%@\n当前版本:V%@",latestVersion,currentVersion] delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上升级" tag:AlertViewTypeNewVersion duplicationPrevent:YES];
            }
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            
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
    [self endEditing];
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

- (IBAction)loginAction:(UIButton *)sender
{    
    sender.userInteractionEnabled = NO;

    if (![self userInputCorrect]) {
        sender.userInteractionEnabled = YES;
        return;
    }

    NSString *account = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppAPIClient sharedClient] login_with_account:account password:password logintype:@"login" block:^(id JSON, NSError *error){
        sender.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            //储存昵称
            [UserInfomation sharedInfomation].nickName = [JSON objectForKey:@"nickname"];
            //记住用户名
            [UserInfomation sharedInfomation].account = account;
            //记住密码
            [UserInfomation sharedInfomation].password = password;
            //玩法版本号
            methodversion = [JSON objectForKey:@"methodversion"];
            
            //如果未设置手势密码，则显示设置手势密码页面
            if (![UserInfomation sharedInfomation].gesturePassword) {
                [self showGestrueViewWithType:GestureTypeSet];
            }
            else
            {
                [self loginSuccess];
            }
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            //用户名密或密码错误
            if (error.code == -407) {
                self.passwordTF.text = @"";
                [UserInfomation sharedInfomation].password = nil;
            }
            if ([error.domain isEqualToString:@"AppServerErrorDomain"] && error.code == -407 && self.isGestureLogin) {
                [gestureViewController.view removeFromSuperview];
                [gestureViewController removeFromParentViewController];
                self.inputAreaView.hidden = NO;
            }
        }
    }];
}

- (IBAction)gestureButtonAction:(id)sender {
    [self showGestrueViewWithType:GestureTypeLogin];
}


//登录成功逻辑
- (void)loginSuccess
{
    //余额归零
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCleanBalance object:nil];
    
    //提取版本数据
    NSMutableArray *versionList = [NSMutableArray array];
    if (methodversion && [methodversion isKindOfClass:[NSArray class]]) {
        NSArray *arryFromJSON = (NSArray *)methodversion;
        for (int i = 0; i < arryFromJSON.count; ++i) {
            id oneObject = [arryFromJSON objectAtIndex:i];
            if ([oneObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *oneObjectDictionary = (NSDictionary *)oneObject;
                MethodVersionObject *methodVersionObject = [[MethodVersionObject alloc]initWithDictionary:oneObjectDictionary];
                [versionList addObject:methodVersionObject];
            }
        }
    }
    
    //更新玩法，不管成功还是失败，都进入彩种选择页
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppCacheManager sharedManager] updatePlayRulesWithVersionList:versionList completionBlock:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //是否需要重新登陆
        [UserInfomation sharedInfomation].shouldLoginAgain = NO;
        [(AppDelegate *)[UIApplication sharedApplication].delegate showHomePage];
        
        [UserInfomation sharedInfomation].loginVCVisible = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateAllJiangQi object:nil];
    }];
}

- (void)showGestrueViewWithType:(GestureType)type
{
    [self endEditing];
    
    if (!gestureViewController) {
        gestureViewController = [[GestureViewController alloc] initWithNibName:@"GestureViewController" bundle:nil];
        gestureViewController.view.frame = IS_IPHONE4 ? CGRectMake(0, 188, 320, 288) : CGRectMake(0, 240, 320, 330);
    }
    [gestureViewController setType:type];
    
    [self.containerView addSubview:gestureViewController.view];
    [self addChildViewController:gestureViewController];
    
    self.inputAreaView.hidden = YES;
}

/**
 *  结束编辑，回到初始状态
 */
- (void)endEditing
{
    [self.view endEditing:YES];
    self.userNameBg.selected = NO;
    self.passwordBg.selected = NO;
    
    [Utility moveViewToPoint:CGPointMake(0, 0) view:self.containerView duration:0.2f curve:UIViewAnimationCurveEaseInOut];
}

/**
 *  调整输入框位置，使不被键盘挡住
 */
- (void)ajustInputView
{
    CGPoint targetPoint = IS_IPHONE4 ? CGPointMake(0, -190) : CGPointMake(0, -190);
    [Utility moveViewToPoint:targetPoint view:self.containerView duration:0.2f curve:UIViewAnimationCurveEaseInOut];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.userNameTF) {
        self.userNameBg.selected = YES;
        self.passwordBg.selected = NO;
        [self ajustInputView];
    }
    else if (textField == self.passwordTF)
    {
        self.userNameBg.selected = NO;
        self.passwordBg.selected = YES;
        [self ajustInputView];
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
        [self endEditing];
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
//    if (![newString isEqualToString:[NSUserDefaultsManager getUsername]]) {
//        [self cancelRememberPassword];
//    }
}

- (void)cancelRememberPassword
{
    self.passwordTF.text = @"123qwe";
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing];
}

- (void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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

- (void)loginByGesture
{
    self.userNameTF.text = [UserInfomation sharedInfomation].account;
    self.passwordTF.text = [UserInfomation sharedInfomation].password;
    [self loginAction:self.loginButton];
}

@end
