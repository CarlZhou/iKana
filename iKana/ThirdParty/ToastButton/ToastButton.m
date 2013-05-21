/*

 ToastButton.m

 MIT LICENSE

 Copyright (c) 2013 Zian ZHOU

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */

#import <CoreGraphics/CoreGraphics.h>
#import "ToastButton.h"
#import "QuartzCore/QuartzCore.h"

#define DegreesToRadians(x) (CGFloat)((x) * M_PI / 180.0)

@interface ToastButton()

- (void)setDisplayToast:(BOOL)animated;

@end

@implementation ToastButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        backgroundView = [[UIView alloc] init];
        backgroundView.alpha = 0.0f;
        backgroundView.layer.cornerRadius = 5.0f;
        [backgroundView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:backgroundView];
        toastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:toastBtn];
        toastTextLabel = [[UILabel alloc] init];
        toastTextLabel.textColor = [UIColor whiteColor];
        toastTextLabel.backgroundColor = [UIColor clearColor];
        toastTextLabel.numberOfLines = 0;
        toastTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        toastTextLabel.textAlignment = NSTextAlignmentCenter;
        toastTextLabel.alpha = 0.0f;
        [self addSubview:toastTextLabel];
        toastImage = nil;
        toastImageView = nil;
        toastTextFont = nil;
        customView = nil;
        isAnimated = YES;
        positionMode = ToastCenterPositionMode;
        [self setMode:ToastButtonToastMode];
        self.removeFromSuperViewAfterHide = YES;
        [self setInitFrame];
        [self resizeSubviewsForToastButton];
        lastInterfaceOrientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    }
    return self;
}

- (void)setInitFrame
{
    CGFloat originX, originY;
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
	switch (orientation)
    {
		case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
		{
            originX = (toastSetView.bounds.size.width - 40)/2;
            originY = (toastSetView.bounds.size.height - 40)/2;
            [self setFrame:CGRectMake(originX, originY, 40, 40)];
            initSuperViewWidth = toastSetView.bounds.size.width;
            initSuperViewHeight = toastSetView.bounds.size.height;
			break;
		}
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
		{
            originY = (toastSetView.bounds.size.height - 40)/2;
            originX = (toastSetView.bounds.size.width - 40)/2;
            [self setFrame:CGRectMake(originX, originY, 40, 40)];
            initSuperViewWidth = toastSetView.bounds.size.width;
            initSuperViewHeight = toastSetView.bounds.size.height;
			break;
		}
		default:
			break;
	}
}

-(id)initWithView:(UIView *)view
{
    if (!view)
    {
		[NSException raise:@"ViewIsNillException"
					format:@"The view is nil."];
	}

    toastSetView = view;

    return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window
{
    initWithWindow = YES;
    initWindow = window;
    UIView *view = [window.subviews objectAtIndex:window.subviews.count-1];
    toastSetView = view;
    self = [self initWithFrame:view.bounds];
    [window addSubview:self];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    return self;
}

+ (ToastButton *)showToastWithAnimated:(BOOL)animated
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    ToastButton *toastBtn = [[ToastButton alloc] initWithWindow:window];
    return toastBtn;
}

UIDeviceOrientation currentOrientation;

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

    //Ignoring specific orientations
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object:nil];
    //Responding only to changes in landscape or portrait
    currentOrientation = orientation;
    //
    [self performSelector:@selector(orientationChangedMethod) withObject:nil afterDelay:0];
}

- (void)orientationChangedMethod
{
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
	switch (orientation)
    {
		case UIInterfaceOrientationPortrait:
        {
            switch (lastInterfaceOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
                    break;
                default:
                    break;
            }
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
		{
            switch (lastInterfaceOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
                    break;
                default:
                    break;
            }
            break;
		}
		case UIInterfaceOrientationLandscapeLeft:
        {
            switch (lastInterfaceOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(270));
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(270));
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(270));
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(270));
                    break;
                default:
                    break;
            }
            break;
        }
		case UIInterfaceOrientationLandscapeRight:
		{
            switch (lastInterfaceOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
                    break;
                default:
                    break;
            }
            break;
		}
		default:
			break;
	}
    //rotate rect
    lastInterfaceOrientation = orientation;
}

