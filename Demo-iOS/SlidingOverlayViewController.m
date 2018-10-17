//
//  SlidingOverlayViewController.m
//  KSOAnimation
//
//  Created by William Towe on 8/19/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "SlidingOverlayViewController.h"

#import <KSOAnimation/KSOAnimation.h>
#import <Ditko/Ditko.h>

@interface SlidingOverlayViewController () <KDIPickerViewButtonDataSource,KDIPickerViewButtonDelegate,UIViewControllerTransitioningDelegate>
@property (weak,nonatomic) IBOutlet KDIPickerViewButton *directionButton;
@property (weak,nonatomic) IBOutlet UIButton *dismissButton;
@property (weak,nonatomic) IBOutlet UILabel *customLabel;
@property (weak,nonatomic) IBOutlet UISwitch *switchControl;

@property (copy,nonatomic) NSArray<NSNumber *> *directions;
@property (assign,nonatomic) Direction direction;
@property (assign,nonatomic) BOOL shouldUseCustomPresentation;
@property (strong,nonatomic) KSOHorizontalSwipeInteractionController *interactionController;

- (NSString *)_titleForDirection:(KSOSlidingAnimationControllerDirection)direction;
@end

@implementation SlidingOverlayViewController

- (UIModalPresentationStyle)modalPresentationStyle {
    return self.shouldUseCustomPresentation ? UIModalPresentationCustom : UIModalPresentationFormSheet;
}

- (NSString *)title {
    return self.class.displayTitle;
}

- (instancetype)initForPresenting:(BOOL)presenting custom:(BOOL)custom direction:(Direction)direction {
    if (!(self = [super init]))
        return nil;
    
    _direction = direction;
    _shouldUseCustomPresentation = custom;
    
    if (presenting &&
        custom) {
        
        [self setTransitioningDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:KDIColorRandomRGB()];
    
    UIColor *contrastingColor = [self.view.backgroundColor KDI_contrastingColor];
    
    [self.view setTintColor:contrastingColor];
    [self.customLabel setTextColor:contrastingColor];
    
    [self setDirections:@[@(KSOSlidingAnimationControllerDirectionTop),
                          @(KSOSlidingAnimationControllerDirectionLeft),
                          @(KSOSlidingAnimationControllerDirectionBottom),
                          @(KSOSlidingAnimationControllerDirectionRight)]];
    
    [self.directionButton setDataSource:self];
    [self.directionButton setDelegate:self];
}

+ (NSString *)displayTitle {
    return @"Sliding Overlay";
}

- (NSInteger)pickerViewButton:(KDIPickerViewButton *)pickerViewButton numberOfRowsInComponent:(NSInteger)component {
    return self.directions.count;
}
- (NSString *)pickerViewButton:(KDIPickerViewButton *)pickerViewButton titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self _titleForDirection:self.directions[row].integerValue];
}

- (NSString *)pickerViewButton:(KDIPickerViewButton *)pickerViewButton titleForSelectedRows:(NSArray<NSNumber *> *)selectedRows {
    return [NSString stringWithFormat:@"Direction: %@",[self _titleForDirection:self.directions[selectedRows.firstObject.integerValue].integerValue]];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    switch (self.direction) {
        case DirectionTop:
        case DirectionBottom:
            presented.KSO_animationInteractionController = [[KSOVerticalSwipeInteractionController alloc] initWithPresentedViewController:presented];
            break;
        default:
            presented.KSO_animationInteractionController = [[KSOHorizontalSwipeInteractionController alloc] initWithPresentedViewController:presented];
            break;
    }
    
    return [[KSOSlidingAnimationController alloc] initWithDirection:(KSOSlidingAnimationControllerDirection)self.direction presenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOSlidingAnimationController alloc] initWithDirection:(KSOSlidingAnimationControllerDirection)self.direction presenting:NO];
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[KSODimmingOverlayPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting direction:(KSODimmingOverlayPresentationControllerDirection)self.direction];
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.KSO_animationInteractionController.isInteractive ? self.KSO_animationInteractionController : nil;
}


- (NSString *)_titleForDirection:(KSOSlidingAnimationControllerDirection)direction; {
    switch (direction) {
        case KSOSlidingAnimationControllerDirectionRight:
            return @"Right";
        case KSOSlidingAnimationControllerDirectionBottom:
            return @"Bottom";
        case KSOSlidingAnimationControllerDirectionLeft:
            return @"Left";
        case KSOSlidingAnimationControllerDirectionTop:
            return @"Top";
    }
}

- (IBAction)_presentAction:(id)sender {
    [self.view endEditing:YES];
    [self presentViewController:[[SlidingOverlayViewController alloc] initForPresenting:YES custom:self.switchControl.isOn direction:self.directions[[self.directionButton selectedRowInComponent:0]].integerValue] animated:YES completion:nil];
}
- (IBAction)_dismissAction:(id)sender {
    [self.view endEditing:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
