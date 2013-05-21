//
//  CoreDataUtil.m
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import "CoreDataUtil.h"
#import "AppDelegate.h"

@implementation CoreDataUtil

+ (NSManagedObjectContext *)getContext
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

+ (void)saveManagedObjectContext
{
    NSManagedObjectContext *context = [CoreDataUtil getContext];
    if (!context) return;
    
    NSError *savingError = nil;
    if (![context save:&savingError])
    {
        NSLog(@"Failed to save to data store: %@", [savingError localizedDescription]);
        NSArray* detailedErrors = [savingError userInfo][NSDetailedErrorsKey];
        if (detailedErrors != nil && [detailedErrors count] > 0)
        {
            for (NSError* detailedError in detailedErrors)
            {
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else
        {
            NSLog(@"  %@", [savingError userInfo]);
        }
    }
}

+ (void)resetManagedObjectContext
{
    NSManagedObjectContext *context = [self getContext];
    [context reset];
}

@end

