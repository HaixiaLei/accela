//
//  BankPicker.m
//  XingCai
//
//  Created by Air.Zhao on 14-2-14.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BetPicker.h"

@interface BetPicker()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *dates;
    int selectRowNo;
}
@end

@implementation BetPicker
@synthesize delegate;

- (NSArray *)dates
{
    return dates;
}
- (void)setDates:(NSArray *)names
{
    dates = names;
}

- (int)selectRowNo
{
    return selectRowNo;
}
- (void)setSelectRowNo:(int)row
{
    selectRowNo = row;
}

- (void)setup
{
    [super setDataSource:self];
    [super setDelegate:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (NSString *)selectedDate
{
    NSInteger index = [self selectedRowInComponent:0];
    return [dates objectAtIndex:index];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dates count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = AH_AUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)]);
        
        UILabel *label = AH_AUTORELEASE([[UILabel alloc] initWithFrame:CGRectMake(18, 3, 245, 24)]);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    
    [(UILabel *)[view.subviews objectAtIndex:0] setText:[dates objectAtIndex:row]];
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRowNo = (int) row;
    [delegate betPicker:self didSelectDateWithName:self.selectedDate];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

@end