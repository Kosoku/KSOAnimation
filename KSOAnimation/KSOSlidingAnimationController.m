//
//  KSOSlidingAnimationController.m
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

#import "KSOSlidingAnimationController.h"

#import <Stanley/Stanley.h>

@interface KSOSlidingAnimationController ()
@property (assign,nonatomic) KSOSlidingAnimationControllerDirection direction;
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
        case KSOSlidingAnimationControllerDirectionTop:
            dismissedFrame.origin.y = -CGRectGetHeight(presentedFrame);
            break;
        case KSOSlidingAnimationControllerDirectionLeft:
            dismissedFrame.origin.x = -CGRectGetWidth(presentedFrame);
            break;
        case KSOSlidingAnimationControllerDirectionBottom:
            dismissedFrame.origin.y = CGRectGetHeight(transitionContext.containerView.frame);
            break;
        case KSOSlidingAnimationControllerDirectionRight:
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

- (instancetype)initWithDirection:(KSOSlidingAnimationControllerDirection)direction presenting:(BOOL)presenting {
    if (!(self = [super init]))
        return nil;
    
    _animationDuration = 0.25;
    _direction = direction;
    _presenting = presenting;
    
    return self;
}

@end
