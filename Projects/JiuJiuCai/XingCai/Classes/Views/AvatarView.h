//
//  AvatarView.h
//  JiuJiuCai
//
//  Created by jay on 14-6-21.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AvatarViewGroup){
    AvatarViewGroupA    = 1000,
    AvatarViewGroupB    = 2000,
    AvatarViewGroupC    = 3000,
    AvatarViewGroupD    = 4000,
};

@interface AvatarView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (assign, nonatomic) BOOL selected;

+ (NSString *)avatarImageNameFromIndex:(NSInteger)index;

+ (AvatarView *)instanceAvatarView;
- (void)setImage:(UIImage *)image;
@end
