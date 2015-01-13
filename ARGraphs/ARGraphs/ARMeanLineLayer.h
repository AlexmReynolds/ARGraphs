//
//  CYCMeanLineLayer.h
//  Cyclr
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class ARGraphDataPoint;

@interface ARMeanLineLayer : CALayer
@property (nonatomic) ARGraphDataPoint *minDataPoint;
@property (nonatomic) ARGraphDataPoint *maxDataPoint;
@property (nonatomic) CGFloat mean;

@property (nonatomic) CGColorRef lineColor;

@property (nonatomic)  CGFloat topPadding;
@property (nonatomic)  CGFloat bottomPadding;
@property (nonatomic)  CGFloat rightPadding;
@property (nonatomic)  CGFloat leftPadding;
@end
