//
//  ARCicleTitleLabel.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/6/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARCircleTitleLabel : UILabel
@property (nonatomic, strong) NSLayoutConstraint *left;
@property (nonatomic, strong) NSLayoutConstraint *right;
@property (nonatomic, strong) NSLayoutConstraint *top;
@property (nonatomic, strong) NSLayoutConstraint *bottom;

@end
