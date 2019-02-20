//
//  KSOZoomAnimationController.h
//  KSOAnimation-iOS
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

NS_ASSUME_NONNULL_BEGIN

/**
 KSOZoomAnimationController presents a view controller by zooming from a view in the presenting view controller and cross fading with the presented view controller. The dismiss animation zooms into a view in the presenting view controller.
 */
@interface KSOZoomAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/**
 Set and get the duration of the animation.
 
 The default is 0.25 seconds.
 */
@property (assign,nonatomic) NSTimeInterval animationDuration;

/**
 Creates and returns an initialized instance. The *zoomView* indicates the view to zoom from or to depending on whether *presenting* is YES or NO.
 
 @param zoomView The view to zoom from or to
 @param presenting Whether the view controller is being presented or dismissed
 @return The initialized instance
 */
- (instancetype)initWithZoomView:(UIView *)zoomView presenting:(BOOL)presenting NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
