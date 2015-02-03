//
//  ARCircleRing.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARCircleRing.h"

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

- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    [self animatePercentage:percent];
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
}

- (void)layoutSublayers
{
    CGMutablePathRef path = [self circlePath];
    self.path = path;
    CGPathRelease(path);
}
@end
