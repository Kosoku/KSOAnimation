//
//  UIViewController+KSOAnimationExtensions.h
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

#import <KSOAnimation/KSOAnimationInteractionController.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Category on UIViewController allowing association of a KSOAnimationInteractionController subclass with a view controller instance.
 */
@interface UIViewController (KSOAnimationExtensions)

/**
 Set and get the KSOAnimationInteractionController subclass associated with the receiver.
 */
@property (strong,nonatomic,nullable) __kindof KSOAnimationInteractionController *KSO_animationInteractionController;

@end

NS_ASSUME_NONNULL_END
