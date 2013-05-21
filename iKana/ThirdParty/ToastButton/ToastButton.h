/*

 ToastButton.h

 MIT LICENSE

 Copyright (c) 2013 Zian ZHOU

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */

#import <UIKit/UIKit.h>

typedef enum {
    /** */
    ToastButtonBtnMode,
    /**  */
    ToastButtonToastMode,
    /**  */
    ToastButtonCustomViewMode,
    /**  */
    ToastButtonModeNum
} ToastButtonMode;

typedef enum {
    /** */
    ToastTopPositionMode,
    /**  */
    ToastCenterPositionMode,
    /**  */
    ToastBottomPositionMode,
    /**  */
    ToastPositionModeNum
} ToastPositionMode;

@interface ToastButton : UIView
{
    UIView *toastSetView;
    UILabel *toastTextLabel;
    UIImage *toastImage;
    UIImageView *toastImageView;
    UIView *customView;
    UIButton *toastBtn;
    UIFont *toastTextFont;
    BOOL isAnimated;
    ToastButtonMode toastMode;
    ToastPositionMode positionMode;
    CGFloat initSuperViewWidth;
    CGFloat initSuperViewHeight;
    UIView *backgroundView;
    NSTimeInterval hideAfterDelayTime;
    UIInterfaceOrientation lastInterfaceOrientation;
    BOOL initWithWindow;
    UIWindow *initWindow;
}

+ (ToastButton *)showToastWithAnimated:(BOOL)animated;
+ (ToastButton *)showToastTo:(UIView *)view animated:(BOOL)animated;
+ (ToastButton *)showToastTo:(UIView *)view animated:(BOOL)animated hideAfter:(NSTimeInterval)secs;

- (void)Show;
- (void)ShowAfterDelay:(NSTimeInterval)delay;

- (void)ShowAfterCompletion:(void (^)(BOOL))completion;
- (void)Hide;
- (void)HideAfterDelay:(NSTimeInterval)delay;

- (void)HideWithCompletion:(void (^)(BOOL))completion;
- (void)setTarget:(id)target Action:(SEL)Selector;
- (void)setToastText:(NSString *)text;
- (void)setToastImage:(UIImage *)image;
- (void)setCustomView:(UIView *)view;
- (void)setPositionMode:(ToastPositionMode)mode;

@property BOOL removeFromSuperViewAfterHide;

@end
