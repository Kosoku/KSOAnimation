//
//  KSOAnimationInteractionController.h
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
