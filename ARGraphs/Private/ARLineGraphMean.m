//
//  ARLineGraphMean.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/23/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARLineGraphMean.h"

@implementation ARLineGraphMean
- (instancetype)init
{
    self = [super init];
    self.leftPadding = 0;
    self.rightPadding = 0;
    self.topPadding = 0;
    self.bottomPadding = 0;
    self.animateChanges = YES;
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.6
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    self.strokeColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    
    self.lineDashPattern = @[@4, @2];
    
    return self;
}

- (void)setYMean:(CGFloat)yMean
{
    _yMean = yMean;
    if(self.animateChanges){
        [self addAnimation:[self animationToMean:yMean] forKey:@"meanAnimation"];

    }else {
        CGMutablePathRef newPath = [self pathForMean:yMean];
        self.path = newPath;
        CGPathRelease(newPath);
    }
}
- (void)layoutSublayers
{
    [super layoutSublayers];
    
    CGMutablePathRef newPath = [self pathForMean:self.yMean];
    self.path = newPath;
    CGPathRelease(newPath);}

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = lineColor;
    self.strokeColor = _lineColor;
    [self setNeedsDisplay];
}

- (CABasicAnimation*)animationToMean:(CGFloat)mean
{
    CGMutablePathRef newPath = [self pathForMean:mean];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.3;
    animation.toValue = (__bridge id)(newPath);
    animation.fromValue = (id)self.path;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    self.path = newPath;
    CGPathRelease(newPath);
    return animation;
}

- (CGMutablePathRef)pathForMean:(CGFloat)mean
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat yPosition = [self yPositionForYDataPoint:self.yMean inHeight:self.bounds.size.height];

    CGPathMoveToPoint(path, NULL, 0, yPosition);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width, yPosition);
    return path;
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

@end
