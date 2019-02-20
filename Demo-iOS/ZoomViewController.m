//
//  ZoomViewController.m
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

#import "ZoomViewController.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <KSOAnimation/KSOAnimation.h>

@interface ZoomViewController () <UIViewControllerTransitioningDelegate>
@property (strong,nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UIButton *presentButton;
@property (strong,nonatomic) UIButton *dismissButton;

@property (weak,nonatomic) UIView *presentZoomView;
@property (weak,nonatomic) UIView *dismissZoomView;
@end

@implementation ZoomViewController

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (NSString *)title {
    return self.class.displayTitle;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    self.transitioningDelegate = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kstWeakify(self);
    
    self.view.backgroundColor = KDIColorRandomHSB();
    
    self.presentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.presentButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.presentButton.backgroundColor = KDIColorRandomHSB();
    self.presentButton.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    self.presentButton.tintColor = self.presentButton.backgroundColor.KDI_contrastingColor;
    [self.presentButton setTitle:@"Present" forState:UIControlStateNormal];
    [self.presentButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        ZoomViewController *viewController = [[ZoomViewController alloc] initWithNibName:nil bundle:nil];
        
        viewController.presentZoomView = self.presentButton;
        viewController.dismissZoomView = self.dismissButton;
        
        [self presentViewController:viewController animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.presentButton];
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.dismissButton.backgroundColor = KDIColorRandomHSB();
    self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    self.dismissButton.tintColor = self.dismissButton.backgroundColor.KDI_contrastingColor;
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": self.presentButton}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[view]" options:0 metrics:nil views:@{@"view": self.presentButton}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-|" options:0 metrics:nil views:@{@"view": self.dismissButton}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-75-|" options:0 metrics:nil views:@{@"view": self.dismissButton}]];
}

+ (NSString *)displayTitle {
    return @"Zoom";
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    presented.KSO_animationInteractionController = [[KSOPinchInteractionController alloc] initWithPresentedViewController:presented];
    
    return [[KSOZoomAnimationController alloc] initWithZoomView:self.presentZoomView presenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOZoomAnimationController alloc] initWithZoomView:self.dismissZoomView presenting:NO];
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.KSO_animationInteractionController.isInteractive ? self.KSO_animationInteractionController : nil;
}

@end
