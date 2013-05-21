//
//  AppState.h
//  UWCourse
//
//  Created by Carl on 2013-04-15.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "PersistedState.h"

@interface AppState : PersistedState

@property BOOL isLaunchingCompleted;
@property BOOL firstTimeOpen;
@property BOOL neverSwipeOnScreen;
@property BOOL neverSwipeOnBar;
@property BOOL neverLongSwipe;

+ (AppState *)sharedInstance;

@end
