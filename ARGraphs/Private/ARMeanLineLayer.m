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

- (void)setYMean:(CGFloat)yMean
{
    _yMean = yMean;
    [self setNeedsDisplay];
}

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (CGFloat)yPositionForYDataPoint:(NSInteger)dataPoint inHeight:(CGFloat)height
{
    CGFloat range = self.yMax - self.yMin;
    CGFloat availableHeight = height - self.topPadding - self.bottomPadding;
    CGFloat normalizedDataPointYValue = dataPoint - self.yMin;
    
    CGFloat percentageOfDataPointToRange =  (normalizedDataPointYValue / range);
    CGFloat inversePercentage = 1.0 - percentageOfDataPointToRange; // Must invert because the greater the value the higher we want it on the chart which is a smaller y value on a iOS coordinate system
    if(range == 0){
        return NSNotFound;
    }else{
        return self.topPadding + inversePercentage * availableHeight;
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat dashLengths[] = {4, 2};
    CGContextSetLineDash(ctx, 0, dashLengths, 2);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor);
    CGFloat yPosition = [self yPositionForYDataPoint:self.yMean inHeight:self.bounds.size.height];
    if(yPosition != NSNotFound){
        CGContextMoveToPoint(ctx, 0, yPosition);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, yPosition);
    }

    
    CGContextStrokePath(ctx);

}

- (void)dealloc
{
    CGColorRelease(self.lineColor);
}

@end
