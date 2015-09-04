//
//  ChangePasswordViewController.m
//  XingCai
//
//  Created by jay on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NSUserDefaultsManager.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
    self.title = @"修改密码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)userInputCorrect
{
    BOOL isCorrect = YES;
    NSString *password1 = self.password1TF.text;
    NSString *password2 = self.password2TF.text;
    NSString *password3 = self.password3TF.text;
    if (!password1 || password1.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入旧登录密码"];
    }
    else if (!password2 || password2.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入新登录密码"];
    }
    else if (!password3 || password3.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请再次输入新登录密码"];
    }
    else if(![password2 isEqualToString:password3])
    {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"两次输入的新登录密码不一致"];
    }
    else
    {
        //检查密码是否符合规则
        NSString *regex = @"^[a-zA-Z0-9]{6,16}+$";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if ([predicate evaluateWithObject:password2] != YES) {
            isCorrect = NO;
            [Utility showErrorWithMessage:@"新密码不符合规则"];
        }
        
        //判断是否是纯数字
        if (isCorrect) {
            NSString *regex = @"^[0-9]{6,16}+$";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:password2] == YES) {
                isCorrect = NO;
                [Utility showErrorWithMessage:@"新密码需至少包含一个字母"];
            }
        }
        
        //判断是否是纯字母
        if (isCorrect) {
            NSString *regex = @"^[a-zA-Z]{6,16}+$";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:password2] == YES) {
                isCorrect = NO;
                [Utility showErrorWithMessage:@"新密码需至少包含一个数字"];
            }
        }
    }
    return isCorrect;
}

- (IBAction)resetPasswordAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    
    if (![self userInputCorrect]) {
        sender.userInteractionEnabled = YES;
        return;
    }
    [self.view endEditing:YES];
    
    NSString *oldPassword = self.password1TF.text;
    NSString *newPassword = self.password2TF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[AFAppAPIClient sharedClient] changePassword_with_oldPassword:oldPassword newPassword:newPassword block:^(id JSON, NSError *error){
        sender.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            [Utility showErrorWithMessage:@"您的密码修改成功了!" delegate:self tag:1];
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,(long)error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            if ([JSON objectForKey:@"msg"] && [error.domain isEqualToString:AppServerErrorDomain]) {
                NSString *message = [JSON objectForKey:@"msg"];
                [Utility showErrorWithMessage:message delegate:self];
            }
            else if([error.domain isEqualToString:AppServerErrorDomain])
            {
                [Utility showErrorWithMessage:@"密码修改失败"];
            }
        }
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    self.password1bg.selected = NO;
    self.password2bg.selected = NO;
    self.password3bg.selected = NO;
    
    if (textField == self.password1TF) {
        self.password1bg.selected = YES;
    }
    else if (textField == self.password2TF)
    {
        self.password2bg.selected = YES;
    }
    else if (textField == self.password3TF)
    {
        self.password3bg.selected = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.password1bg.selected = NO;
    self.password2bg.selected = NO;
    self.password3bg.selected = NO;
    
    if (textField == self.password1TF) {
        [self.password2TF becomeFirstResponder];
    }
    else if (textField == self.password2TF)
    {
        [self.password3TF becomeFirstResponder];
    }
    else if (textField == self.password3TF)
    {
        [self.password3TF resignFirstResponder];
    }
    return YES;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.password1TF resignFirstResponder];
    [self.password2TF resignFirstResponder];
    [self.password3TF resignFirstResponder];
    
    self.password1bg.selected = NO;
    self.password2bg.selected = NO;
    self.password3bg.selected = NO;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        //清除密码
        [UserInfomation sharedInfomation].password = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameShowLoginVC object:nil];
    }
}
@end
