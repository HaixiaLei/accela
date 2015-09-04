//
//  UIViewController+CustomNavigationLeftButtonItem.h
//  e-Cantonfair
//
//  Created by LiangZF on 1/16/14.
//  Copyright (c) 2014 ecantonfair. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    BackActionPop,
    BackActionDismiss
    
} BackActionType;

@interface UIViewController (CustomNavigationLeftButtonItem)

-(void)setupBackNavigationItemInViewController:(BackActionType)actionType;

-(UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image disableImage:(UIImage *)disableImage target:(id)target selector:(SEL)selector;
@end
