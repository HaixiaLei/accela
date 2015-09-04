//
//  AccelaUniversalDoneButton.m
//  TestNumberPadFinishButton
//
//  Created by Sywine on 8/21/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import "AccelaUniversalDoneButton.h"

@interface UIView (Additional)
- (UIView *)firstResponder;
@end

@implementation UIView (Additional)
- (UIView *)firstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView firstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}
@end

@implementation AccelaUniversalDoneButton{
    UIButton *finishButton;
}

+ (AccelaUniversalDoneButton *)sharedSetupToNumberPadInView:(UIView *)view {
    static AccelaUniversalDoneButton *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AccelaUniversalDoneButton alloc] init];
        _sharedClient.views = [[NSMutableArray alloc]init];
        [_sharedClient setUp];
    });
    [_sharedClient.views addObject:view];
    return _sharedClient;
}

-(void)setUp{
    self.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow1:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide1:) name:UIKeyboardWillHideNotification object:nil];
    CGRect vFrame = [UIScreen mainScreen].bounds;
    
    float x = 0;
    float w = vFrame.size.width/320*(320.0/3)-2;
    float h = (216.0/4)*(vFrame.size.width/320)-1;
    float y = h*3+vFrame.size.height;
    self.frame = CGRectMake(x, y, w, h);
    self.myFrame = self.frame;
    self.backgroundColor = [UIColor colorWithRed:0.761 green:0.784 blue:0.804 alpha:1.000];
    self.windowLevel = 1900;
    finishButton = [[UIButton alloc]initWithFrame:self.bounds];
    finishButton.backgroundColor = [UIColor clearColor];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateHighlighted];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [finishButton addTarget:self action:@selector(finishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:finishButton];
}

-(void)keyboardWillShow1:(NSNotification *)noti{
    if (![self isNumberPad]){
        if (CGRectEqualToRect(self.frame, self.myFrame)) return;
        [self setFrame:self.myFrame];
        return;
    }
    CGRect frame = self.myFrame;
    frame.origin.y -= frame.size.height * 4;
    if (CGRectEqualToRect(self.frame, frame)) return;
    //找到键盘动画
    NSDictionary* info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    UIViewAnimationOptions options = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:options
                     animations:^
     {
         [self setFrame:frame];
     }
                     completion:nil];
#ifdef DEBUG
    NSLog(@"self.frame=%@,,finishButton.frame=%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(finishButton.frame));
#endif
}

-(void)keyboardWillHide1:(NSNotification *)noti{
    if (CGRectEqualToRect(self.frame, self.myFrame)) return;
    NSDictionary* info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    UIViewAnimationOptions options = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:options
                     animations:^
     {
         [self setFrame:self.myFrame];
     }
                     completion:nil];
}

-(BOOL)isNumberPad{
    for (UIView *view in self.views) {
        UIView *view2 = [view firstResponder];
        if ([view2 isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)view2;
            if (tf.keyboardType == UIKeyboardTypeNumberPad) {
                return YES;
            }
        }
        if ([view2 isKindOfClass:[UITextView class]]) {
            UITextView *tf = (UITextView *)view2;
            if (tf.keyboardType == UIKeyboardTypeNumberPad) {
                return YES;
            }
        }
    }
    return NO;
}

-(void)finishBtnPressed{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
