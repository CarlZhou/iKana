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

@interface HiraganaQuizViewController ()

@end

@implementation HiraganaQuizViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    
    CZSlidingMenu *slidingMenu;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
    NSArray *content = [NSArray arrayWithContentsOfFile:path];
    
    self.contentList = [content mutableCopy];
    
    NSUInteger numberPages = self.contentList.count;
    
    slidingMenu = [[CZSlidingMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-70, 320, 70)];
    [self.view addSubview:slidingMenu];
    [slidingMenu setMenuTitle:@"0/46"];
    
    [slidingMenu setSwipeRightViewTitle:@"shuffle cards"];
    __block HiraganaQuizViewController *blockSelf = self;
    [slidingMenu setSwipeRightActionHandler:^{
        [blockSelf shuffleHiragana];
        [blockSelf loadScrollViewWithPage:0];
    }];
    
    [slidingMenu setSwipeMoreRightViewTitle:@"set cards back to original"];
    [slidingMenu setSwipeMoreRightActionHandler:^{
        [blockSelf setBackHiragana];
        [blockSelf loadScrollViewWithPage:0];
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
    //
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

#pragma mark - UIScrollView Delegate

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= viewControllers.count)
        return;
    
    NSDictionary *numberItem = [self.contentList objectAtIndex:page];
    NSString *romaji = [numberItem valueForKey:@"romajiKey"];
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
        
//        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        controller.hiraganaImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", romaji]];
//        controller.numberTitle.text = [numberItem valueForKey:kNameKey];
    }
    [controller hideRomaji];
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    [slidingMenu setMenuTitle:[NSString stringWithFormat:@"%i/46", page]];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    [slidingMenu setMenuTitle:[NSString stringWithFormat:@"%i/46", page]];
    
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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
    NSArray *content = [NSArray arrayWithContentsOfFile:path];
    
    self.contentList = [content mutableCopy];
    
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
