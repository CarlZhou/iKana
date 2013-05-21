//
//  MyStatisticsView.h
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStatisticsView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *statisticView;
}

- (void)updateData;

@end