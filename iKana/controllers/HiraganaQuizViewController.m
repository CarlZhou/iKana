//
//  HiraganaQuizViewController.m
//  iKana
//
//  Created by Zian ZHOU on 2013-05-19.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import "HiraganaQuizViewController.h"
#import "HiraganaQuizWordViewController.h"
#import "CZSlidingMenu.h"
#import "CoreDataManager.h"
#import "LessionSelectionView.h"
#import "UserPrefs.h"
#import "MyStatisticsView.h"
#import "UIUtil.h"
#import "AppState.h"

@interface HiraganaQuizViewController ()

@end

@implementation HiraganaQuizViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    
    CZSlidingMenu *slidingMenu;
    LessionSelectionView *lessonSelectionView;
    UIButton *overlayViewButton;
    MyStatisticsView *myStatisticsView;
}

@synthesize scrollView, pageControl;

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
    
    // load our data from a plist file inside our app bundle
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
//    NSArray *content = [[CoreDataManager sharedInstance] getAllHiraganas];
    
    NSLog(@"%@", [[UserPrefs sharedInstance] selectedLessons]);
    
    NSArray *content = [[CoreDataManager sharedInstance] getHiraganasInLessons:[[UserPrefs sharedInstance] selectedLessons]];
    
    self.contentList = [content mutableCopy];
    
    NSUInteger numberPages = self.contentList.count;
    
    slidingMenu = [[CZSlidingMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-70, 320, 70)];
    [self.view addSubview:slidingMenu];
    Hiragana *hiragana = [self.contentList objectAtIndex:0];
    [slidingMenu setMenuTitle:[NSString stringWithFormat:@"1/%i success:%@ failure:%@", numberPages,hiragana.successTime, hiragana.failureTime]];
    
    [slidingMenu setSwipeRightViewTitle:@"shuffle cards"];
    __block HiraganaQuizViewController *blockSelf = self;
    [slidingMenu setSwipeRightActionHandler:^{
        [blockSelf shuffleHiragana];
        if ([[AppState sharedInstance] neverSwipeOnBar])
        {
            [AppState sharedInstance].neverSwipeOnBar = NO;
        }
    }];
    
    [slidingMenu setSwipeMoreRightViewTitle:@"set cards back to original"];
    [slidingMenu setSwipeMoreRightActionHandler:^{
        [blockSelf setBackHiragana];
        if ([[AppState sharedInstance] neverLongSwipe])
        {
            [AppState sharedInstance].neverLongSwipe = NO;
        }
    }];
    
    [slidingMenu setSwipeLeftViewTitle:@"select lessons"];
    [slidingMenu setSwipeLeftActionHandler:^{
        [blockSelf showLessionSelectionView];
        if ([[AppState sharedInstance] neverSwipeOnBar])
        {
            [AppState sharedInstance].neverSwipeOnBar = NO;
        }
    }];
    
    [slidingMenu setSwipeMoreLeftViewTitle:@"show my stats"];
    [slidingMenu setSwipeMoreLeftActionHandler:^{
        [blockSelf showStatsView];
        if ([[AppState sharedInstance] neverLongSwipe])
        {
            [AppState sharedInstance].neverLongSwipe = NO;
        }
    }];
    
    
    //Put the names of our image files in our array.
    viewControllers = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[viewControllers addObject:[NSNull null]];
    }
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(scrollView.frame) * numberPages, CGRectGetHeight(scrollView.frame));
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = numberPages;
    pageControl.currentPage = 0;
    
    self.scrollView = scrollView;
    self.pageControl = pageControl;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    // remove all the subviews from our scrollview
