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


- (instancetype)init
{
    self = [super init];
    self.leftPadding = 0;
    self.rightPadding = 0;
    self.topPadding = 0;
    self.bottomPadding = 0;
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.6
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    _lineColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    return self;
}

- (void)setYMean:(CGFloat)yMean
{
    _yMean = yMean;
    [self setNeedsDisplay];
}

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = CGColorCreateCopy(lineColor);
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
