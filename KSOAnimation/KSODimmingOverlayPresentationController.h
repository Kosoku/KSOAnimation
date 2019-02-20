//
//  KSODimmingOverlayPresentationController.h
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

#import <UIKit/UIKit.h>
#import <KSOAnimation/KSOAnimationDefines.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KSODimmingOverlayPresentationController presents a view controller with a dimming view inserted below the presented view controller with its background color set to overlayBackgroundColor.
 */
@interface KSODimmingOverlayPresentationController : UIPresentationController

/**
 The percentage of width or height reserved for the overlay view. It is applied as a percentage of the width or height of the entire screen.
 
 The default is 0.33 on an iPad and 0.85 on an iPhone.
 */
@property (assign,nonatomic) CGFloat childContentContainerSizePercentage;
/**
 The background color of the overlay view.
 
 The default is [UIColor colorWithWhite:0 alpha:0.5].
 */
@property (strong,nonatomic,null_resettable) UIColor *overlayBackgroundColor;

/**
 Creates and returns an initialized instance. The additional direction parameter indicates from which direction the presentedViewController is being presented from.
 
 @param presentedViewController The view controller being presented
 @param presentingViewController The view controller that is presenting
 @param direction The direction from which the presentedViewController is being presented from
 @return The initialized instance
 */
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController direction:(KSOAnimationDirection)direction NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
