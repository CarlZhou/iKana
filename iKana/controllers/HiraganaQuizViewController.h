//
//  HiraganaQuizViewController.h
//  iKana
//
//  Created by Zian ZHOU on 2013-05-19.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiraganaQuizViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentList;

@end
