//
//  ARLineGraphYLegendView.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/27/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARLineGraphYLegendView.h"

@implementation ARLineGraphYLegendView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    self.leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
    
    [self.superview addConstraints:@[self.bottomConstraint, self.leftConstraint, self.widthConstraint]];
}

- (void)reloadData
{
    
}

@end