+ (ToastButton *)showToastTo:(UIView *)view animated:(BOOL)animated
{
	ToastButton *toastBtn = [[ToastButton alloc] initWithView:view];
	[view addSubview:toastBtn];
	return toastBtn;
}

+ (ToastButton *)showToastTo:(UIView *)view animated:(BOOL)animated hideAfter:(NSTimeInterval)secs
{
    ToastButton *toastBtn = [[ToastButton alloc] initWithView:view];
	[view addSubview:toastBtn];
    [toastBtn setHideAfterDelayTime:secs+0.5];
	return toastBtn;
}

- (void)setHideAfterDelayTime:(NSTimeInterval)delay
{
    hideAfterDelayTime = delay;
}

- (void)setDisplayToast:(BOOL)animated
{
    isAnimated = animated;
}

- (void)ShowWithAnimation:(BOOL)animated withCompletion:(void (^)(BOOL finished))completion
{
    [self setPosition];
    if (animated)
    {
        backgroundView.alpha = 0.0f;
        toastTextLabel.alpha = 0.0f;
        toastImageView.alpha = 0.0f;
        customView.alpha = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            backgroundView.alpha = 0.7f;
            toastTextLabel.alpha = 1.0f;
            toastImageView.alpha = 1.0f;
            customView.alpha = 1.0f;
        }completion:^(BOOL finished){
            // TODO:After animation actions
            if (hideAfterDelayTime != 0)
                [self HideAfterDelay:hideAfterDelayTime];
            if (completion)
                completion(finished);
        }];
    }
    else
    {
        toastTextLabel.alpha = 1.0f;
        toastImageView.alpha = 1.0f;
        customView.alpha = 1.0f;
        backgroundView.alpha = 0.7f;
        if (completion)
            completion(YES);
    }
}

- (void)Show
{
    [self ShowWithAnimation:isAnimated withCompletion:nil];
}

- (void)ShowAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(Show) withObject:nil afterDelay:delay];
}

- (void)ShowAfterCompletion:(void (^)(BOOL))completion
{
    [self ShowWithAnimation:isAnimated withCompletion:completion];
}

- (void)HideWithAnimation:(BOOL)animated withCompletion:(void (^)(BOOL finished))completion
{
    if (animated)
    {
        backgroundView.alpha = 0.7f;
        toastTextLabel.alpha = 1.0f;
        toastImageView.alpha = 1.0f;
        customView.alpha = 1.0f;
        [UIView animateWithDuration:0.5 animations:^{
            backgroundView.alpha = 0.0f;
            toastTextLabel.alpha = 0.0f;
            toastImageView.alpha = 0.0f;
            customView.alpha = 0.0f;
        }completion:^(BOOL finished){
            // TODO:After animation actions
            if (completion)
                completion(finished);
            if (self.removeFromSuperViewAfterHide)
                [self removeFromSuperview];
        }];
    }
    else
    {
        backgroundView.alpha = 0.0f;
        toastImageView.alpha = 0.0f;
        toastTextLabel.alpha = 0.0f;
        customView.alpha = 0.0f;
        if (completion)
            completion(YES);
        if (self.removeFromSuperViewAfterHide)
            [self removeFromSuperview];
    }
}

- (void)Hide
{
    [self HideWithAnimation:isAnimated withCompletion:nil];
}

- (void)HideAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(Hide) withObject:nil afterDelay:delay];
}

- (void)HideWithCompletion:(void (^)(BOOL))completion
{
    [self HideWithAnimation:isAnimated withCompletion:completion];
}

