//
//  SlidingOverlayViewController.m
//  KSOAnimation
//
//  Created by William Towe on 8/19/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
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

@property (copy,nonatomic) NSArray<NSNumber *> *directions;
@property (assign,nonatomic) Direction direction;

- (NSString *)_titleForDirection:(KSOSlidingAnimationControllerDirection)direction;
@end

@implementation SlidingOverlayViewController

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (NSString *)title {
    return self.class.displayTitle;
}

- (instancetype)initForPresenting:(BOOL)presenting direction:(Direction)direction {
    if (!(self = [super init]))
        return nil;
    
    _direction = direction;
    
    if (presenting) {
        [self setTransitioningDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:KDIColorRandomRGB()];
    [self.view setTintColor:[self.view.backgroundColor KDI_contrastingColor]];
    
    if (self.presentingViewController == nil) {
        [self.dismissButton setHidden:YES];
    }
    
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
    return [[KSOSlidingAnimationController alloc] initWithDirection:(KSOSlidingAnimationControllerDirection)self.direction presenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOSlidingAnimationController alloc] initWithDirection:(KSOSlidingAnimationControllerDirection)self.direction presenting:NO];
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[KSODimmingOverlayPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting direction:(KSODimmingOverlayPresentationControllerDirection)self.direction];
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
    [self presentViewController:[[SlidingOverlayViewController alloc] initForPresenting:YES direction:self.directions[[self.directionButton selectedRowInComponent:0]].integerValue] animated:YES completion:nil];
}
- (IBAction)_dismissAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
