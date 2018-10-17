//
//  KSOAnimationInteractionController+KSOAnimationSubclassExtensions.h
//  KSOAnimation-iOS
//
//  Created by William Towe on 10/16/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//

#import <KSOAnimation/KSOAnimationInteractionController.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSOAnimationInteractionController (KSOAnimationSubclassExtensions)

@property (readwrite,assign,nonatomic,getter=isInteractive) BOOL interactive;

@end

NS_ASSUME_NONNULL_END
