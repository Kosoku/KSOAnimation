//
//  KSOAnimationDefines.h
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

#ifndef __KSO_ANIMATION_DEFINES__
#define __KSO_ANIMATION_DEFINES__

#import <Foundation/Foundation.h>

/**
 Typedef describing the direction of a custom animation. See the individual animation classes for specific information.
 */
typedef NS_ENUM(NSInteger, KSOAnimationDirection) {
    /**
     The animation travels up.
     */
    KSOAnimationDirectionUp,
    /**
     The animation travels down.
     */
    KSOAnimationDirectionDown,
    /**
     The animation travels left.
     */
    KSOAnimationDirectionLeft,
    /**
     The animation travels right.
     */
    KSOAnimationDirectionRight
};

#endif
