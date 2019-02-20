//
//  Direction.m
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

#import "Direction.h"

@interface Direction ()
@property (readwrite,assign,nonatomic) KSOAnimationDirection direction;
@end

@implementation Direction

- (instancetype)initWithDirection:(KSOAnimationDirection)direction {
    if (!(self = [super init]))
        return nil;
    
    _direction = direction;
    
    return self;
}

- (NSString *)pickerViewButtonRowTitle {
    switch (self.direction) {
        case KSOAnimationDirectionRight:
            return @"Right";
        case KSOAnimationDirectionDown:
            return @"Down";
        case KSOAnimationDirectionLeft:
            return @"Left";
        case KSOAnimationDirectionUp:
            return @"Up";
    }
}

@end
