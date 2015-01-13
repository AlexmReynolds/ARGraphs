//
//  CYCMinMaxLabelLayer.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/9/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARMinMaxLabelLayer.h"
#import "ARGraphDataPoint.h"
#import <UIKit/UIKit.h>

@interface ARMinMaxLabelLayer()

@property (nonatomic, strong) CATextLayer *minTextLayer;
@property (nonatomic, strong) CATextLayer *maxTextLayer;

@end

@implementation ARMinMaxLabelLayer

+ (instancetype)layer
{
    ARMinMaxLabelLayer *layer = [super layer];
    [layer addSublayer:layer.minTextLayer];
    [layer addSublayer:layer.maxTextLayer];
    
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.6
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    layer.lineColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    return layer;
}

- (void)dealloc
{
    CGColorRelease(self.lineColor);
}

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = lineColor;
    self.minTextLayer.foregroundColor = self.lineColor;
    self.maxTextLayer.foregroundColor = self.lineColor;
    [self setNeedsDisplay];
}

- (void)setMaxDataPoint:(ARGraphDataPoint *)maxDataPoint
{
    _maxDataPoint = maxDataPoint;
    [self.maxTextLayer setString:[NSString stringWithFormat:@"%ld",(long)maxDataPoint.yValue]];

}

- (void)setMinDataPoint:(ARGraphDataPoint *)minDataPoint
{
    _minDataPoint = minDataPoint;
    [self.minTextLayer setString:[NSString stringWithFormat:@"%ld",(long)minDataPoint.yValue]];
    
}

- (CGFloat)yPositionForDataPoint:(ARGraphDataPoint*)dataPoint inHeight:(CGFloat)height
{
    CGFloat range = self.maxDataPoint.yValue - self.minDataPoint.yValue;
    CGFloat availableHeight = height - self.topPadding - self.bottomPadding;
    CGFloat normalizedDataPointYValue = dataPoint.yValue - self.minDataPoint.yValue;
    CGFloat percentageOfDataPointToRange =  (normalizedDataPointYValue / range);
    CGFloat inversePercentage = 1.0 - percentageOfDataPointToRange; // Must invert because the greater the value the higher we want it on the chart which is a smaller y value on a iOS coordinate system
    return self.topPadding + inversePercentage * availableHeight;
}

- (void)layoutSublayers
{
    if(self.minDataPoint == nil || self.maxDataPoint == nil){
        return;
    }
    self.minTextLayer.frame = [self frameforMinLabel];
    self.maxTextLayer.frame = [self frameforMaxLabel];
}

- (CGRect)frameforMinLabel
{
    CGRect rect = [self.minTextLayer.string boundingRectWithSize:self.minTextLayer.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    rect.origin.x = self.bounds.size.width - rect.size.width - 8;
    rect.origin.y = [self yPositionForDataPoint:self.minDataPoint inHeight:self.bounds.size.height] - rect.size.height;
    return rect;

}

- (CGRect)frameforMaxLabel
{
    CGRect rect = [self.maxTextLayer.string boundingRectWithSize:self.maxTextLayer.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    
    rect.origin.x = self.bounds.size.width - rect.size.width - 8;
    rect.origin.y = [self yPositionForDataPoint:self.maxDataPoint inHeight:self.bounds.size.height];
    
    return rect;
}

- (void)drawInContext:(CGContextRef)ctx
{
    if(self.minDataPoint == nil || self.maxDataPoint == nil){
        return;
    }
    CGContextSetStrokeColorWithColor(ctx, self.lineColor);
    CGFloat minY = [self yPositionForDataPoint:self.minDataPoint inHeight:self.bounds.size.height];
    CGFloat maxY = [self yPositionForDataPoint:self.maxDataPoint inHeight:self.bounds.size.height];

    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextMoveToPoint(ctx, 0, minY);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, minY);
    
    
    CGContextMoveToPoint(ctx, 0, maxY);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, maxY);
    
    CGContextStrokePath(ctx);
}



- (CATextLayer *)minTextLayer
{
    if(_minTextLayer == nil){
        CATextLayer *textLayer = [CATextLayer layer];
        //        CGFloat offset = [self sizeOfText:@"one line" forFont:self.font].height;

        [textLayer setString:@"Hello World"];
        [textLayer setForegroundColor:self.lineColor];
        [textLayer setFontSize:12.0];
        CGFontRef font = CGFontCreateWithFontName((CFStringRef)@"Helvetica"); //NEED TO RELEASE
        textLayer.font = font;

        CGFontRelease(font); //RELEASED
        textLayer.shouldRasterize = NO;
        textLayer.anchorPoint = CGPointMake(0, 0.5);
        textLayer.contentsScale = 2.0;
        
        [textLayer setFrame:CGRectMake(0, 30, 40, 40)];
        _minTextLayer = textLayer;
    }
    return _minTextLayer;
}

- (CATextLayer *)maxTextLayer
{
    if(_maxTextLayer == nil){
        CATextLayer *textLayer = [CATextLayer layer];
        //        CGFloat offset = [self sizeOfText:@"one line" forFont:self.font].height;
 
        [textLayer setString:@"Hello World"];
        [textLayer setForegroundColor:self.lineColor];
        [textLayer setFontSize:12.0];
        CGFontRef font = CGFontCreateWithFontName((CFStringRef)@"Helvetica"); //NEED TO RELEASE
        textLayer.font = font;
        
        CGFontRelease(font); //RELEASED
        textLayer.shouldRasterize = NO;
        textLayer.anchorPoint = CGPointMake(0, 0.5);
        textLayer.contentsScale = 2.0;
        
        [textLayer setFrame:CGRectMake(0, 30, 40, 40)];
        _maxTextLayer = textLayer;
    }
    return _maxTextLayer;
}


@end