- (void)setToastText:(NSString *)text
{
    toastTextLabel.text = text;
    [self resizeSubviewsForToastButton];
}

- (void)setToastImage:(UIImage *)image
{
    toastImage = image;
    if (!toastImageView)
    {
        toastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self addSubview:toastImageView];
    }

    [toastImageView setImage:toastImage];
    toastImageView.alpha = 0.0f;
    [self resizeSubviewsForToastButton];
}

- (void)resizeSubviewsForToastButton
{
    if (customView)
        [self resizeCustomView];
    else
    {
        [self resizeTextLabel];
        [self resizeToastImageView];
    }
    [self resizeButtonAndBackgroundView];
}

- (void)resizeCustomView
{
    if (toastImageView)
        [toastImageView removeFromSuperview];
    if (toastTextLabel)
        [toastTextLabel removeFromSuperview];
    [backgroundView removeFromSuperview];

    CGFloat originX, originY, newWidth, newHeight;

    newHeight = customView.frame.size.height;
    newWidth = customView.frame.size.width;
    originX = (initSuperViewWidth - newWidth)/2;
    originY = (initSuperViewHeight - newHeight)/2;

    [self setFrame:CGRectMake(originX, originY, newWidth, newHeight)];
}

- (void)resizeTextLabel
{
    if ([toastTextLabel.text isEqualToString:@""])
        return;
    CGSize textSize = [toastTextLabel.text sizeWithFont:toastTextLabel.font constrainedToSize:CGSizeMake(toastSetView.frame.size.width-100, toastSetView.frame.size.width-100)  lineBreakMode:NSLineBreakByWordWrapping];

    if (textSize.width > self.frame.size.width)
    {
        CGFloat originX, originY;
        if (textSize.height > self.frame.size.height)
        {
            originX = (initSuperViewWidth - textSize.width)/2 - 5;
            originY = (initSuperViewHeight - textSize.height)/2 - 5;
        }
        else
        {
            originX = (initSuperViewWidth - textSize.width)/2 - 5;
            originY = self.frame.origin.y;
        }

        [self setFrame:CGRectMake(originX, originY, textSize.width+10, textSize.height+10)];
        [toastTextLabel setFrame:CGRectMake(5, 5, textSize.width, textSize.height)];
    }
    else
    {
        CGFloat textLabelOriginX = (self.frame.size.width - textSize.width)/2;
        CGFloat textLabelOriginY = (self.frame.size.height - textSize.height)/2;

        [toastTextLabel setFrame:CGRectMake(textLabelOriginX, textLabelOriginY, textSize.width, textSize.height)];
    }
}

- (void)resizeToastImageView
{
    if (!toastImageView)
        return;

    CGFloat newHeight, newWidth, originX, originY, newHeightStartLine;

    if (self.frame.size.height < 41 && self.frame.size.width < 41)
    {
        newHeight = 30 + 40 + 5;
        newWidth = newHeight;
        originX = (initSuperViewWidth - newWidth)/2;
        originY = (initSuperViewHeight - newHeight)/2;
        [self setFrame:CGRectMake(originX, originY, newWidth, newHeight)];
    }
    else
    {
        newHeight = self.frame.size.width + 5;
        newWidth = newHeight;
        originX = (initSuperViewWidth - newWidth)/2;
        originY = (initSuperViewHeight - newHeight)/2;
        [self setFrame:CGRectMake(originX, originY, newWidth, newHeight)];
    }

    newHeightStartLine = (self.frame.size.height - (toastImageView.frame.size.height + toastTextLabel.frame.size.height + 5))/2;

    if (newHeightStartLine > 15)
    {
        newHeight = newHeight-(newHeightStartLine-15)*2;
        originY = (initSuperViewHeight - newHeight)/2;
        [self setFrame:CGRectMake(originX, originY, newWidth, newHeight)];
        newHeightStartLine = 15;
    }

    [toastImageView setFrame:CGRectMake((self.frame.size.width - toastImageView.frame.size.width)/2, newHeightStartLine+2.5, toastImageView.frame.size.width, toastImageView.frame.size.height)];

    [toastTextLabel setFrame:CGRectMake(toastTextLabel.frame.origin.x+5, newHeightStartLine + 7.5 + toastImageView.frame.size.height, toastTextLabel.frame.size.width, toastTextLabel.frame.size.height)];

}

