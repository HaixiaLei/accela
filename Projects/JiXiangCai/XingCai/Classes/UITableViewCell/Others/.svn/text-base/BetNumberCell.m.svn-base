//
//  BetNumberCell.m
//  XingCai
//
//  Created by jay on 14-3-5.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetNumberCell.h"
#import <QuartzCore/QuartzCore.h>

@interface SeperateLine : UIView

@end

@implementation SeperateLine

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0, 1);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context,[UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextStrokePath(context);
    
    
}

@end

@interface BetNumberCell()
@property (nonatomic,retain) SeperateLine *seperateLine;
@end
@implementation BetNumberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame= self.contentView.frame;
//        _seperateLine = [[SeperateLine alloc]initWithFrame:CGRectZero];
//        _seperateLine.backgroundColor=[UIColor redColor];
//        [self.contentView addSubview:_seperateLine];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%@",self.bfObject.detail);
    self.cellBottomLine.frame = CGRectMake(0, 89, 320, 1);
    if (self.bfObject.isExpand==YES&&self.bfObject.detail.length>18) {
        self.cellBottomLine.frame = CGRectMake(0, 119, 320, 1);
        self.betNumberLabel.frame = CGRectMake(122, 30, 160, 70);
        self.deleBgimg.frame = CGRectMake(0, 0, 36, 119);
        self.betNumberLabel.numberOfLines=0;
        [self.betNumberLabel setBackgroundColor:[UIColor clearColor]];
        self.betNumberLabel.text=self.bfObject.detail;
        
        self.numberOfBetLabel.frame= CGRectMake(38, 95, 50,21);
        self.priceLabel.frame= CGRectMake(174, 95, 96, 21);
        self.timesLabel.frame= CGRectMake(112, 95, 48, 21);
      
        self.deleteButton.frame= CGRectMake(0 ,42, 36, 36);
        self.arrowButton.frame= CGRectMake(290,75, 30, 30);
        [self setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]];
        self.arrowButton.selected=YES;
        self.zhuLabel.point =CGPointMake(88, 95);
        self.beiLabel.point =CGPointMake(155, 95);
        self.yuanLable.point =CGPointMake(264, 95);

    }else if(self.bfObject.isExpand==YES&&self.bfObject.detail.length<19)
    {
         self.deleBgimg.frame = CGRectMake(0, 0, 36, 89);
        self.numberOfBetLabel.frame= CGRectMake(38, 60, 50,21);
        self.priceLabel.frame= CGRectMake(174, 60, 96, 21);
        self.timesLabel.frame= CGRectMake(112, 60, 48, 21);
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]];

        self.betNumberLabel.frame = CGRectMake(122, 35, 160, 21);
        self.deleteButton.frame= CGRectMake(0 ,26, 36, 36);
        self.arrowButton.frame= CGRectMake(290,50, 30, 30);
        self.arrowButton.selected=YES;
        self.zhuLabel.point =CGPointMake(88, 60);
        self.beiLabel.point =CGPointMake(155, 60);
        self.yuanLable.point =CGPointMake(264, 60);

    }else
    {
        self.deleBgimg.frame = CGRectMake(0, 0, 36, 89);
        self.numberOfBetLabel.frame= CGRectMake(38, 60, 50,21);
        self.priceLabel.frame= CGRectMake(174, 60, 96, 21);
        self.timesLabel.frame= CGRectMake(112, 60, 48, 21);
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.betNumberLabel.frame = CGRectMake(122, 35, 160, 21);
        self.deleteButton.frame= CGRectMake(0 ,26, 36, 36);
        self.arrowButton.frame= CGRectMake(290,50, 30, 30);
        self.arrowButton.selected=NO;

        self.zhuLabel.point =CGPointMake(88, 60);
        self.beiLabel.point =CGPointMake(155, 60);
        self.yuanLable.point =CGPointMake(264, 60);

    }
}

@end
