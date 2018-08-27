//
//  KSODimmingOverlayPresentationController.m
//  KSOAnimation
//
//  Created by William Towe on 7/27/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSODimmingOverlayPresentationController.h"
#import "NSBundle+KSOAnimationPrivateExtensions.h"

#import <Stanley/Stanley.h>

@interface KSODimmingOverlayPresentationController ()
@property (strong,nonatomic) UIView *dimmingView;
@property (strong,nonatomic) UIButton *dismissButton;

@property (assign,nonatomic) KSODimmingOverlayPresentationControllerDirection direction;

+ (UIColor *)_defaultOverlayBackgroundColor;
@end

@implementation KSODimmingOverlayPresentationController

#pragma mark *** Subclass Overrides ***
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    return [self initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController direction:KSODimmingOverlayPresentationControllerDirectionTop];
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
        case KSODimmingOverlayPresentationControllerDirectionTop:
            self.dismissButton.frame = CGRectMake(0, CGRectGetHeight(self.presentedView.frame), CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - CGRectGetHeight(self.presentedView.frame));
            break;
        case KSODimmingOverlayPresentationControllerDirectionLeft:
            self.dismissButton.frame = CGRectMake(CGRectGetWidth(self.presentedView.frame), 0, CGRectGetWidth(self.containerView.bounds) - CGRectGetWidth(self.presentedView.frame), CGRectGetHeight(self.containerView.bounds));
            break;
        case KSODimmingOverlayPresentationControllerDirectionBottom:
            self.dismissButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - CGRectGetHeight(self.presentedView.frame));
            break;
        case KSODimmingOverlayPresentationControllerDirectionRight:
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
        case KSODimmingOverlayPresentationControllerDirectionRight:
            retval.origin.x = CGRectGetWidth(self.containerView.frame) * (1.0 - self.childContentContainerSizePercentage);
            break;
        case KSODimmingOverlayPresentationControllerDirectionBottom:
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
        case KSODimmingOverlayPresentationControllerDirectionTop:
        case KSODimmingOverlayPresentationControllerDirectionBottom:
            retval.height *= self.childContentContainerSizePercentage;
            break;
        case KSODimmingOverlayPresentationControllerDirectionLeft:
        case KSODimmingOverlayPresentationControllerDirectionRight:
            retval.width *= self.childContentContainerSizePercentage;
            break;
        default:
            break;
    }
    
    return retval;
}
#pragma mark *** Public Methods ***
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController direction:(KSODimmingOverlayPresentationControllerDirection)direction {
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
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _dismissButton.backgroundColor = UIColor.clearColor;
        _dismissButton.accessibilityLabel = NSLocalizedStringWithDefaultValue(@"com.kosoku.ksoanimation.accessibility.label.dismiss", nil, [NSBundle KSO_animationFrameworkBundle], @"Dismiss", @"Dismiss");
        _dismissButton.accessibilityHint = NSLocalizedStringWithDefaultValue(@"com.kosoku.ksoanimation.accessibility.hint.dismiss", nil, [NSBundle KSO_animationFrameworkBundle], @"Dismiss the presented view", @"Dismiss the presented view");
        [_dismissButton addTarget:self action:@selector(_dismissButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}
#pragma mark Actions
- (IBAction)_dismissButtonAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
