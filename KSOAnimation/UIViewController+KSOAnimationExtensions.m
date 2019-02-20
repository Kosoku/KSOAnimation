//
//  UIViewController+KSOAnimationExtensions.m
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

#import "UIViewController+KSOAnimationExtensions.h"

#import <objc/runtime.h>

@implementation UIViewController (KSOAnimationExtensions)

static void const *kKSO_animationInteractionControllerKey = &kKSO_animationInteractionControllerKey;

@dynamic KSO_animationInteractionController;
- (KSOAnimationInteractionController *)KSO_animationInteractionController {
    return objc_getAssociatedObject(self, kKSO_animationInteractionControllerKey);
}
- (void)setKSO_animationInteractionController:(__kindof KSOAnimationInteractionController *)KSO_animationInteractionController {
    objc_setAssociatedObject(self, kKSO_animationInteractionControllerKey, KSO_animationInteractionController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
