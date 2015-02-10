//
//  ARCircleRing.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/9/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARCircleRingLayer.h"
#import "ARHelpers.h"

@import UIKit;
@interface ARCircleRingLayer ()
@property (nonatomic, strong) CAShapeLayer *containerMaskLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, strong) CAGradientLayer *leftGradient;
@property (nonatomic, strong) CAGradientLayer *rightGradient;
@property (nonatomic, strong) CALayer *container;
@property (nonatomic, strong) CALayer *background;



@end
@implementation ARCircleRingLayer{
    CGColorRef midColor;

}
- (instancetype)init{
    self = [super init];
    self.animationDuration = 0.5;
    self.lineWidth = 8.0;
    [self addSublayer:self.background];
    [self addSublayer:self.container];
    self.container.mask = self.containerMaskLayer;
    [self.container addSublayer:self.leftGradient];
    [self.container addSublayer:self.rightGradient];
    
    self.background.mask = self.maskLayer;
    return self;
}

- (CALayer *)container
{
    if(_container == nil){
        _container = [CALayer layer];
    }
    return _container;
}

- (CALayer *)background
{
    if(_background == nil){
        _background = [CALayer layer];
    }
    return _background;
}
- (CAGradientLayer *)leftGradient
{
    if(_leftGradient == nil){
        _leftGradient = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:(id)([UIColor redColor]).CGColor, [UIColor purpleColor].CGColor, nil];
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:0.8];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
        _leftGradient.colors = colors;
        _leftGradient.locations = locations;
    }
    return _leftGradient;
}

- (CAGradientLayer *)rightGradient
{
    if(_rightGradient == nil){
        _rightGradient = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:(id)([UIColor blueColor]).CGColor, [UIColor purpleColor].CGColor, nil];
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:0.8];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
        _rightGradient.colors = colors;
        _rightGradient.locations = locations;
    }
    return _rightGradient;
}

- (CAShapeLayer *)maskLayer
{
    if(_maskLayer == nil){
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = self.bounds;
        _maskLayer.strokeColor = [UIColor clearColor].CGColor;
        _maskLayer.fillColor = [UIColor blackColor].CGColor;
        CGMutablePathRef path = [self backgroundMaskPath];
        _maskLayer.path = path;
        CGPathRelease(path);
    }
    return _maskLayer;
}

- (CAShapeLayer *)containerMaskLayer
{
    if(_containerMaskLayer == nil){
        _containerMaskLayer = [CAShapeLayer layer];
        _containerMaskLayer.frame = self.bounds;
        _containerMaskLayer.lineWidth = 8.0;
        _containerMaskLayer.strokeColor = [UIColor blackColor].CGColor;
        _containerMaskLayer.fillColor = [UIColor clearColor].CGColor;
        CGMutablePathRef path = [self circlePath];
        _containerMaskLayer.path = path;
        CGPathRelease(path);
    }
    return _containerMaskLayer;
}

- (void)dealloc
{
    CGColorRelease(self.lineColor);
    CGColorRelease(self.minColor);
    CGColorRelease(self.maxColor);
    CGColorRelease(midColor);
    
}

- (CGMutablePathRef)backgroundMaskPath
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2) - self.lineWidth;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, -M_PI/2, 1.5 * M_PI, NO);
    
    return path;
}

- (CGMutablePathRef)circlePath
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2) - self.lineWidth/2;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, -M_PI/2, 1.5 * M_PI, NO);

    return path;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.containerMaskLayer.lineWidth = lineWidth;
}

- (void)setBackgroundColor:(CGColorRef)backgroundColor
{
    self.background.backgroundColor = backgroundColor;
}
- (void)setMaxColor:(CGColorRef)maxColor
{
    _maxColor = CGColorCreateCopy(maxColor);
}

- (void)setMinColor:(CGColorRef)minColor
{
    _minColor = CGColorCreateCopy(minColor);
}

- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    [self setThePercentColor];
    self.containerMaskLayer.strokeEnd = percent;
}

- (void)animateToPercent:(CGFloat)percent
{
    _percent = percent;
    [self animatePercentage:percent];
}

- (void)setThePercentColor
{
    if(self.maxColor && self.minColor && self.percent){
        midColor = [ARHelpers colorPercentBetween:0.5 betweenMinColor:self.minColor maxColor:self.maxColor];
        
        NSArray *colors1 = [NSArray arrayWithObjects:(__bridge id)self.maxColor, (__bridge id)midColor, nil];
        self.leftGradient.colors = colors1;
        NSArray *colors2 = [NSArray arrayWithObjects:(__bridge id)self.minColor, (__bridge id)midColor, nil];
        self.rightGradient.colors = colors2;

    }
}

- (void)layoutSublayers
{
    _container.frame = self.bounds;
    _background.frame = self.bounds;

    CGRect frame1 = self.bounds;
    frame1.size.width /= 2;
    
    CGRect frame2 = frame1;
    frame2.origin.x = frame2.size.width;
    self.leftGradient.frame = frame1;
    self.rightGradient.frame = frame2;
    CGMutablePathRef path = [self circlePath];
    self.containerMaskLayer.path = path;
    self.maskLayer.path = path;

    CGPathRelease(path);
    
    CGMutablePathRef maskPath = [self backgroundMaskPath];
    _maskLayer.path = maskPath;
    CGPathRelease(maskPath);
}


- (void)animatePercentage:(CGFloat)percentage
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.animationDuration;
    animation.fromValue = @0;
    animation.toValue = @(percentage);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [self.containerMaskLayer addAnimation:animation forKey:@"reveal"];
    self.containerMaskLayer.strokeEnd = percentage;

}
@end
