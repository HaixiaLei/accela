//
//  BubbleView.m
//  TestDrawing
//
//  Created by Sywine on 8/5/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import "BubbleView.h"

#define bgColor [UIColor colorWithRed:1.000 green:0.393 blue:0.312 alpha:1.000]

@implementation BubbleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _label = [[UILabel alloc] initWithFrame:frame];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor whiteColor]];
        [_label setFont:[UIFont systemFontOfSize:12]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_label];
        self.color = bgColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    [_label setText:text];
    [_label sizeToFit];
    float w = _label.frame.size.width*1.1 + 10;
    CGRect f = self.frame;
    f.size.width = w;
    [self setFrame:f];
    CGPoint p = CGPointMake(self.frame.size.width/2, self.frame.size.height/3);
    [_label setCenter:p];
    
//    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    float startx = self.frame.size.width*3/10;
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*2/3) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(startx, startx)];
    [self.color set];
    [aPath fill];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(startx*7/8, self.frame.size.height*2/3-1);
    [path moveToPoint:point];
    CGPoint point1 = CGPointMake(startx-self.frame.size.height/3/3, self.frame.size.height*7/8);
    CGPoint control = CGPointMake(point.x, point1.y*8/9);
    [path addQuadCurveToPoint:point1 controlPoint:control];

    float y = point.x + self.frame.size.height/5;
    if (y-point.x>self.frame.size.width/4)
    {
        y = self.frame.size.width/4+point.x;
    }
    CGPoint p = CGPointMake(y, point.y);
    control = CGPointMake(p.x, point1.y*8/9);
    [path addQuadCurveToPoint:p controlPoint:control];
    [self.color set];
    [path fill];
}

@end

































