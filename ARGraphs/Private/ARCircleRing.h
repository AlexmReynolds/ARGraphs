//
//  ARCircleRing.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ARCircleRing : CAShapeLayer
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGColorRef lineColor;
@property (nonatomic) CGFloat animationDuration;

@end
