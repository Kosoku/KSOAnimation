//
//  KSODimmingOverlayPresentationController.h
//  KSOAnimation
//
//  Created by William Towe on 7/27/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
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
 Typedef for possible presentation directions.
 */
typedef NS_ENUM(NSInteger,KSODimmingOverlayPresentationControllerDirection) {
    /**
     The overlay will be visible on the bottom.
     */
    KSODimmingOverlayPresentationControllerDirectionTop,
    /**
     The overlay will be visible on the right.
     */
    KSODimmingOverlayPresentationControllerDirectionLeft,
    /**
     The overlay will be visible on the top.
     */
    KSODimmingOverlayPresentationControllerDirectionBottom,
    /**
     The overlay will be visible on the left.
     */
    KSODimmingOverlayPresentationControllerDirectionRight
};

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
 The designated initializer.
 
 The additional direction parameter indicates from which direction the presentedViewController is being presented from.
 
 @param presentedViewController The view controller being presented
 @param presentingViewController The view controller that is presenting
 @param direction The direction from which the presentedViewController is being presented from
 @return The initialized instance
 */
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController direction:(KSODimmingOverlayPresentationControllerDirection)direction NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
