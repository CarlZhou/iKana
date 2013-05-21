//
//  UIUtil.h
//  UWCourse
//
//  Created by Carl on 2013-03-28.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface UIUtil : NSObject

- (void)showLoadMessageInView:(UIView *)view;
- (void)showToastMessage:(NSString *)message InView:(UIView *)view;
- (void)hideProgressHUD;
- (UINavigationController *)getRootNaviViewController;

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (void)showNetworkUnavailableAlert;
+ (void)showNetworkErrorAlert;

// SharedInstance
+ (UIUtil *)sharedInstance;

@end
