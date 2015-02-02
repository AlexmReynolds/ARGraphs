//
//  CYCGraphPointsLayer.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARLineGraphPointsLayer.h"
#import "ARGraphDataPoint.h"
#import "ARHelpers.h"


static const NSInteger kSMOOTHING_MINIMUM = 20;

@interface ARLineGraphPointsLayer ()

@end
@implementation ARLineGraphPointsLayer{
    NSInteger _dataCount;
    CAShapeLayer *_maskLayer;
}
- (instancetype)init
{
    self = [super init];
    self.dotRadius = 2.0;
    self.lineWidth = 2.0;
    self.showDots = YES;
    self.shouldFill = YES;
    self.shouldSmooth = NO;
    
    self.leftPadding = 0;
    self.rightPadding = 0;
    self.topPadding = 0;
    self.bottomPadding = 0;
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 1.0
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    _lineColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    
    return self;
}

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = CGColorCreateCopy(lineColor);
}

- (void)animate
{
    _maskLayer = [self maskLayer];
    self.mask = _maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.6;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    
    [_maskLayer addAnimation:animation forKey:@"reveal"];
    
}

- (CAShapeLayer*)maskLayer
{
    CAShapeLayer *mask = [CAShapeLayer layer];
    
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.8
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    CGColorRef stroke  = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    
    CGMutablePathRef path = [self pathForMask];
    mask.path = path;
   // mask.fillColor   = [UIColor clearColor].CGColor;
    mask.strokeColor = stroke;
    mask.strokeStart = 0;
    mask.strokeEnd   = 1;
    mask.lineWidth   = self.bounds.size.height;
    mask.frame = self.bounds;
    mask.masksToBounds = YES;
    
    CGPathRelease(path);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(stroke);
    return mask;
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    _maskLayer.path = [self pathForMask];
    _maskLayer.frame = self.bounds;
    _maskLayer.lineWidth   = self.bounds.size.height;

}

- (CGMutablePathRef)pathForMask
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, self.bounds.size.height/2);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height/2);

    return path;
}

#pragma mark - Path Methods

