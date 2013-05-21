//
//  UserPrefs.m
//  UWCourse
//
//  Created by Carl on 2013-04-18.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "UserPrefs.h"

@implementation UserPrefs

- (NSDictionary *)getDefaults
{
    return @{
             @"selectedLessons":    @[PS_TYPE_ARRAY, [NSMutableArray array]]
             };
}

+ (UserPrefs *)sharedInstance
{
    static UserPrefs *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserPrefs alloc] init];
    });
    return sharedInstance;
}

@end
