//
//  KSODimmingOverlayPresentationController.m
//  KSOAnimation
//
//  Created by William Towe on 7/27/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "KSODimmingOverlayPresentationController.h"
#import "NSBundle+KSOAnimationPrivateExtensions.h"

#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>

@interface KSODimmingOverlayPresentationController ()
@property (strong,nonatomic) UIView *dimmingView;
@property (strong,nonatomic) UIButton *dismissButton;

@property (assign,nonatomic) KSOAnimationDirection direction;

+ (UIColor *)_defaultOverlayBackgroundColor;
@end

@implementation KSODimmingOverlayPresentationController

#pragma mark *** Subclass Overrides ***
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    return [self initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController direction:KSOAnimationDirectionUp];
}
#pragma mark -
- (void)presentationTransitionWillBegin {
    [self.containerView insertSubview:self.dimmingView atIndex:0];
    [self.containerView setAccessibilityElements:@[self.presentedView,self.dimmingView]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.dimmingView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.dimmingView}]];
    
    kstWeakify(self);
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        kstStrongify(self);
        [self.dimmingView setAlpha:1];
    } completion:nil];
}
- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}
- (void)dismissalTransitionWillBegin {
    kstWeakify(self);
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        kstStrongify(self);
        [self.dimmingView setAlpha:0];
    } completion:nil];
}
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}
#pragma mark -
- (void)containerViewWillLayoutSubviews {
    [self.presentedView setFrame:self.frameOfPresentedViewInContainerView];
    
    switch (self.direction) {
        case KSOAnimationDirectionUp:
            self.dismissButton.frame = CGRectMake(0, CGRectGetHeight(self.presentedView.frame), CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - CGRectGetHeight(self.presentedView.frame));
            break;
        case KSOAnimationDirectionLeft:
            self.dismissButton.frame = CGRectMake(CGRectGetWidth(self.presentedView.frame), 0, CGRectGetWidth(self.containerView.bounds) - CGRectGetWidth(self.presentedView.frame), CGRectGetHeight(self.containerView.bounds));
            break;
        case KSOAnimationDirectionDown:
            self.dismissButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - CGRectGetHeight(self.presentedView.frame));
            break;
        case KSOAnimationDirectionRight:
            self.dismissButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds) - CGRectGetWidth(self.presentedView.frame), CGRectGetHeight(self.containerView.bounds));
            break;
        default:
            break;
    }
}
#pragma mark -
- (CGRect)frameOfPresentedViewInContainerView {
    CGRect retval = {.origin=CGPointZero, .size=[self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:self.containerView.bounds.size]};
    
    switch (self.direction) {
        case KSOAnimationDirectionRight:
            retval.origin.x = CGRectGetWidth(self.containerView.frame) * (1.0 - self.childContentContainerSizePercentage);
            break;
        case KSOAnimationDirectionDown:
            retval.origin.y = CGRectGetHeight(self.containerView.frame) * (1.0 - self.childContentContainerSizePercentage);
            break;
        default:
            break;
    }
    
    return retval;
}
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    CGSize retval = parentSize;
    
    switch (self.direction) {
        case KSOAnimationDirectionUp:
        case KSOAnimationDirectionDown:
            retval.height *= self.childContentContainerSizePercentage;
            break;
        case KSOAnimationDirectionLeft:
        case KSOAnimationDirectionRight:
            retval.width *= self.childContentContainerSizePercentage;
            break;
        default:
            break;
    }
    
    return retval;
}
#pragma mark *** Public Methods ***
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController direction:(KSOAnimationDirection)direction {
    if (!(self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]))
        return nil;
    
    _direction = direction;
    _childContentContainerSizePercentage = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.33 : 0.85;
    _overlayBackgroundColor = [self.class _defaultOverlayBackgroundColor];
    
    return self;
}
#pragma mark Properties
- (void)setOverlayBackgroundColor:(UIColor *)overlayBackgroundColor {
    _overlayBackgroundColor = overlayBackgroundColor ?: [self.class _defaultOverlayBackgroundColor];
}
#pragma mark *** Private Methods ***
+ (UIColor *)_defaultOverlayBackgroundColor; {
    return [UIColor colorWithWhite:0 alpha:0.5];
}
#pragma mark Properties
- (UIView *)dimmingView {
    if (_dimmingView == nil) {
        _dimmingView = [[UIView alloc] initWithFrame:CGRectZero];
        _dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
        _dimmingView.backgroundColor = self.overlayBackgroundColor;
        _dimmingView.alpha = 0.0;
        [_dimmingView addSubview:self.dismissButton];
    }
    return _dimmingView;
}
- (UIButton *)dismissButton {
    if (_dismissButton == nil) {
        kstWeakify(self);
        
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _dismissButton.backgroundColor = UIColor.clearColor;
        _dismissButton.accessibilityLabel = NSLocalizedStringWithDefaultValue(@"com.kosoku.ksoanimation.accessibility.label.dismiss", nil, [NSBundle KSO_animationFrameworkBundle], @"Dismiss", @"Dismiss");
        _dismissButton.accessibilityHint = NSLocalizedStringWithDefaultValue(@"com.kosoku.ksoanimation.accessibility.hint.dismiss", nil, [NSBundle KSO_animationFrameworkBundle], @"Dismiss the presented view", @"Dismiss the presented view");
        [_dismissButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
            kstStrongify(self);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

@end
