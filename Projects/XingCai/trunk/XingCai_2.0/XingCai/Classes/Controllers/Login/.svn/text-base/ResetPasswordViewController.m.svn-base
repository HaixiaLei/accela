//
//  ResetPasswordViewController.m
//  XingCai
//
//  Created by jay on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetSuccessViewController.h"
#import "ResetFailViewController.h"
#import "UIViewController+CustomNavigationBar.h"
#import "LoginViewController.h"
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
-(void)viewWillAppear:(BOOL)animated
{
[self.password1TF becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNavigationBarTitle:@"找回登录密码" tintColor:GUI_COLOR_NAVIGATION_BAR_TEXT navigationBarHidden:NO navigationBarTranslucent:NO withBackButtonItem:BackActionPop];
    
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
    [self.password1TF resignFirstResponder];
    [self.password2TF resignFirstResponder];
    sender.userInteractionEnabled = NO;
    
    if (![self userInputCorrect]) {
        sender.userInteractionEnabled = YES;
        return;
    }
    
    NSString *password2 = self.password2TF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppHttpManager sharedManager] changePasswordWithAccount:self.account password:self.password newPassword:password2 Block:^(id JSON, NSError *error){
        sender.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            makeSureAlertView=[Utility showErrorWithMessage:@"密码修改成功，返回登录界面" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定" tag:AlertViewTypeChaseConfirm duplicationPrevent:YES];
          
        }
        else
        {
            DDLogError(@"error:%@,domain:%@,code:%ld,method:%@,class:%@",error.description,error.domain,error.code,NSStringFromSelector(_cmd),NSStringFromClass([self class]));
            
            if ([JSON objectForKey:@"msg"]) {
                NSString *message = [JSON objectForKey:@"msg"];
                makeSureAlertView=[Utility showErrorWithMessage:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" tag:AlertViewTypeChaseConfirm duplicationPrevent:YES];
 
            }

        }
    }];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
}

-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertViewTypeSuccess) {
      
    }
    else if( alertView.tag == AlertViewTypeChaseConfirm)
    {
        switch (buttonIndex) {
            case 1:
                 [self jumptoLoginVC];
                break;
            default:
                break;
        }
    }
    
}
-(void)jumptoLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];

}
//-(void)jumptoForgetVC
//{
//    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self.navigationController pushViewController:loginVC animated:YES];
//    
//}

@end
