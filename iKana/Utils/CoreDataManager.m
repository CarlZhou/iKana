//
//  CoreDataManager.m
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import "CoreDataManager.h"

static NSString *kNameKey = @"romajiKey";
static NSString *kImageKey = @"imageKey";

@implementation CoreDataManager

- (NSArray *)performFetchRequestForEntity:(NSString *)name withPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [CoreDataUtil getContext];
    if (!context)
        return nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPendingChanges:NO];
    [fetchRequest setReturnsObjectsAsFaults:YES];
    
    if (predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptors)
    {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

- (void)initHiraganaCoreData
{
    // load our data from a plist file inside our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
    NSArray *content = [NSArray arrayWithContentsOfFile:path];
    
    NSManagedObjectContext *context = [CoreDataUtil getContext];
    
    [content enumerateObjectsUsingBlock:^(NSDictionary *basicInfo, NSUInteger index, BOOL *stop){
        NSString *romaji = [basicInfo valueForKey:kNameKey];
        NSString *imageName = [basicInfo valueForKey:kImageKey];
        
        Hiragana *hiragana = [self hiraganaWithRomaji:romaji];
        if (!hiragana)
        {
            hiragana = (Hiragana *)[NSEntityDescription insertNewObjectForEntityForName:@"Hiragana" inManagedObjectContext:context];
        }
        hiragana.romaji = romaji;
        hiragana.imageName = imageName;
        hiragana.isImportant = @(NO);
        hiragana.isFailureLastTime = @(NO);
        hiragana.successTime = @(0);
        hiragana.failureTime = @(0);
        hiragana.isMastered = @(NO);
        hiragana.orderNum = @(index);
        if (index < 35)
        {
            hiragana.lessonNum = @(index/5 + 1);
        }
        else if(index >= 35 && index < 38)
        {
            hiragana.lessonNum = @(8);
        }
        else if (index >= 38 && index < 43)
        {
            hiragana.lessonNum = @(9);
        }
        else
        {
            hiragana.lessonNum = @(10);
        }
        
        [CoreDataUtil saveManagedObjectContext];
    }];
}

- (Hiragana *)hiraganaWithRomaji:(NSString *)romaji
{
    NSArray *hiraganas = [self performFetchRequestForEntity:@"Hiragana" withPredicate:[NSPredicate predicateWithFormat:@"romaji == %@", romaji] andSortDescriptors:nil];
    
    if ([hiraganas count] != 0)
        return hiraganas[0];
    else
        return nil;
}

- (NSArray *)getAllHiraganas
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderNum" ascending:YES];
    return [self performFetchRequestForEntity:@"Hiragana" withPredicate:nil andSortDescriptors:@[sortDescriptor]];
}

- (NSArray *)getHiraganasInLessons:(NSArray *)lessons
{
    NSMutableArray *result = [NSMutableArray array];
    
    [lessons enumerateObjectsUsingBlock:^(NSNumber *lessonNum, NSUInteger index, BOOL *stop){
        [result addObjectsFromArray:[self performFetchRequestForEntity:@"Hiragana" withPredicate:[NSPredicate predicateWithFormat:@"lessonNum == %@", lessonNum] andSortDescriptors:nil]];
    }];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderNum" ascending:YES];
    [result sortUsingDescriptors:@[sortDescriptor]];
    
    return result;
}

#pragma mark - sharedInstance

+ (CoreDataManager *)sharedInstance
{
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
    });
    return sharedInstance;
}

@end
