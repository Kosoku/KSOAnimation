//
//  ZoomViewController.m
//  Demo-iOS
//
//  Created by William Towe on 10/17/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
