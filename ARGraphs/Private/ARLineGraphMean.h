//
//  ARLineGraphMean.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/23/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ARLineGraphMean : CAShapeLayer
@property (nonatomic) BOOL animateChanges;
@property (nonatomic) NSInteger yMax;
@property (nonatomic) NSInteger yMin;
@property (nonatomic) CGFloat yMean;

@property (nonatomic) CGColorRef lineColor;

@property (nonatomic)  CGFloat topPadding;
@property (nonatomic)  CGFloat bottomPadding;
@property (nonatomic)  CGFloat rightPadding;
@property (nonatomic)  CGFloat leftPadding;
@end
