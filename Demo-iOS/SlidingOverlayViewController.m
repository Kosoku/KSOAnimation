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

@interface SlidingOverlayViewController () <KDIPickerViewButtonDataSource,UIViewControllerTransitioningDelegate>
@property (weak,nonatomic) IBOutlet KDIPickerViewButton *directionButton;

@property (copy,nonatomic) NSArray<NSNumber *> *directions;

- (NSString *)_titleForDirection:(KSOSlidingAnimationControllerDirection)direction;
@end

@implementation SlidingOverlayViewController

- (NSString *)title {
    return self.class.displayTitle;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setTransitioningDelegate:self];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDirections:@[@(KSOSlidingAnimationControllerDirectionTop),
                          @(KSOSlidingAnimationControllerDirectionLeft),
                          @(KSOSlidingAnimationControllerDirectionBottom),
                          @(KSOSlidingAnimationControllerDirectionRight)]];
    
    [self.directionButton setDataSource:self];
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

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[KSOSlidingAnimationController alloc] initWithDirection:self.directions[[self.directionButton selectedRowInComponent:0]].integerValue presenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOSlidingAnimationController alloc] initWithDirection:self.directions[[self.directionButton selectedRowInComponent:0]].integerValue presenting:NO];
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[KSODimmingOverlayPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting direction:self.directions[[self.directionButton selectedRowInComponent:0]].integerValue];
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
    [self presentViewController:[[SlidingOverlayViewController alloc] init] animated:YES completion:nil];
}
- (IBAction)_dismissAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
