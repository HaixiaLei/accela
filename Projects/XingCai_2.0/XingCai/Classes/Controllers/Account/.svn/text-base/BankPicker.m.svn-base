//
//  BankPicker.m
//  XingCai
//
//  Created by Air.Zhao on 14-2-14.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "BankPicker.h"

@interface BankPicker()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *bankNames;
    NSInteger selectRowNo;
}
@end

@implementation BankPicker
@synthesize delegate;

- (NSArray *)bankNames
{
    return bankNames;
}
- (void)setBankNames:(NSArray *)names
{
    bankNames = names;
}

- (NSInteger)selectRowNo
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

- (NSString *)selectedBankName
{
    NSInteger index = [self selectedRowInComponent:0];
    return [bankNames objectAtIndex:index];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [bankNames count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = AH_AUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)]);
        
        UILabel *label = AH_AUTORELEASE([[UILabel alloc] initWithFrame:CGRectMake(35, 3, 245, 24)]);
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    
    [(UILabel *)[view.subviews objectAtIndex:0] setText:[bankNames objectAtIndex:row]];
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRowNo = row;
    [delegate bankPicker:self didSelectBankWithName:self.selectedBankName];
}

@end