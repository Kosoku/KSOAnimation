//
//  KSOZoomAnimationController.h
//  KSOAnimation-iOS
//
//  Created by William Towe on 10/17/18.
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
