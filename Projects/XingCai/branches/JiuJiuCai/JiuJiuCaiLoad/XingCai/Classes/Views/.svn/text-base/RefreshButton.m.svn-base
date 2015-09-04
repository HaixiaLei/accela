//
//  RefreshButton.m
//  JiuJiuCai
//
//  Created by jay on 14-7-9.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "RefreshButton.h"

@implementation RefreshButton
{
    BOOL isRunning;
    NSTimeInterval startTime;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)begin
{
    if (!isRunning) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRotation) object:nil];
        isRunning = YES;
        self.userInteractionEnabled = NO;
        startTime = [[NSDate date] timeIntervalSince1970];
        
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2 * M_PI];
        animation.duration = 1.0f;
        animation.repeatCount = HUGE_VAL;
        [self.layer addAnimation:animation forKey:@"MyAnimation"];
    }
}

-(void)stop
{
    if (isRunning) {
        isRunning = NO;
        self.userInteractionEnabled = YES;
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval duration = endTime - startTime;
        if (duration < 1.0f) {
            [self performSelector:@selector(stopRotation) withObject:nil afterDelay:1.0 - duration];
        }
        else
        {
            [self stopRotation];
        }
    }
}

- (void)stopRotation
{
    [self.layer removeAnimationForKey:@"MyAnimation"];
}
@end
