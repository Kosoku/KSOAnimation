//
//  ViewController.m
//  Demo-iOS
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

#import "ViewController.h"
#import "SlidingOverlayViewController.h"
#import "ZoomViewController.h"
#import "PushViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray<Class<DetailViewController>> *viewControllerClasses;
@end

@implementation ViewController

- (NSString *)title {
    return @"KSOAnimation";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewControllerClasses:@[PushViewController.class,
                                     SlidingOverlayViewController.class,
                                     ZoomViewController.class]];
    
    [self setTableView:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.tableView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.tableView}]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllerClasses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *retval = [tableView dequeueReusableCellWithIdentifier:@""];
    
    if (retval == nil) {
        retval = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        
        [retval setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [retval.textLabel setText:[self.viewControllerClasses[indexPath.row] displayTitle]];
    
    return retval;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[(id)self.viewControllerClasses[indexPath.row] alloc] init] animated:YES];
}

@end
