//
//  KSOSlidingAnimationController.h
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

/**
 KSOSlidingAnimationController presents a view controller by sliding it from offscreen to its final position based on the provided direction parameter.
 */
@interface KSOSlidingAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/**
 Set and get the duration of the animation.
 
 The default is 0.25 seconds.
 */
@property (assign,nonatomic) NSTimeInterval animationDuration;

/**
 The designated initializer.
 
 The direction indicates from which direction the view controller is being presented from.
 
 @param direction The direction to present from
 @param presenting Whether the view controller is being presented or dismissed
 @return The initialized instance
 */
- (instancetype)initWithDirection:(KSOAnimationDirection)direction presenting:(BOOL)presenting NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
