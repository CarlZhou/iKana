//
//  DeviceUtil.m
//  iKana
//
//  Created by Zian ZHOU on 2013-05-20.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import "DeviceUtil.h"

@implementation DeviceUtil

+ (BOOL)isFourInchRetina
{
     return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}

@end
