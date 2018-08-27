//
//  KSOSlidingAnimationController.h
//  KSOAnimation
//
//  Created by William Towe on 7/27/17.
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

/**
 Typedef for possible animation directions.
 */
typedef NS_ENUM(NSInteger,KSOSlidingAnimationControllerDirection) {
    /**
     The animation starts from the top.
     */
    KSOSlidingAnimationControllerDirectionTop,
    /**
     The animation starts from the left.
     */
    KSOSlidingAnimationControllerDirectionLeft,
    /**
     The animation starts from the bottom.
     */
    KSOSlidingAnimationControllerDirectionBottom,
    /**
     The animation starts from the right.
     */
    KSOSlidingAnimationControllerDirectionRight
};

/**
 KSOSlidingAnimationController presents a view controller by sliding it from offscreen to its final position based on the provided direction parameter.
 */
@interface KSOSlidingAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/**
 Set and get the duration of the animation.
 
 The default is 0.28 seconds.
 */
@property (assign,nonatomic) NSTimeInterval animationDuration;

/**
 The designated initializer.
 
 The direction indicates from which direction the view controller is being presented from.
 
 @param direction The direction to present from
 @param presenting Whether the view controller is being presented or dismissed
 @return The initialized instance
 */
- (instancetype)initWithDirection:(KSOSlidingAnimationControllerDirection)direction presenting:(BOOL)presenting NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
