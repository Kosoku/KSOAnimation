//
//  KSOPushAnimationController.m
//  Demo-iOS
//
//  Created by William Towe on 10/17/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOPushAnimationController.h"

@interface KSOPushAnimationController ()
@property (assign,nonatomic) KSOAnimationDirection direction;
@property (assign,nonatomic,getter=isPresenting) BOOL presenting;

- (CGAffineTransform)_transformForToSnapshotViewWithFrame:(CGRect)frame;
- (CGAffineTransform)_transformForFromSnapshotViewWithFrame:(CGRect)frame;
@end

@implementation KSOPushAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect fromFrame = [transitionContext finalFrameForViewController:fromViewController];
    UIView *toSnapshotView = [toViewController.view snapshotViewAfterScreenUpdates:YES];
    UIView *fromSnapshotView = [fromViewController.view snapshotViewAfterScreenUpdates:YES];
    
    if (CGRectIsEmpty(toFrame)) {
        toFrame = toViewController.view.frame;
    }
    if (CGRectIsEmpty(fromFrame)) {
        fromFrame = fromViewController.view.frame;
    }
    
    if (self.isPresenting) {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromSnapshotView];
        [transitionContext.containerView addSubview:toSnapshotView];
    }
    else {
        [transitionContext.containerView addSubview:fromSnapshotView];
        [transitionContext.containerView addSubview:toSnapshotView];
    }
    
    toViewController.view.hidden = YES;
    fromViewController.view.hidden = YES;
    
    toSnapshotView.frame = toFrame;
    fromSnapshotView.frame = fromFrame;
    
    toSnapshotView.transform = [self _transformForToSnapshotViewWithFrame:toFrame];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toSnapshotView.transform = CGAffineTransformIdentity;
        fromSnapshotView.transform = [self _transformForFromSnapshotViewWithFrame:fromFrame];
    } completion:^(BOOL finished) {
        [toSnapshotView removeFromSuperview];
        [fromSnapshotView removeFromSuperview];
        
        toViewController.view.hidden = NO;
        fromViewController.view.hidden = NO;
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (instancetype)initWithDirection:(KSOAnimationDirection)direction presenting:(BOOL)presenting {
    if (!(self = [super init]))
        return nil;
    
    _animationDuration = 0.25;
    _direction = direction;
    _presenting = presenting;
    
    return self;
}

- (CGAffineTransform)_transformForToSnapshotViewWithFrame:(CGRect)frame; {
    CGAffineTransform retval = CGAffineTransformMakeTranslation(1.0, 1.0);
    
    if (self.isPresenting) {
        switch (self.direction) {
            case KSOAnimationDirectionUp:
                retval.ty = CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionDown:
                retval.ty = -CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionLeft:
                retval.tx = CGRectGetWidth(frame);
                break;
            case KSOAnimationDirectionRight:
                retval.tx = -CGRectGetWidth(frame);
                break;
        }
    }
    else {
        switch (self.direction) {
            case KSOAnimationDirectionUp:
                retval.ty = -CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionDown:
                retval.ty = CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionLeft:
                retval.tx = -CGRectGetWidth(frame);
                break;
            case KSOAnimationDirectionRight:
                retval.tx = CGRectGetWidth(frame);
                break;
        }
    }
    
    return retval;
}
- (CGAffineTransform)_transformForFromSnapshotViewWithFrame:(CGRect)frame; {
    CGAffineTransform retval = CGAffineTransformMakeTranslation(1.0, 1.0);
    
    if (self.isPresenting) {
        switch (self.direction) {
            case KSOAnimationDirectionUp:
                retval.ty = -CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionDown:
                retval.ty = CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionLeft:
                retval.tx = -CGRectGetWidth(frame);
                break;
            case KSOAnimationDirectionRight:
                retval.tx = CGRectGetWidth(frame);
                break;
        }
    }
    else {
        switch (self.direction) {
            case KSOAnimationDirectionUp:
                retval.ty = CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionDown:
                retval.ty = -CGRectGetHeight(frame);
                break;
            case KSOAnimationDirectionLeft:
                retval.tx = CGRectGetWidth(frame);
                break;
            case KSOAnimationDirectionRight:
                retval.tx = -CGRectGetWidth(frame);
                break;
        }
    }
    
    return retval;
}

@end
