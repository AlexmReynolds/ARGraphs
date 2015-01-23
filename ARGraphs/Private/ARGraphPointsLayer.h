//
//  CYCGraphPointsLayer.h
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@interface ARGraphPointsLayer : CALayer

#pragma mark - Data Properties

@property (nonatomic) NSArray *dataPoints;
@property (nonatomic) NSInteger yMax;
@property (nonatomic) NSInteger yMin;
@property (nonatomic) NSInteger xMax;
@property (nonatomic) NSInteger xMin;


@property (nonatomic) CGFloat dotRadius;
@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) BOOL shouldFill;
@property (nonatomic) BOOL shouldSmooth;
@property (nonatomic) BOOL showDots;

@property (nonatomic) CGColorRef lineColor;

@property (nonatomic)  CGFloat topPadding;
@property (nonatomic)  CGFloat bottomPadding;
@property (nonatomic)  CGFloat rightPadding;
@property (nonatomic)  CGFloat leftPadding;

- (void)animate;

@end
