//
//  HiraganaQuizWordViewController.h
//  iKana
//
//  Created by Zian ZHOU on 2013-05-19.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiraganaQuizWordViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *hiraganaImageView;

- (id)initWithRomaji:(NSString *)Romaji;
- (void)hideRomaji;

@end
