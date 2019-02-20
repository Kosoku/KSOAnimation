//
//  KSOZoomAnimationController.m
//  KSOAnimation-iOS
//
//  Created by William Towe on 10/17/18.
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
