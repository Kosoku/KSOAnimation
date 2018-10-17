//
//  KSOVerticalSwipeInteractionController.m
//  KSOAnimation-iOS
//
//  Created by William Towe on 10/16/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOVerticalSwipeInteractionController.h"
#import "KSOAnimationInteractionController+KSOAnimationSubclassExtensions.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOVerticalSwipeInteractionController ()
@property (strong,nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign,nonatomic) BOOL shouldFinishInteraction;
@end

@implementation KSOVerticalSwipeInteractionController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController {
    if (!(self = [super initWithPresentedViewController:presentedViewController]))
        return nil;
    
    kstWeakify(self);
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:NULL];
    [_panGestureRecognizer KDI_addBlock:^(UIPanGestureRecognizer * _Nonnull gestureRecognizer) {
        kstStrongify(self);
        CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                self.interactive = YES;
                [self.presentedViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                break;
            case UIGestureRecognizerStateChanged:
                if (self.isInteractive) {
                    CGFloat fraction = fabs(translation.y / CGRectGetHeight(gestureRecognizer.view.frame));
                    
                    fraction = KSTBoundedValue(fraction, 0.0, 1.0);
                    
                    self.shouldFinishInteraction = fraction > 0.5;
                    
                    if (fraction >= 1.0) {
                        fraction = 0.99;
                    }
                    
                    [self updateInteractiveTransition:fraction];
                }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
                if (self.isInteractive) {
                    self.interactive = NO;
                    
                    if (!self.shouldFinishInteraction ||
                        gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                        
                        [self cancelInteractiveTransition];
                    }
                    else {
                        [self finishInteractiveTransition];
                    }
                }
                break;
            default:
                break;
        }
    }];
    [presentedViewController.view addGestureRecognizer:_panGestureRecognizer];
    
    return self;
}

@end
