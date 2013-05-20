//
//  CZSlidingMenuCell.m
//  CZSlidingMenu
//
//  Created by Carl on 2013-04-08.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "CZSlidingMenuCell.h"

@implementation CZSlidingMenuCell

@synthesize swipeLeftActionHandler, swipeRightActionHandler;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.contentView addGestureRecognizer:swipeLeft];
        [self.contentView addGestureRecognizer:swipeRight];
        
        menuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, self.contentView.frame.size.height)];
        [self.contentView addSubview:menuTitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Cell layout

- (void)setMenuTitle:(NSString *)title
{
    menuTitleLabel.text = title;
}

#pragma mark - Swipe Action

- (void)didSwipeLeft
{
    if (swipeLeftActionHandler)
        swipeLeftActionHandler();
}

- (void)didSwipeRight
{
    if (swipeRightActionHandler)
        swipeRightActionHandler();
}

@end
