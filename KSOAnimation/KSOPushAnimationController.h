//
//  KSOPushAnimationController.h
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

#import <UIKit/UIKit.h>
#import <KSOAnimation/KSOAnimationDefines.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KSOPushAnimationController presents a view controller by having it pushed off screen by the presented view controller.
 */
@interface KSOPushAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/**
 Set and get the duration of the animation.
 
 The default is 0.25 seconds.
 */
@property (assign,nonatomic) NSTimeInterval animationDuration;

/**
 Creates and returns an initialized instance. The direction parameter indicates which direction the presenting view is pushed to.
 
 @param direction The direction to push the presenting view off screen
 @param presenting Whether the view controller is being presented or dismissed
 @return The initialized instance
 */
- (instancetype)initWithDirection:(KSOAnimationDirection)direction presenting:(BOOL)presenting NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
