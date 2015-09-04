//
//  ChangePasswordViewController.m
//  XingCai
//
//  Created by jay on 14-1-26.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginViewController.h"
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
    [self adjustView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustView
{
    //如果不是iphone5，整体上移
    if (SystemVersion < 7.0) {
        self.containerView.point = CGPointZero;
    }
    
    CGRect frame = self.containerView.frame;
    frame.size.height = IS_IPHONE5 ? 548 : 480;
    self.containerView.frame = frame;
}

- (BOOL)userInputCorrect
{
    BOOL isCorrect = YES;
    NSString *password1 = self.password1TF.text;
    NSString *password2 = self.password2TF.text;
    NSString *oldPassword = self.password3TF.text;
    if (!oldPassword || oldPassword.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入旧登录密码"];
    }
    else if (!password1 || password1.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请输入新登录密码"];
    }
    else if (!password2 || password2.length == 0) {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"请再次输入新登录密码"];
    }
    else if(![password1 isEqualToString:password2])
    {
        isCorrect = NO;
        [Utility showErrorWithMessage:@"两次输入的新登录密码不一致"];
    }
    else
    {
        //检查密码是否符合规则
        NSString *regex = @"^[a-zA-Z0-9]{6,16}+$";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if ([predicate evaluateWithObject:password1] != YES) {
            isCorrect = NO;
            [Utility showErrorWithMessage:@"新登录密码不符合规则"];
        }
        
        //判断是否是纯数字
        if (isCorrect) {
            NSString *regex = @"^[0-9]{6,16}+$";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:password1] == YES) {
                isCorrect = NO;
                [Utility showErrorWithMessage:@"新登录密码需至少包含一个字母"];
            }
        }
        
        //判断是否是纯字母
        if (isCorrect) {
            NSString *regex = @"^[a-zA-Z]{6,16}+$";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:password1] == YES) {
                isCorrect = NO;
                [Utility showErrorWithMessage:@"新登录密码需至少包含一个数字"];
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
    
    NSString *oldPassword = self.password3TF.text;
    NSString *newPassword = self.password2TF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *account = [NSUserDefaultsManager getUsername];

    [[AppHttpManager sharedManager] changePasswordWithAccount:account password:oldPassword newPassword:newPassword type:ChangePasswordTypeLogin Block:^(id JSON, NSError *error){
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
        self.password1bg.highlighted = YES;
        self.password2bg.highlighted = NO;
        self.password3bg.highlighted = NO;
        [self focuseTF1];
    }
    else if (textField == self.password2TF)
    {
        self.password1bg.highlighted = NO;
        self.password2bg.highlighted = YES;
        self.password3bg.highlighted = NO;
        [self focuseTF2];
    }
    else if (textField == self.password3TF)
    {
        self.password1bg.highlighted = NO;
        self.password2bg.highlighted = NO;
        self.password3bg.highlighted = YES;
        [self focuseTF3];
    }
    return YES;
}

- (void)focuseTF1
{
    [Utility moveViewToPoint:CGPointMake(0, -75) view:self.contentView duration:0.2f curve:UIViewAnimationCurveEaseInOut];
}

- (void)focuseTF2
{
    [Utility moveViewToPoint:CGPointMake(0, -150) view:self.contentView duration:0.2f curve:UIViewAnimationCurveEaseInOut];
}

- (void)focuseTF3
{
    [Utility moveViewToPoint:CGPointMake(0, 0) view:self.contentView duration:0.2f curve:UIViewAnimationCurveEaseInOut];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.password1bg.highlighted = NO;
    self.password2bg.highlighted = NO;
    self.password3bg.highlighted = NO;
    
    if (textField == self.password1TF) {
        [self.password2TF becomeFirstResponder];
    }
    else if (textField == self.password2TF)
    {
        [self.password2TF resignFirstResponder];
         [self focuseTF3];
    }
    else if (textField == self.password3TF)
    {
        [self.password1TF becomeFirstResponder];
    }
    return YES;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.password1TF resignFirstResponder];
    [self.password2TF resignFirstResponder];
    [self.password3TF resignFirstResponder];
    
    self.password1bg.highlighted = NO;
    self.password2bg.highlighted = NO;
    self.password3bg.highlighted = NO;
    
    [self focuseTF3];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(AppAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [UserInfomation sharedInfomation].shouldLoginAgain = YES;
        DLog(@"shouldLoginAgain:%@,class:%@,method:%@",[UserInfomation sharedInfomation].shouldLoginAgain?@"YES":@"NO",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLogout object:nil];
    }
}
@end