// Generates a mutble path for the area under our data point line
- (CGMutablePathRef)fillPath
{
    CGMutablePathRef fillPath = CGPathCreateMutable();
    
    for(int x = 0; x < _dataCount; x++){
        ARGraphDataPoint *currentDataPoint = [self.dataPoints objectAtIndex:x];
        CGPoint relativePoint = [self pointForDataPoint:currentDataPoint index:x total:_dataCount];
        if(x == 0){ //first
            CGPathMoveToPoint(fillPath, NULL, relativePoint.x, self.bounds.size.height);
        }
        
        CGPathAddLineToPoint(fillPath, NULL, relativePoint.x, relativePoint.y);
        
        if(x == _dataCount - 1){//last
            CGPathAddLineToPoint(fillPath, NULL, relativePoint.x, self.bounds.size.height);
            CGPathCloseSubpath(fillPath);
            
        }
    }
    return fillPath;
}
// generates a mutable path for a smooth line that connects the datapoints
- (CGMutablePathRef)smoothLinePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    NSInteger ctr = 0;
    CGPoint *ptsArray = [self convertDataPointsToPointsInView];  //NEED TO RELEASE
    CGPoint *ptsSmoothingArray = (CGPoint *)malloc(sizeof(CGPoint) * 5);  //NEED TO RELEASE
    
    
    CGPathMoveToPoint(path, NULL, ptsArray[0].x, ptsArray[0].y);
    
    for(int x = 0; x < _dataCount; x++){
        
        ptsSmoothingArray[ctr] = ptsArray[x];
        
        if (ctr == 4)
        {
            ptsSmoothingArray[3] = CGPointMake((ptsSmoothingArray[2].x + ptsSmoothingArray[4].x)/2.0, (ptsSmoothingArray[2].y + ptsSmoothingArray[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
            CGPathAddCurveToPoint(path, NULL, ptsSmoothingArray[1].x, ptsSmoothingArray[1].y, ptsSmoothingArray[2].x, ptsSmoothingArray[2].y, ptsSmoothingArray[3].x, ptsSmoothingArray[3].y);
            
            
            // replace points and get ready to handle the next segment
            ptsSmoothingArray[0] = ptsSmoothingArray[3];
            ptsSmoothingArray[1] = ptsSmoothingArray[4];
            ctr = 0;
        }
        ctr++;
        
        
    }
    free(ptsArray); // RELEASED
    free(ptsSmoothingArray); // RELEASED
    
    return path;
}

// Creates a mutable path of the area under a smooth line that connects the datapoints
- (CGMutablePathRef)smoothFillPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGMutablePathRef line = [self smoothLinePath];  //NEED TO RELEASE
    
    CGPoint *ptsArray = [self convertDataPointsToPointsInView];  //NEED TO RELEASE
    CGPathMoveToPoint(path, NULL,  ptsArray[0].x, self.bounds.size.height);
    CGPathAddLineToPoint(path, NULL, ptsArray[0].x, ptsArray[0].y);
    CGPathAddPath(path, NULL, line);
    
    CGPathAddLineToPoint(path, NULL, ptsArray[_dataCount-5].x, self.bounds.size.height);
    CGPathAddLineToPoint(path, NULL,  ptsArray[0].x, self.bounds.size.height);
    
    CGPathCloseSubpath(path);
    
    free(ptsArray); // RELEASED
    CGPathRelease(line); // RELEASED
    return path;
}


#pragma mark - Helpers

// In order to graph our data we need to convert it into point relative to our chart bounds
- (CGPoint*)convertDataPointsToPointsInView
{
    CGPoint *ptsArray = (CGPoint *)malloc(sizeof(CGPoint) * _dataCount);
    
    for(NSInteger x = 0; x < _dataCount; x++){
        ARGraphDataPoint *dp = [self.dataPoints objectAtIndex:x];
        ptsArray[x] = [self pointForDataPoint:dp index:x total:_dataCount];
    }
    return ptsArray;
}

- (CGPoint)pointForDataPoint:(ARGraphDataPoint*)dataPoint index:(NSInteger)index total:(NSInteger)total
{
    ARGraphDataPoint *dp = [self.dataPoints objectAtIndex:index];
    CGFloat availableHeight = self.bounds.size.height - self.topPadding - self.bottomPadding;
    CGFloat xVal = [self xPositionForDataPointIndex:index totalPoints:total inWidth:self.bounds.size.width];
    CGFloat yVal = [ARHelpers yPositionForYDataPoint:dp.yValue availableHeight:availableHeight yRange:NSMakeRange(self.yMin, self.yMax - self.yMin)];
    yVal += self.topPadding;
    return CGPointMake(xVal, yVal);
}

- (CGFloat)xPositionForDataPointIndex:(NSInteger)index totalPoints:(NSInteger)total inWidth:(CGFloat)width
{
    CGFloat availableWidth = width - self.leftPadding - self.rightPadding;
    if (self.showDots) {
        availableWidth -= (self.dotRadius + self.lineWidth)*2;
    }
    if(total == 1){
        return NSNotFound;
    }else{
        CGFloat itemWidth = availableWidth / (total - 1);
        CGFloat x = self.leftPadding + index * itemWidth;
        if(self.showDots){
            x += self.dotRadius + self.lineWidth;
        }
        return x;
    }
}

- (CGFloat)xPositionForXDataPoint:(NSInteger)dataPoint inWidth:(CGFloat)width
{
    CGFloat range = self.xMax - self.xMin;
    CGFloat availableHeight = width - self.leftPadding - self.rightPadding;
    CGFloat normalizedDataPointYValue = dataPoint - self.xMin;
    
    CGFloat percentageOfDataPointToRange =  (normalizedDataPointYValue / range);
    if(range == 0){
        return NSNotFound;
    }else{
        return self.topPadding + percentageOfDataPointToRange * availableHeight;
    }
}

- (void)dealloc
{
    CGColorRelease(self.lineColor);
}
#pragma mark - Drawing methods

- (void)drawInContext:(CGContextRef)ctx
{
    if(self.dataPoints.count < 1){
        return;
    }
    _dataCount = [self.dataPoints count];
    //CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineWidth(ctx, self.lineWidth);
    if(self.showDots){
        for(int x = 0; x < _dataCount; x++){
            ARGraphDataPoint *currentDataPoint = [self.dataPoints objectAtIndex:x];
            [self drawDataPointDot:currentDataPoint index:x inContext:ctx inRect:self.bounds];
            CGContextStrokePath(ctx);
        }
    }
    
    if(self.shouldSmooth && _dataCount > kSMOOTHING_MINIMUM){
        [self drawSmoothLineInContext:ctx];
        
    }else {
        [self drawGraphLinesInContext:ctx];
        
    }
    CGContextStrokePath(ctx);
    
    if(self.shouldFill){
        [self fillGraphInContext:ctx];
        
    }
    
}

- (void)fillGraphInContext:(CGContextRef)ctx
{
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.6,
        1.0, 1.0, 1.0, 0.0
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, fillColors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    
    CGMutablePathRef fillPath; // NEED TO RELEASE
    
    if(self.shouldSmooth && self.dataPoints.count > kSMOOTHING_MINIMUM){
        fillPath = [self smoothFillPath];
        
    }else {
        fillPath = [self fillPath];
    }
    
    CGContextAddPath(ctx, fillPath);
    
    CGContextSaveGState(ctx);
    
    CGContextClip(ctx);
    
    //ADD gradient to chart
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds) + self.topPadding);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) - self.bottomPadding);
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(ctx);
    
    CGPathRelease(fillPath); //RELEASED
}

