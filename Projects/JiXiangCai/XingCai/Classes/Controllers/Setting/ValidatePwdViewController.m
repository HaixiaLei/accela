//
//  ValidatePwdViewController.m
//  JiXiangCai
//
//  Created by jay on 14-10-27.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ValidatePwdViewController.h"
#import "ResetGestureViewController.h"

@interface ValidatePwdViewController ()

@end

@implementation ValidatePwdViewController

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
    self.title = @"修改手势密码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetGesture
{
    ResetGestureViewController *resetGestureViewController = [[ResetGestureViewController alloc] initWithNibName:IS_IPHONE4 ? @"ResetGestureViewController_3p5" : @"ResetGestureViewController" bundle:nil];
    resetGestureViewController.parentVC = self;
    [self presentViewController:resetGestureViewController animated:YES completion:nil];
}

- (BOOL)userInputCorrect
{
    BOOL isCorrect = YES;
    
    NSString *password = self.passwordTF.text;
    if (!password || password.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入您的登录密码！"];
    }
    
    return isCorrect;
}

- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.userInteractionEnabled = NO;
    
    if (![self userInputCorrect]) {
        sender.userInteractionEnabled = YES;
        return;
    }
    
    NSString *account = [UserInfomation sharedInfomation].account;
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
            
            [self resetGesture];
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
        }
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.passwordTF)
    {
        self.passwordBg.selected = YES;
        self.passwordBgImgView.highlighted = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.passwordBg.selected = NO;
    self.passwordBgImgView.highlighted = NO;
    
    if (textField == self.passwordTF)
    {
        [self.passwordTF resignFirstResponder];
    }
    return YES;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.passwordBg.selected = NO;
    self.passwordBgImgView.highlighted = NO;
}

@end
