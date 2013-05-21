//
//  MyStatisticsView.m
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import "MyStatisticsView.h"
#import "UserPrefs.h"
#import "CoreDataManager.h"
#import "Hiragana.h"

@implementation MyStatisticsView
{
    NSMutableArray *contentList;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        statisticView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        statisticView.delegate = self;
        statisticView.dataSource = self;
        [self addSubview:statisticView];
        contentList = [NSMutableArray array];
        [self updateData];
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

- (void)updateData
{
    NSArray *content = [[CoreDataManager sharedInstance] getAllHiraganas];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"failureTime" ascending:YES];
    contentList = [[content sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    [statisticView reloadData];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatisticsListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Hiragana *hiragana = [contentList objectAtIndex:indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [[UIImage imageNamed:hiragana.imageName] stretchableImageWithLeftCapWidth:250 topCapHeight:250];
    cell.textLabel.text = [NSString stringWithFormat:@"Romaji: %@" , hiragana.romaji];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Failure: %@", hiragana.failureTime];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSMutableArray *selectedLessons = [[[UserPrefs sharedInstance] selectedLessons] mutableCopy];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSNumber *lessonNum = @(indexPath.row + 1);
//    
//    if ([selectedLessons containsObject:lessonNum])
//    {
//        [selectedLessons removeObject:lessonNum];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    else
//    {
//        [selectedLessons insertObject:lessonNum atIndex:0];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    
//    [UserPrefs sharedInstance].selectedLessons = selectedLessons;
//}

@end
