//
//  ARCircleRing.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARCircleRing.h"
#import "ARHelpers.h"

@interface ARCircleRing ()
@property (nonatomic) CGColorRef percentColor;
@end
@implementation ARCircleRing

- (instancetype)init{
    self = [super init];
    CGMutablePathRef path = [self circlePath];
    self.path = path;
    CGPathRelease(path);
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 1.0
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    _lineColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    return self;
}

- (void)dealloc
{
    CGColorRelease(self.lineColor);
    CGColorRelease(self.minColor);
    CGColorRelease(self.maxColor);
    CGColorRelease(self.percentColor);

}

- (CGMutablePathRef)circlePath
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = self.bounds.size.width/2 - self.lineWidth/2;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, -M_PI/2, 1.5 * M_PI, NO);
    return path;
}

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = CGColorCreateCopy(lineColor);
    self.strokeColor = self.lineColor;
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
    [self animatePercentage:percent];
}

- (void)setThePercentColor
{
    if(self.maxColor && self.minColor && self.percent){
        _percentColor = [ARHelpers colorPercentBetween:self.percent betweenMinColor:self.minColor maxColor:self.maxColor];
    }
}

- (void)animatePercentage:(CGFloat)percentage
{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.animationDuration;
    animation.fromValue = @0;
    animation.toValue = @(percentage);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [self addAnimation:animation forKey:@"reveal"];
    self.strokeEnd = percentage;
    
    if(self.maxColor && self.minColor){
        CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
        colorAnimation.duration = self.animationDuration;
        colorAnimation.fromValue = (id)(self.minColor);
        colorAnimation.toValue = (id)(self.percentColor);
        colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        colorAnimation.removedOnCompletion = YES;
        [self addAnimation:colorAnimation forKey:@"colorAnimation"];
        self.strokeColor = _percentColor;
    }
}

- (void)layoutSublayers
{
    CGMutablePathRef path = [self circlePath];
    self.path = path;
    CGPathRelease(path);
}
@end
