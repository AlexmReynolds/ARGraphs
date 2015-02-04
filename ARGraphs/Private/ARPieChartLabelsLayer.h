//
//  ARPieChartLabelsLayer.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/21/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ARPieChartLabelsLayer : CALayer
@property (nonatomic) NSInteger numberOfSlices;
@property (nonatomic) NSArray *percentages;
@property (nonatomic) CGColorRef labelColor;
@property (nonatomic, strong) NSArray *labelStrings;
@property (nonatomic) CGFloat innerRadiusPercent;
@property (nonatomic) BOOL interalLabels;
@property (nonatomic) CGFloat animationDuration;


@property (nonatomic) CGFloat topPadding;
@property (nonatomic) CGFloat bottomPadding;
@property (nonatomic) CGFloat rightPadding;
@property (nonatomic) CGFloat leftPadding;

- (void)animate;

@end
