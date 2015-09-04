//
//  EventsViewController.m
//  JiXiangCai
//
//  Created by jay on 14-10-18.
//  Copyright (c) 2014年 weststar. All rights reserved.
//

#import "EventsViewController.h"
#import "BuyViewController.h"
#import "MyPageControl.h"
@interface EventView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

+ (instancetype)eventView;
@end

@implementation EventView

+ (instancetype)eventView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventView" owner:self options:nil];
    for (id oneObject in nib) {
        if ([oneObject isKindOfClass:[EventView class]]) {
            EventView *eventView = (EventView *)oneObject;
            eventView.frame = IS_IPHONE4 ? CGRectMake(0, 0, 263, 393) : CGRectMake(0, 0, 263, 487);
            return eventView;
        }
    }
    return nil;
}

@end

@interface EventsViewController () <UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    MyPageControl *pageControl;
}

@end

@implementation EventsViewController

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
    // Do any additional setup after loading the view from its nib.
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    
    [self updateEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender {
    self.view.hidden = YES;
    
    if ([self.parentViewController isKindOfClass:[BuyViewController class]]) {
        BuyViewController *buyViewController = (BuyViewController *)self.parentViewController;
        if ([buyViewController respondsToSelector:@selector(showEventButton)]) {
            [buyViewController performSelector:@selector(showEventButton)];
        }
    }
    
}

- (void)updateEvents
{
    ScreenType  screenType = IS_IPHONE4 ? ScreenType3p5 : ScreenType4p0;
    [[AFAppAPIClient sharedClient] getActivityList_with_screenType:screenType block:^(id JSON, NSError *error){
        if (!error) {
            NSArray *urls = [JSON objectForKey:@"results"];
            
            CGRect frame = IS_IPHONE4 ? CGRectMake(29, 41, 263, 393) : CGRectMake(29, 41, 263, 487);
            
            if (!myScrollView) {
                myScrollView = [[UIScrollView alloc] initWithFrame:frame];
                myScrollView.pagingEnabled = YES;
                myScrollView.showsHorizontalScrollIndicator = NO;
                myScrollView.showsVerticalScrollIndicator = NO;
                myScrollView.delegate = self;
                [self.view insertSubview:myScrollView aboveSubview:self.bgView];
            }
            else
            {
                [myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [myScrollView scrollRectToVisible:CGRectMake(0, 0, frame.size.width, frame.size.height) animated:NO];
            }
            
            CGSize contentSize = frame.size;
            contentSize.width *= urls.count;
            EventView *eventView = [EventView eventView];
            contentSize.height = eventView.frame.size.height;
            myScrollView.contentSize = contentSize;
            
            NSString *imgName = IS_IPHONE4 ? @"event_placeholder3p5" : @"event_placeholder4p0";
            UIImage *placeHolderImage = [UIImage imageNamed:imgName];
            
            for (int i = 0; i < urls.count;  ++i) {
                NSString *urlString = [urls objectAtIndex:i];
                NSURL *url = [NSURL URLWithString:urlString];
                EventView *eventView = [EventView eventView];
                [eventView.imgView setImageWithURL:url placeholderImage:placeHolderImage];
                CGRect eventViewFrame = eventView.frame;
                eventViewFrame.origin.x = frame.size.width * i;
                eventView.frame = eventViewFrame;
                [myScrollView addSubview:eventView];
            }
            
            if (urls.count > 1) {
                if (pageControl) {
                    [pageControl removeFromSuperview];
                }
                NSInteger totalPageCounts = urls.count;
                CGFloat dotGapWidth = 8.0;
                UIImage *normalDotImage = [UIImage imageNamed:@"page_state_normal"];
                UIImage *highlightDotImage = [UIImage imageNamed:@"page_state_highlight"];
                CGFloat pageControlWidth = totalPageCounts * normalDotImage.size.width + (totalPageCounts - 1) * dotGapWidth;
                CGRect pageControlFrame = CGRectMake(CGRectGetMidX(myScrollView.frame) - 0.5 * pageControlWidth ,CGRectGetHeight(myScrollView.frame) + myScrollView.frame.origin.y - normalDotImage.size.height - 10, pageControlWidth, normalDotImage.size.height);
                
                pageControl = [[MyPageControl alloc] initWithFrame:pageControlFrame
                                                       normalImage:normalDotImage
                                                  highlightedImage:highlightDotImage
                                                        dotsNumber:totalPageCounts sideLength:dotGapWidth dotsGap:dotGapWidth];
                [self.view addSubview:pageControl];
            }
        }
    }];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = pageNumber;
}

@end
