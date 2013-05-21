//
//  CoreDataUtil.h
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataUtil : NSObject

/**
 * @abstract return a NSManagedObjectContext object for the current thread
 * @discussion this method will determine current thread and always return same NSManagedObjectContext for the thread
 */
+ (NSManagedObjectContext *)getContext;

/**
 * @abstract Save all managed object managed by current context.
 * @discussion All objects must be created on the same thread
 */
+ (void)saveManagedObjectContext;

/**
 * @abstract Reset all managed object managed by current context to free up memory
 */
+ (void)resetManagedObjectContext;

@end