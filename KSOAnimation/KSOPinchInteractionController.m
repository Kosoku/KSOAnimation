//
//  KSOPinchInteractionController.m
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

#import "KSOPinchInteractionController.h"
#import "KSOAnimationInteractionController+KSOAnimationSubclassExtensions.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOPinchInteractionController ()
@property (strong,nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (assign,nonatomic) BOOL shouldFinishInteraction;
@property (assign,nonatomic) CGFloat startScale;
@end

@implementation KSOPinchInteractionController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController {
    if (!(self = [super initWithPresentedViewController:presentedViewController]))
        return nil;
    
    kstWeakify(self);
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:nil action:NULL];
    [_pinchGestureRecognizer KDI_addBlock:^(UIPinchGestureRecognizer * _Nonnull gestureRecognizer) {
        kstStrongify(self);
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                self.interactive = YES;
                self.startScale = gestureRecognizer.scale;
                
                [self.presentedViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                break;
            case UIGestureRecognizerStateChanged: {
                CGFloat fraction = 1.0 - gestureRecognizer.scale / self.startScale;
                
                self.shouldFinishInteraction = fraction > 0.5;
                
                [self updateInteractiveTransition:fraction];
            }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
                self.interactive = NO;
                
                if (!self.shouldFinishInteraction ||
                    gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
                break;
            default:
                break;
        }
    }];
    [presentedViewController.view addGestureRecognizer:_pinchGestureRecognizer];
    
    return self;
}

@end
