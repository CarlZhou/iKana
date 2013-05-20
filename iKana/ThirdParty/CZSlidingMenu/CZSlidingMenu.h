//
//  CZSlidingMenu.h
//  CZSlidingMenu
//
//  Created by Carl on 2013-04-08.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZSlidingMenu : UIView
{
    UILabel *menuTitleLabel;
    UILabel *swipeLeftViewLabel;
    UILabel *swipeRightViewLabel;
    UILabel *swipeMoreLeftViewLabel;
    UILabel *swipeMoreRightViewLabel;
    UIColor *backgroundColor;
    UIView *swipeLeftView;
    UIView *swipeRightView;
    void (^swipeLeftActionHandler)(void);
    void (^swipeMoreLeftActionHandler)(void);
    void (^swipeRightActionHandler)(void);
    void (^swipeMoreRightActionHandler)(void);
    CGPoint touchStartPoint;
}

@property (nonatomic, strong) void (^swipeLeftActionHandler)(void);
@property (nonatomic, strong) void (^swipeMoreLeftActionHandler)(void);
@property (nonatomic, strong) void (^swipeRightActionHandler)(void);
@property (nonatomic, strong) void (^swipeMoreRightActionHandler)(void);

- (void)setMenuTitle:(NSString *)title;
- (void)setSwipeLeftViewTitle:(NSString *)title;
- (void)setSwipeMoreLeftViewTitle:(NSString *)title;
- (void)setSwipeRightViewTitle:(NSString *)title;
- (void)setSwipeMoreRightViewTitle:(NSString *)title;

@end
