//
//  KSODimmingOverlayPresentationController.m
//  Collaborate
//
//  Created by William Towe on 7/27/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSODimmingOverlayPresentationController.h"

#import <Stanley/Stanley.h>

@interface KSODimmingOverlayPresentationController ()
@property (strong,nonatomic) UIView *dimmingView;

@property (assign,nonatomic) KSODimmingOverlayPresentationControllerDirection direction;
@property (readonly,nonatomic) CGFloat childContentContainerWidthPercentage;

+ (UIColor *)_defaultOverlayBackgroundColor;
@end

@implementation KSODimmingOverlayPresentationController

#pragma mark *** Subclass Overrides ***
- (void)presentationTransitionWillBegin {
    [self.containerView insertSubview:self.dimmingView atIndex:0];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.dimmingView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.dimmingView}]];
    
    kstWeakify(self);
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        kstStrongify(self);
        [self.dimmingView setAlpha:1];
    } completion:nil];
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
        [_dimmingView removeFromSuperview];
    }
}

- (void)containerViewWillLayoutSubviews {
    [self.presentedView setFrame:self.frameOfPresentedViewInContainerView];
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGRect retval = {.origin=CGPointZero, .size=[self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:self.containerView.bounds.size]};
    
    switch (self.direction) {
        case KSODimmingOverlayPresentationControllerDirectionRight:
            retval.origin.x = CGRectGetWidth(self.containerView.frame) * (1.0 - self.childContentContainerWidthPercentage);
            break;
        case KSODimmingOverlayPresentationControllerDirectionBottom:
            retval.origin.y = CGRectGetHeight(self.containerView.frame) * (1.0 - self.childContentContainerWidthPercentage);
            break;
        default:
            break;
    }
    
    return retval;
}
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(parentSize.width * self.childContentContainerWidthPercentage, parentSize.height);
}
#pragma mark *** Public Methods ***
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController direction:(KSODimmingOverlayPresentationControllerDirection)direction {
    if (!(self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]))
        return nil;
    
    _direction = direction;
    
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
        [_dimmingView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_dimmingView setBackgroundColor:self.overlayBackgroundColor];
        [_dimmingView setAlpha:0];
        kstWeakify(self);
        [_dimmingView addGestureRecognizer:({
            kstStrongify(self);
            UITapGestureRecognizer *retval = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureRecognizerAction:)];
            
            [retval setNumberOfTapsRequired:1];
            
            retval;
        })];
        
        [self setDimmingView:_dimmingView];
    }
    return _dimmingView;
}
- (CGFloat)childContentContainerWidthPercentage {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.33 : 0.85;
}
#pragma mark Actions
- (IBAction)_tapGestureRecognizerAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
