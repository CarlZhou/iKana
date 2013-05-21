//
//  CoreDataManager.h
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataUtil.h"
#import "Hiragana.h"

@interface CoreDataManager : NSObject

- (void)initHiraganaCoreData;
- (Hiragana *)hiraganaWithRomaji:(NSString *)romaji;
- (NSArray *)getAllHiraganas;
- (NSArray *)getHiraganasInLessons:(NSArray *)lessons;

// CoreData Fetch
- (NSArray *)performFetchRequestForEntity:(NSString *)name withPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;

// SharedInstance
+ (CoreDataManager *)sharedInstance;

@end