- (void)drawSmoothLineInContext:(CGContextRef)ctx
{
    CGMutablePathRef path = [self smoothLinePath]; //NEED TO RELEASE
    
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path); //RELEASE
}

- (BOOL)drawDataPointDot:(ARGraphDataPoint*)dataPoint index:(NSInteger)index inContext:(CGContextRef)context inRect:(CGRect)rect
{
    CGPoint relativePoint = [self pointForDataPoint:dataPoint index:index total:_dataCount];
    BOOL canDrawPoint = (relativePoint.x != NSNotFound && relativePoint.y != NSNotFound);
    if(canDrawPoint){
        CGContextAddArc(context, relativePoint.x, relativePoint.y, self.dotRadius, 0.0, M_PI * 2.0, NO);
    }
    return canDrawPoint;
}

- (void)drawConnectingLineFromPT1:(CGPoint)PT1 toPT2:(CGPoint)PT2 inContext:(CGContextRef)context
{
    CGFloat opposite = 0;
    CGFloat adjacent = 0;
    // We dont want the line to go through our dot but to stop at the dots radius so we need to offset our start and end points. We need to know where on the dot to move to so we need angle.

    if(self.showDots){
        CGFloat angle = atan2f(PT1.y - PT2.y, PT1.x - PT2.x);
        CGFloat hypoteneus = self.dotRadius;
        opposite = sinf(angle) * hypoteneus;
        adjacent = cosf(angle) * hypoteneus;
    }
    CGContextMoveToPoint(context, PT1.x - adjacent, PT1.y - opposite);

    CGContextAddLineToPoint(context, PT2.x + adjacent, PT2.y + opposite);
}

- (void)drawGraphLinesInContext:(CGContextRef)ctx
{
    for(int x = 0; x < _dataCount; x++){
        ARGraphDataPoint *currentDataPoint = [self.dataPoints objectAtIndex:x];
        CGPoint relativePoint = [self pointForDataPoint:currentDataPoint index:x total:_dataCount];

        if(x == 0){ //first
            CGContextMoveToPoint(ctx, relativePoint.x, relativePoint.y);
        }else {
            ARGraphDataPoint *lastDP = [self.dataPoints objectAtIndex:x-1];
            CGPoint lastRelativePoint = [self pointForDataPoint:lastDP index:x-1 total:_dataCount];
            [self drawConnectingLineFromPT1:relativePoint toPT2:lastRelativePoint inContext:ctx];
        }
    }
}

@end