- (void)resizeButtonAndBackgroundView
{
    [toastBtn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backgroundView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)setPosition
{
    if (initWithWindow)
    {
        UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
            {
                CGFloat originX = (initSuperViewWidth - self.frame.size.width)/2;
                CGFloat originY = (initSuperViewHeight - self.frame.size.height)/2;
                [self setFrame:CGRectMake(originX, originY, self.frame.size.width, self.frame.size.height)];
                break;
            }
            case UIInterfaceOrientationPortraitUpsideDown:
            {
                self.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
                CGFloat originX = (initSuperViewWidth - self.frame.size.width)/2;
                CGFloat originY = (initSuperViewHeight - self.frame.size.height)/2;
                [self setFrame:CGRectMake(originX, originY, self.frame.size.width, self.frame.size.height)];
                break;
            }
            case UIInterfaceOrientationLandscapeLeft:
            {
                self.transform = CGAffineTransformMakeRotation((CGFloat)M_PI/2);
                CGFloat originXX = (initSuperViewWidth - self.frame.size.height)/2;
                CGFloat originYY = (initSuperViewHeight - self.frame.size.width)/2;
                [self setFrame:CGRectMake(originYY, originXX, self.frame.size.width, self.frame.size.height)];
                break;
            }
            case UIInterfaceOrientationLandscapeRight:
            {
                self.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI/2);
                CGFloat originXX = (initSuperViewWidth - self.frame.size.height)/2;
                CGFloat originYY = (initSuperViewHeight - self.frame.size.width)/2;
                [self setFrame:CGRectMake(originYY, originXX, self.frame.size.width, self.frame.size.height)];
                break;
            }
            default:
                break;
        }
        return;
    }

    switch (positionMode)
    {
        case ToastTopPositionMode:
        {
            [self setFrame:CGRectMake(self.frame.origin.x, 15, self.frame.size.width, self.frame.size.height)];
            break;
        }
        case ToastCenterPositionMode:
        {
            CGFloat originX = (initSuperViewWidth - self.frame.size.width)/2;
            CGFloat originY = (initSuperViewHeight - self.frame.size.height)/2;
            [self setFrame:CGRectMake(originX, originY, self.frame.size.width, self.frame.size.height)];
            break;
        }
        case ToastBottomPositionMode:
        {
            [self setFrame:CGRectMake(self.frame.origin.x, initSuperViewHeight - self.frame.size.height - 15, self.frame.size.width, self.frame.size.height)];
            break;
        }
        default:
            break;
    }
}

- (void)setTarget:(id)target Action:(SEL)Selector
{
    [toastBtn addTarget:target action:Selector forControlEvents:UIControlEventTouchUpInside];
    [self setMode:ToastButtonBtnMode];
}

- (void)setMode:(ToastButtonMode)mode
{
    toastMode = mode;

    switch (toastMode)
    {
        case ToastButtonBtnMode:
            toastBtn.enabled = YES;
            break;
        case ToastButtonToastMode:
            toastBtn.enabled = NO;
            break;
        case ToastButtonCustomViewMode:
            toastBtn.enabled = YES;
            break;
        default:
            break;
    }
}

- (void)setPositionMode:(ToastPositionMode)mode
{
    positionMode = mode;
    [self resizeSubviewsForToastButton];
}

- (void)setCustomView:(UIView *)view
{
    customView = view;
    [self addSubview:customView];
    customView.alpha = 0.0f;
    [self bringSubviewToFront:toastBtn];
    [self resizeSubviewsForToastButton];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
