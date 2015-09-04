//
//  ResetPasswordViewController.m
//  XingCai
//
//  Created by jay on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "LoginViewController.h"
#import "NSUserDefaultsManager.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

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
    self.title = @"设置新密码";
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
    if (!password1 || password1.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入密码"];
    }
    else if (!password2 || password2.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请再次输入密码"];
    }
    else if(![password1 isEqualToString:password2])
    {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"两次输入的密码不一致"];
    }
    else
    {
        //检查密码是否符合规则
        NSString *regex = @"^[a-zA-Z0-9]{6,16}+$";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if ([predicate evaluateWithObject:password1] != YES) {
            isCorrect = NO;
            [Utility showErrorWithMessage:@"密码不符合规则"];
        }
        
        //判断是否是纯数字
        if (isCorrect) {
            NSString *regex = @"^[0-9]{6,16}+$";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:password1] == YES) {
                isCorrect = NO;
                [Utility showErrorWithMessage:@"密码需至少包含一个字母"];
            }
        }
        
        //判断是否是纯字母
        if (isCorrect) {
            NSString *regex = @"^[a-zA-Z]{6,16}+$";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:password1] == YES) {
                isCorrect = NO;
                [Utility showErrorWithMessage:@"密码需至少包含一个数字"];
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
    
    NSString *password2 = self.password2TF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppAPIClient sharedClient] findPassword_with_newPassword:password2 block:^(id JSON, NSError *error){
        sender.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            [Utility showErrorWithMessage:@"您的密码重置成功了!" delegate:self tag:1];
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
                [Utility showErrorWithMessage:@"密码重置失败"];
            }
        }
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.password1TF) {
        self.password1bg.selected = YES;
        self.password2bg.selected = NO;
    }
    else if (textField == self.password2TF)
    {
        self.password1bg.selected = NO;
        self.password2bg.selected = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.password1bg.selected = NO;
    self.password2bg.selected = NO;
    
    if (textField == self.password1TF) {
        [self.password2TF becomeFirstResponder];
    }
    else if (textField == self.password2TF)
    {
        [self.password2TF resignFirstResponder];
    }
    return YES;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.password1TF resignFirstResponder];
    [self.password2TF resignFirstResponder];

    self.password1bg.selected = NO;
    self.password2bg.selected = NO;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
