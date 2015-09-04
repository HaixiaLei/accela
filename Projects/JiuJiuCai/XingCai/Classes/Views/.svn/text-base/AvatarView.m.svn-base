//
//  AvatarView.m
//  JiuJiuCai
//
//  Created by jay on 14-6-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "AvatarView.h"

@implementation AvatarView

+ (NSString *)avatarImageNameFromIndex:(NSInteger)index
{
    AvatarViewGroup group = index / 1000 * 1000;
    NSString *imageName = nil;
    switch (group) {
        case AvatarViewGroupA:
            imageName = [NSString stringWithFormat:@"avatar_image_a_%ld",index - group];
            break;
        case AvatarViewGroupB:
            imageName = [NSString stringWithFormat:@"avatar_image_b_%ld",index - group];
            break;
        case AvatarViewGroupC:
            imageName = [NSString stringWithFormat:@"avatar_image_c_%ld",index - group];
            break;
        case AvatarViewGroupD:
            imageName = [NSString stringWithFormat:@"avatar_image_d_%ld",index - group];
            break;
        default:
            NSAssert(YES, @"非法Index");
            break;
    }
    return imageName;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    self.selected = NO;
}

- (void)setSelected:(BOOL)selected
{
    self.button.selected = selected;
}
- (BOOL)selected
{
    return self.button.selected;
}

+ (AvatarView *)instanceAvatarView
{
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"AvatarView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

@end