//    for (UIView *view in self.scrollView.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    
//    NSUInteger numPages = 10;
//    
//    // adjust the contentSize (larger or smaller) depending on the orientation
//    self.scrollView.contentSize =
//    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numPages, CGRectGetHeight(self.scrollView.frame));
//    
//    // clear out and reload our pages
//    viewControllers = nil;
//    NSMutableArray *controllers = [[NSMutableArray alloc] init];
//    for (NSUInteger i = 0; i < numPages; i++)
//    {
//		[controllers addObject:[NSNull null]];
//    }
//    viewControllers = controllers;
//    
//    [self loadScrollViewWithPage:self.pageControl.currentPage - 1];
//    [self loadScrollViewWithPage:self.pageControl.currentPage];
//    [self loadScrollViewWithPage:self.pageControl.currentPage + 1];
//    [self gotoPage:NO]; // remain at the same page (don't animate)
//}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[AppState sharedInstance] neverSwipeOnScreen])
    {
        [[UIUtil sharedInstance] showToastMessage:@"Try swipe to see more words" InView:self.view];
        [[UIUtil sharedInstance] performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
    }
    else if ([[AppState sharedInstance] neverSwipeOnBar])
    {
        [[UIUtil sharedInstance] showToastMessage:@"Try swipe here too" InView:slidingMenu];
        [[UIUtil sharedInstance] performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
    }
    else if([[AppState sharedInstance] neverLongSwipe])
    {
        [[UIUtil sharedInstance] showToastMessage:@"Try a longer swipe" InView:slidingMenu];
        [[UIUtil sharedInstance] performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
    }
}

#pragma mark - UIScrollView Delegate

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= viewControllers.count)
        return;
    
    Hiragana *hiragana = [self.contentList objectAtIndex:page];
    NSString *romaji = hiragana.romaji;
    // replace the placeholder if necessary
    HiraganaQuizWordViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[HiraganaQuizWordViewController alloc] initWithRomaji:romaji];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        controller.hiraganaImageView.image = [UIImage imageNamed:hiragana.imageName];
    }
    
    [controller hideRomaji];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollView.contentSize.width != CGRectGetWidth(self.scrollView.frame) * self.contentList.count)
    {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.contentList.count, CGRectGetHeight(self.scrollView.frame));
    }
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    
    if ([[AppState sharedInstance] neverSwipeOnScreen])
    {
        [AppState sharedInstance].neverSwipeOnScreen = NO;
    }
    
    if ([[AppState sharedInstance] neverSwipeOnBar])
    {
        [[UIUtil sharedInstance] showToastMessage:@"Try swipe here too" InView:slidingMenu];
        [[UIUtil sharedInstance] performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
    }
    else if([[AppState sharedInstance] neverLongSwipe])
    {
        [[UIUtil sharedInstance] showToastMessage:@"Try a longer swipe" InView:slidingMenu];
        [[UIUtil sharedInstance] performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
    }
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < self.contentList.count)
    {
        self.pageControl.currentPage = page;
    }
    
    Hiragana *hiragana = [self.contentList objectAtIndex:page];
    [slidingMenu setMenuTitle:[NSString stringWithFormat:@"%i/%i success:%@ failure:%@", page+1, self.contentList.count,hiragana.successTime, hiragana.failureTime]];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    Hiragana *hiragana = [self.contentList objectAtIndex:page];
    [slidingMenu setMenuTitle:[NSString stringWithFormat:@"%i/%i success:%@ failure:%@", page+1, self.contentList.count,hiragana.successTime, hiragana.failureTime]];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (void)gotoNextPage
{
    if (self.pageControl.currentPage >= self.contentList.count)
    {
        [[UIUtil sharedInstance] showToastMessage:@"This is the last word." InView:self.scrollView];
        return;
    }
    
    self.pageControl.currentPage += 1;
    [self gotoPage:YES];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

- (void)shuffleHiragana
{    
    NSUInteger count = [self.contentList count];
    for (NSUInteger i = 0; i < count; i++) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self.contentList exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numberPages = self.contentList.count;
    // clear out and reload our pages
    viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    viewControllers = controllers;
    
    [self loadScrollViewWithPage:self.pageControl.currentPage - 1];
    [self loadScrollViewWithPage:self.pageControl.currentPage];
    [self loadScrollViewWithPage:self.pageControl.currentPage + 1];
    [self gotoPage:NO]; // remain at the same page (don't animate)
}

- (void)setBackHiragana
{
    [self.contentList removeAllObjects];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
//    NSArray *content = [[CoreDataManager sharedInstance] getAllHiraganas];
    NSArray *content = [[CoreDataManager sharedInstance] getHiraganasInLessons:[[UserPrefs sharedInstance] selectedLessons]];
    
    self.contentList = [content mutableCopy];
    
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numberPages = self.contentList.count;
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    // adjust the contentSize (larger or smaller) depending on the orientation
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    
    NSLog(@"%i", self.pageControl.numberOfPages);
    // clear out and reload our pages
    viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    viewControllers = controllers;
    
    [self loadScrollViewWithPage:self.pageControl.currentPage - 1];
    [self loadScrollViewWithPage:self.pageControl.currentPage];
    [self loadScrollViewWithPage:self.pageControl.currentPage + 1];
    [self gotoPage:NO]; // remain at the same page (don't animate)
}

- (void)updateSlidingMenu
{
    NSInteger page = self.pageControl.currentPage;
    Hiragana *hiragana = [self.contentList objectAtIndex:page];
    [slidingMenu setMenuTitle:[NSString stringWithFormat:@"%i/%i success:%@ failure:%@", page+1, self.contentList.count, hiragana.successTime, hiragana.failureTime]];
}

- (void)showLessionSelectionView
{
    if (!lessonSelectionView)
    {
        lessonSelectionView = [[LessionSelectionView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-300)/2, 200, 300)];
    }
    if (!overlayViewButton)
    {
        overlayViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [overlayViewButton addTarget:self action:@selector(overlayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:overlayViewButton];
    [self.view addSubview:lessonSelectionView];
}

- (void)overlayButtonTapped
{
    [self setBackHiragana];
    [lessonSelectionView removeFromSuperview];
    [myStatisticsView removeFromSuperview];
    [overlayViewButton removeFromSuperview];
}

- (void)showStatsView
{
    if (!myStatisticsView)
    {
        myStatisticsView = [[MyStatisticsView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-400)/2, 200, 400)];
    }
    if (!overlayViewButton)
    {
        overlayViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [overlayViewButton addTarget:self action:@selector(overlayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [myStatisticsView updateData];
    [self.view addSubview:overlayViewButton];
    [self.view addSubview:myStatisticsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    scrollView = nil;
    pageControl = nil;
    slidingMenu = nil;
    [super viewDidUnload];
}
@end
