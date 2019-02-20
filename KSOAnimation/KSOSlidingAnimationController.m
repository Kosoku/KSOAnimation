//
//  KSOSlidingAnimationController.m
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

#import "KSOSlidingAnimationController.h"

#import <Stanley/Stanley.h>

@interface KSOSlidingAnimationController ()
@property (assign,nonatomic) KSOAnimationDirection direction;
@property (assign,nonatomic,getter=isPresenting) BOOL presenting;
@end

@implementation KSOSlidingAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *viewController = [transitionContext viewControllerForKey:self.isPresenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey];
    
    if (self.isPresenting) {
        [transitionContext.containerView addSubview:viewController.view];
    }
    
    CGRect presentedFrame = [transitionContext finalFrameForViewController:viewController];
    CGRect dismissedFrame = presentedFrame;
    
    switch (self.direction) {
        case KSOAnimationDirectionUp:
            dismissedFrame.origin.y = -CGRectGetHeight(presentedFrame);
            break;
        case KSOAnimationDirectionLeft:
            dismissedFrame.origin.x = -CGRectGetWidth(presentedFrame);
            break;
        case KSOAnimationDirectionDown:
            dismissedFrame.origin.y = CGRectGetHeight(transitionContext.containerView.frame);
            break;
        case KSOAnimationDirectionRight:
            dismissedFrame.origin.x = CGRectGetWidth(transitionContext.containerView.frame);
            break;
    }
    
    CGRect initialFrame = self.isPresenting ? dismissedFrame : presentedFrame;
    CGRect finalFrame = self.isPresenting ? presentedFrame : dismissedFrame;
    
    [viewController.view setFrame:initialFrame];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        [viewController.view setFrame:finalFrame];
    } completion:^(BOOL finished) {
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

@end
