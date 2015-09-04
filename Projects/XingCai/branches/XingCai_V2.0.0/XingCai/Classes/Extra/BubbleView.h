//
//  BubbleView.h
//  TestDrawing
//
//  Created by Sywine on 8/5/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//  消息条数的气泡

#import <UIKit/UIKit.h>

@interface BubbleView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIColor *color;
-(void)setText:(NSString *)text;

@end
