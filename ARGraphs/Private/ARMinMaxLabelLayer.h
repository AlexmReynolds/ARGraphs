//
//  CYCMinMaxLabelLayer.h
//  Cyclr
//
//  Created by Alex Reynolds on 1/9/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class ARGraphDataPoint;

@interface ARMinMaxLabelLayer : CALayer
@property (nonatomic) ARGraphDataPoint *minDataPoint;
@property (nonatomic) ARGraphDataPoint *maxDataPoint;

@property (nonatomic) CGColorRef lineColor;

@property (nonatomic)  CGFloat topPadding;
@property (nonatomic)  CGFloat bottomPadding;
@property (nonatomic)  CGFloat rightPadding;
@property (nonatomic)  CGFloat leftPadding;
@end
