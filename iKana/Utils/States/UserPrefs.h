//
//  UserPrefs.h
//  UWCourse
//
//  Created by Carl on 2013-04-18.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "PersistedState.h"

@interface UserPrefs : PersistedState

@property NSArray *selectedLessons;

+ (UserPrefs *)sharedInstance;

@end
