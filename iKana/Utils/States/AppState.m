//
//  AppState.m
//  UWCourse
//
//  Created by Carl on 2013-04-15.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "AppState.h"

@implementation AppState

- (NSDictionary *)getDefaults
{
    return @{
             @"isLaunchingCompleted": @[PS_TYPE_BOOL,      @(NO)],
             @"firstTimeOpen":        @[PS_TYPE_BOOL,      @(YES)],
             @"neverSwipeOnScreen":   @[PS_TYPE_BOOL,      @(YES)],
             @"neverSwipeOnBar":      @[PS_TYPE_BOOL,      @(YES)],
             @"neverLongSwipe":       @[PS_TYPE_BOOL,      @(YES)]
             };
}

+ (AppState *)sharedInstance
{
    static AppState *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppState alloc] init];
    });
    return sharedInstance;
}

@end
