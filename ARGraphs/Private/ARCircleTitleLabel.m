//
//  ARCicleTitleLabel.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/6/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARCircleTitleLabel.h"

@implementation ARCircleTitleLabel

- (instancetype)init{
    self = [super init];
    if(self){
        self.font = [UIFont fontWithName:@"Helvetica" size:22];
        self.text = @"FARTS";
        self.textColor = [UIColor darkGrayColor];
        self.minimumScaleFactor = 0.5;
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview){
        [self createConstraints];
    }
}

- (void)createConstraints
{
    _left = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    _right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    _bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    _top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.superview addConstraints:@[_left, _right, _bottom]];
}
@end
