//
//  LessionSelectionView.m
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import "LessionSelectionView.h"
#import "UserPrefs.h"
#import "UIUtil.h"

@implementation LessionSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        lessonTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        lessonTableView.delegate = self;
        lessonTableView.dataSource = self;
        [self addSubview:lessonTableView];
//        
//        UIButton *closeButton = [[UIButton alloc] initWithFrame: CGRectMake(-10,-10,20,20)];
//        closeButton.backgroundColor = [UIColor clearColor];
//        [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:closeButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)closeView
{
    NSLog(@"close view");
    [self removeFromSuperview];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LessonListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"Lesson: %i" , indexPath.row+1];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    NSArray *selectedLessons = [[UserPrefs sharedInstance] selectedLessons];
    
    if ([selectedLessons containsObject:@(indexPath.row + 1)])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *selectedLessons = [[[UserPrefs sharedInstance] selectedLessons] mutableCopy];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *lessonNum = @(indexPath.row + 1);
    
    if ([selectedLessons containsObject:lessonNum])
    {
        if (selectedLessons.count != 1)
        {
            [selectedLessons removeObject:lessonNum];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            [[UIUtil sharedInstance] showToastMessage:@"At least one lesson" InView:self];
            [[UIUtil sharedInstance] performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
        }
    }
    else
    {
        [selectedLessons insertObject:lessonNum atIndex:0];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [UserPrefs sharedInstance].selectedLessons = selectedLessons;
}

@end
