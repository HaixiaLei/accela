//
//  GestureViewController.m
//  JiXiangCai
//
//  Created by jay on 14-10-22.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "GestureViewController.h"
#import "LoginViewController.h"
#import "ResetGestureViewController.h"

@interface GestureViewController ()
{
    NSString *passcodeFirst;
    int chanceLeft; //剩余次数
}

@property (assign, nonatomic) GestureType type;
@end

@implementation GestureViewController

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
    
    self.lockView.frame = CGRectMake(38, 0, 244, 230);
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 12;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeAction:(id)sender {
    [self showLogin];
}
#pragma mark - KKGestureLockViewDelegate
- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{
    DDLogInfo(@"didBeginWithPasscode:%@",passcode);
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
    DDLogInfo(@"didEndWithPasscode:%@",passcode);
    
    switch (_type) {
        case GestureTypeLogin:
        {
            NSString *gesturePassword = [UserInfomation sharedInfomation].gesturePassword;
            if ([gesturePassword isEqualToString:passcode]) {
                [self loginByGesture];
            }
            else
            {
                --chanceLeft;
                if (chanceLeft > 0)
                {
                    self.changeBtn.hidden = NO;
                    self.promptLB.hidden = NO;
                    self.promptLB.text = [NSString stringWithFormat:@"手势密码错误，还剩%d次",chanceLeft];
                    if(IS_IPHONE4)
                    {
                        self.promptLB.alpha = 1.f;
                        self.changeBtn.alpha = 0.f;
                        self.changeBtn.userInteractionEnabled = NO;
                        
                        [UIView animateWithDuration:0.5f delay:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.promptLB.alpha = 0;
                            self.changeBtn.alpha = 1.f;
                        } completion:^(BOOL finished){
                            self.changeBtn.userInteractionEnabled = YES;
                        }];
                    }
                }
                else
                {
                    self.promptLB.alpha = 1.f;
                    self.changeBtn.alpha = 0.f;
                    self.promptLB.text = @"输入错误超过5次，请使用账号登录";
                    self.lockView.userInteractionEnabled = NO;
                    [UserInfomation sharedInfomation].gesturePassword = nil;
                    [self performSelector:@selector(showLogin) withObject:nil afterDelay:1.0f];
                }
            }
            break;
        }
        case GestureTypeSet:
        case GestureTypeReset:
        {
            NSArray *codes = [passcode componentsSeparatedByString:@","];
            if (codes.count < 4 && !passcodeFirst) {
                self.promptLB.text = @"手势密码至少4位，请重新输入";
            }
            else
            {
                self.promptLB.text = @"";
                
                if (!passcodeFirst)
                {
                    passcodeFirst = passcode;
                    self.promptLB.text = @"请再次确认您的手势密码";
                }
                else
                {
                    if ([passcodeFirst isEqualToString:passcode]) {
                        [UserInfomation sharedInfomation].gesturePassword = passcode;
                        
                        if (_type == GestureTypeSet) {
                            [self loginSuccess];
                        }
                        else if (_type == GestureTypeReset)
                        {
                            [self resetGestureFinish];
                        }
                    }
                    else
                    {
                        self.promptLB.text = @"两次输入不一致，请重新设置";
                        passcodeFirst = nil;
                    }
                }
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)setType:(GestureType)type
{
    _type = type;
    switch (type) {
        case GestureTypeLogin:
        {
            if (!IS_IPHONE4) {
                self.promptLB.frame = CGRectMake(15, 230, 290, 43);
                self.changeBtn.frame = CGRectMake(15, 270, 290, 43);
            }
            self.changeBtn.hidden = NO;
            self.promptLB.hidden = YES;
            chanceLeft = 5;
            break;
        }
        case GestureTypeSet:
        case GestureTypeReset:
        {
            self.changeBtn.hidden = YES;
            self.promptLB.hidden = NO;
            self.promptLB.text = @"请设置您的手势密码";
            break;
        }
        default:
            break;
    }
}

- (void)showLogin
{
    self.lockView.userInteractionEnabled = YES;
    id parentVC = self.parentViewController;
    if ([parentVC isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginViewController = (LoginViewController *)parentVC;
        loginViewController.inputAreaView.hidden = NO;
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)loginByGesture
{
    id parentVC = self.parentViewController;
    if ([parentVC isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginViewController = (LoginViewController *)parentVC;
        loginViewController.isGestureLogin = YES;
        [loginViewController loginByGesture];
    }
}

- (void)loginSuccess
{
    id parentVC = self.parentViewController;
    if ([parentVC isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginViewController = (LoginViewController *)parentVC;
        [loginViewController loginSuccess];
    }
}

- (void)resetGestureFinish
{
    id parentVC = self.parentViewController;
    if ([parentVC isKindOfClass:[ResetGestureViewController class]]) {
        ResetGestureViewController *resetGestureViewController = (ResetGestureViewController *)parentVC;
        [resetGestureViewController resetGestureFinish];
    }
}
@end
