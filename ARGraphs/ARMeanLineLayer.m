//
//  CYCMeanLineLayer.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARMeanLineLayer.h"
#import "ARGraphDataPoint.h"

@implementation ARMeanLineLayer


+ (instancetype)layer
{
    ARMeanLineLayer *layer = [super layer];
    layer.leftPadding = 0;
    layer.rightPadding = 0;
    layer.topPadding = 0;
    layer.bottomPadding = 0;
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.6
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    layer.lineColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    return layer;
}

- (void)setMean:(CGFloat)mean
{
    _mean = mean;
    [self setNeedsDisplay];
}

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (CGFloat)yPositionForDataPointValue:(CGFloat)value inHeight:(CGFloat)height
{
    CGFloat range = self.maxDataPoint.yValue - self.minDataPoint.yValue;
    CGFloat availableHeight = height - self.topPadding - self.bottomPadding;
    CGFloat normalizedDataPointYValue = value - self.minDataPoint.yValue;
    CGFloat percentageOfDataPointToRange =  (normalizedDataPointYValue / range);
    CGFloat inversePercentage = 1.0 - percentageOfDataPointToRange; // Must invert because the greater the value the higher we want it on the chart which is a smaller y value on a iOS coordinate system
    return self.topPadding + inversePercentage * availableHeight;
}

- (void)drawInContext:(CGContextRef)ctx
{
    if(self.minDataPoint == nil || self.maxDataPoint == nil){
        return;
    }
    CGFloat dashLengths[] = {4, 2};
    CGContextSetLineDash(ctx, 0, dashLengths, 2);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor);
    CGFloat yPosition = [self yPositionForDataPointValue:self.mean inHeight:self.bounds.size.height];
    CGContextMoveToPoint(ctx, 0, yPosition);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, yPosition);
    
    CGContextStrokePath(ctx);

}

- (void)dealloc
{
    CGColorRelease(self.lineColor);
}

@end
