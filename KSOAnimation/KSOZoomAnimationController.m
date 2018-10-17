//
//  KSOZoomAnimationController.m
//  KSOAnimation-iOS
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

#import "KSOZoomAnimationController.h"

#import <Stanley/Stanley.h>

@interface KSOZoomAnimationController ()
@property (readwrite,strong,nonatomic) UIView *zoomView;
@property (assign,nonatomic,getter=isPresenting) BOOL presenting;
@end

@implementation KSOZoomAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(self.zoomView != nil, @"zoom view cannot be nil!");
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect fromFrame = [transitionContext finalFrameForViewController:fromViewController];
    
    if (self.isPresenting) {
        UIView *fromZoomViewSnapshot = [self.zoomView snapshotViewAfterScreenUpdates:YES];
        UIView *toSnapshotView = [toViewController.view snapshotViewAfterScreenUpdates:YES];
        CGRect zoomFrame = [transitionContext.containerView convertRect:self.zoomView.bounds fromView:self.zoomView];
        
        [transitionContext.containerView addSubview:fromZoomViewSnapshot];
        [transitionContext.containerView addSubview:toSnapshotView];
        [transitionContext.containerView addSubview:toViewController.view];
        
        fromZoomViewSnapshot.frame = zoomFrame;
        
        toSnapshotView.frame = zoomFrame;
        toSnapshotView.alpha = 0.0;
        
        toViewController.view.frame = toFrame;
        toViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromZoomViewSnapshot.alpha = 0.0;
            fromZoomViewSnapshot.frame = toFrame;
            
            toSnapshotView.frame = toFrame;
            toSnapshotView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [fromZoomViewSnapshot removeFromSuperview];
            [toSnapshotView removeFromSuperview];
            
            toViewController.view.alpha = 1.0;
            
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    else {
        UIView *fromViewSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:YES];
        UIView *toViewSnapshot = [self.zoomView snapshotViewAfterScreenUpdates:YES];
        CGRect zoomFrame = [transitionContext.containerView convertRect:self.zoomView.bounds fromView:self.zoomView];
        
        [transitionContext.containerView insertSubview:toViewSnapshot aboveSubview:toViewController.view];
        [transitionContext.containerView insertSubview:fromViewSnapshot aboveSubview:toViewSnapshot];
        
        fromViewController.view.alpha = 0.0;
        
        toViewSnapshot.frame = fromFrame;
        toViewSnapshot.alpha = 0.0;
        
        fromViewSnapshot.frame = fromFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewSnapshot.frame = zoomFrame;
            fromViewSnapshot.alpha = 0.0;
            
            toViewSnapshot.frame = zoomFrame;
            toViewSnapshot.alpha = 1.0;
        } completion:^(BOOL finished) {
            [fromViewSnapshot removeFromSuperview];
            [toViewSnapshot removeFromSuperview];
            
            if (transitionContext.transitionWasCancelled) {
                fromViewController.view.alpha = 1.0;
            }
            
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}

- (instancetype)initWithZoomView:(UIView *)zoomView presenting:(BOOL)presenting {
    if (!(self = [super init]))
        return nil;
    
    _animationDuration = 0.25;
    _zoomView = zoomView;
    _presenting = presenting;
    
    return self;
}

@end
