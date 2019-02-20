//
//  KSOHorizontalSwipeInteractionController.m
//  KSOAnimation-iOS
//
//  Created by William Towe on 10/16/18.
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

#import "KSOHorizontalSwipeInteractionController.h"
#import "KSOAnimationInteractionController+KSOAnimationSubclassExtensions.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOHorizontalSwipeInteractionController ()
@property (strong,nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign,nonatomic) BOOL shouldFinishInteraction;
@end

@implementation KSOHorizontalSwipeInteractionController

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
                    CGFloat fraction = fabs(translation.x / CGRectGetWidth(gestureRecognizer.view.frame));
                    
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
