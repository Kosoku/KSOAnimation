//
//  KSOAnimationInteractionController.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KSOAnimationInteractionController is the base class for controllers that manage interactive dismissal. You should set them on the presented view controller using the setKSO_animationInteractionController: method within the animationControllerForPresentedController:sourceController: delegate method. You should return the same instance from the interactionControllerForDismissal: delegate method only when the isInteractive method returns YES, which means its gesture recognizer triggered to begin the interactive dismissal.
 
 See the demo app for examples.
 */
@interface KSOAnimationInteractionController : UIPercentDrivenInteractiveTransition

/**
 Get the view controller being presented.
 */
@property (readonly,weak,nonatomic) UIViewController *presentedViewController;
/**
 Get whether the receiver is currently interactive, which means its gesture recognizer has triggered.
 */
@property (readonly,assign,nonatomic,getter=isInteractive) BOOL interactive;

/**
 Creates and returns an initialized instance and attaches any related gesture recognizers to *presentedViewController* view.
 
 @param presentedViewController The view controller being presented
 @return The initialized instance
 */
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
