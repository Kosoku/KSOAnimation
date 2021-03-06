//
//  SlidingOverlayViewController.m
//  KSOAnimation
//
//  Created by William Towe on 8/19/17.
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

#import "SlidingOverlayViewController.h"
#import "Direction.h"

#import <KSOAnimation/KSOAnimation.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface SlidingOverlayViewController () <UIViewControllerTransitioningDelegate>
@property (strong,nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UIButton *presentButton;
@property (strong,nonatomic) UIButton *dismissButton;
@property (strong,nonatomic) KDIPickerViewButton *directionPickerViewButton;
@property (strong,nonatomic) UILabel *switchLabel;
@property (strong,nonatomic) UISwitch *switchControl;

@property (assign,nonatomic) KSOAnimationDirection direction;
@property (assign,nonatomic) BOOL usePresentationController;

@end

@implementation SlidingOverlayViewController

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (NSString *)title {
    return self.class.displayTitle;
}

- (instancetype)initWithDirection:(KSOAnimationDirection)direction usePresentationController:(BOOL)usePresentationController {
    if (!(self = [super init]))
        return nil;
    
    _direction = direction;
    _usePresentationController = usePresentationController;
    
    self.transitioningDelegate = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kstWeakify(self);
    
    self.view.backgroundColor = KDIColorRandomRGB();
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
        SlidingOverlayViewController *viewController = [[SlidingOverlayViewController alloc] initWithDirection:self.direction usePresentationController:self.usePresentationController];
        
        [self presentViewController:viewController animated:YES completion:nil];
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
    
    UIStackView *switchStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    
    switchStackView.translatesAutoresizingMaskIntoConstraints = NO;
    switchStackView.axis = UILayoutConstraintAxisHorizontal;
    switchStackView.spacing = 8.0;
    
    [self.stackView addArrangedSubview:switchStackView];
    
    self.switchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.switchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.switchLabel.textColor = self.view.tintColor;
    self.switchLabel.text = @"Use Presentation Controller";
    [switchStackView addArrangedSubview:self.switchLabel];
    
    self.switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.switchControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.switchControl KDI_addBlock:^(UISwitch * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        self.usePresentationController = control.isOn;
    } forControlEvents:UIControlEventValueChanged];
    [switchStackView addArrangedSubview:self.switchControl];
    
    [NSLayoutConstraint activateConstraints:@[[self.stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor], [self.stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]]];
}

+ (NSString *)displayTitle {
    return @"Sliding Overlay";
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    switch (self.direction) {
        case KSOAnimationDirectionUp:
        case KSOAnimationDirectionDown:
            presented.KSO_animationInteractionController = [[KSOVerticalSwipeInteractionController alloc] initWithPresentedViewController:presented];
            break;
        default:
            presented.KSO_animationInteractionController = [[KSOHorizontalSwipeInteractionController alloc] initWithPresentedViewController:presented];
            break;
    }
    
    return [[KSOSlidingAnimationController alloc] initWithDirection:self.direction presenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOSlidingAnimationController alloc] initWithDirection:self.direction presenting:NO];
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self.usePresentationController ? [[KSODimmingOverlayPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting direction:self.direction] : nil;
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.KSO_animationInteractionController.isInteractive ? self.KSO_animationInteractionController : nil;
}

@end
