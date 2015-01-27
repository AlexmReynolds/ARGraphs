//
//  ARPieChartLayer.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ARPieChartAnimationTypes.h"


@interface ARPieChartLayer : CALayer

@property (nonatomic) CGFloat sliceGutterWidth;
@property (nonatomic) CGFloat innerRadiusPercent;
@property (nonatomic) ARSliceAnimation animationType;
@property (nonatomic) CGFloat topPadding;
@property (nonatomic) CGFloat bottomPadding;
@property (nonatomic) CGFloat rightPadding;
@property (nonatomic) CGFloat leftPadding;

@property (nonatomic) CGColorRef fillBaseColor;


@property (nonatomic) NSInteger numberOfSlices;
@property (nonatomic) NSArray *percentages;
@property (nonatomic) NSArray *colors;


- (void)animate;

@end
