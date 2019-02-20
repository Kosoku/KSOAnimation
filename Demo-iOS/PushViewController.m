//
//  PushViewController.m
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

#import "PushViewController.h"
#import "Direction.h"

#import <KSOAnimation/KSOAnimation.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface PushViewController () <UIViewControllerTransitioningDelegate>
@property (strong,nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UIButton *presentButton;
@property (strong,nonatomic) UIButton *dismissButton;
@property (strong,nonatomic) KDIPickerViewButton *directionPickerViewButton;

@property (assign,nonatomic) KSOAnimationDirection direction;
@end

@implementation PushViewController

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (NSString *)title {
    return [self.class displayTitle];
}

- (instancetype)initWithDirection:(KSOAnimationDirection)direction {
    if (!(self = [super initWithNibName:nil bundle:nil]))
        return nil;
    
    _direction = direction;
    
    self.transitioningDelegate = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kstWeakify(self);
    
    self.view.backgroundColor = KDIColorRandomHSB();
    self.view.tintColor = self.view.backgroundColor.KDI_contrastingColor;
    
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 8.0;
    [self.view addSubview:self.stackView];
    
    self.presentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.presentButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.presentButton setTitle:@"Present" forState:UIControlStateNormal];
    [self.presentButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self presentViewController:[[PushViewController alloc] initWithDirection:self.direction] animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addArrangedSubview:self.presentButton];
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addArrangedSubview:self.dismissButton];
    
    self.directionPickerViewButton = [KDIPickerViewButton buttonWithType:UIButtonTypeSystem];
    self.directionPickerViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.directionPickerViewButton KDI_setPickerViewButtonRows:@[[[Direction alloc] initWithDirection:KSOAnimationDirectionUp], [[Direction alloc] initWithDirection:KSOAnimationDirectionDown], [[Direction alloc] initWithDirection:KSOAnimationDirectionLeft], [[Direction alloc] initWithDirection:KSOAnimationDirectionRight]] titleForSelectedRowBlock:^NSString * _Nullable(id<KDIPickerViewButtonRow>  _Nonnull row) {
        return [NSString stringWithFormat:@"Direction: %@", row.pickerViewButtonRowTitle];
    } didSelectRowBlock:^(id<KDIPickerViewButtonRow>  _Nonnull row) {
        kstStrongify(self);
        self.direction = ((Direction *)row).direction;
    }];
    [self.stackView addArrangedSubview:self.directionPickerViewButton];
    
    [NSLayoutConstraint activateConstraints:@[[self.stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor], [self.stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]]];
}

+ (NSString *)displayTitle {
    return @"Push";
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    switch (self.direction) {
        case KSOAnimationDirectionRight:
        case KSOAnimationDirectionLeft:
            presented.KSO_animationInteractionController = [[KSOHorizontalSwipeInteractionController alloc] initWithPresentedViewController:presented];
            break;
        default:
            presented.KSO_animationInteractionController = [[KSOVerticalSwipeInteractionController alloc] initWithPresentedViewController:presented];
            break;
    }
    
    return [[KSOPushAnimationController alloc] initWithDirection:self.direction presenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOPushAnimationController alloc] initWithDirection:self.direction presenting:NO];
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.KSO_animationInteractionController.interactive ? self.KSO_animationInteractionController : nil;
}

@end
