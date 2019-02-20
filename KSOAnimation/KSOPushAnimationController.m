//
//  KSOPushAnimationController.m
//  Demo-iOS
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
