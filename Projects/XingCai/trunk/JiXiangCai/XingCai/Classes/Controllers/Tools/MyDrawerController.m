//
//  MyDrawerController.m
//  JiXiangCai
//
//  Created by jay on 14-11-6.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "MyDrawerController.h"
#import "MessageViewController.h"
@interface MyDrawerController ()

@end

@implementation MyDrawerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    [super closeDrawerAnimated:animated completion:completion];
    
    if ([self.centerViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *firstVC = [((UINavigationController *)self.centerViewController).viewControllers firstObject];
        if ([firstVC isKindOfClass:[MessageViewController class]]) {
            MessageViewController *messageViewController = (MessageViewController *)firstVC;
            [messageViewController view];
            [messageViewController refreshList];
        }
    }
}

@end
