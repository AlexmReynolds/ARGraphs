//
//  ARCircleRing.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/9/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ARCircleRingLayer : CALayer
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGColorRef lineColor;
@property (nonatomic) CGColorRef trackColor;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGColorRef minColor;
@property (nonatomic) CGColorRef maxColor;

- (void)animateToPercent:(CGFloat)percent;
@end
