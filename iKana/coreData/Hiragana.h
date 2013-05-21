//
//  Hiragana.h
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Hiragana : NSManagedObject

@property (nonatomic, retain) NSString * romaji;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * successTime;
@property (nonatomic, retain) NSNumber * failureTime;
@property (nonatomic, retain) NSNumber * isImportant;
@property (nonatomic, retain) NSNumber * lessonNum;
@property (nonatomic, retain) NSNumber * isFailureLastTime;
@property (nonatomic, retain) NSNumber * isMastered;
@property (nonatomic, retain) NSNumber * orderNum;

@end
