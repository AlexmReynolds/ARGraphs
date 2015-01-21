//
//  ARGraphBackground.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@import UIKit;
@interface ARGraphBackground : CAGradientLayer
+ (instancetype)gradientWithColor:(CGColorRef)color;

@property (nonatomic) CGColorRef color;
@end
