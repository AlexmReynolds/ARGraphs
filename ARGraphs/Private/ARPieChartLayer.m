//
//  ARPieChartLayer.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARPieChartLayer.h"
#import "ARHelpers.h"



@implementation ARPieChartLayer{
    CAShapeLayer *_maskLayer;
    BOOL _colorChanged;
}

#pragma mark - Drawing methods
- (instancetype)init
{
    self = [super init];
    self.sliceGutterWidth = 0.0;
    self.innerRadiusPercent = 0.4;
    self.animationType = ARSliceAnimationFan;
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.8
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    self.fillBaseColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    return self;
}

#pragma mark - Setters

- (void)setInnerRadiusPercent:(CGFloat)innerRadiusPercent
{
    _innerRadiusPercent = innerRadiusPercent;
    [self setNeedsLayout];

}
- (void)setSliceGutterWidth:(CGFloat)sliceGutterWidth
{
    _sliceGutterWidth = sliceGutterWidth;
    [self setNeedsLayout];
}
- (void)setColors:(NSArray *)colors
{
    _colors = colors;
   [self updateSliceColors];
}
- (void)setFillBaseColor:(CGColorRef)fillBaseColor
{
    _fillBaseColor = fillBaseColor;
    [self updateSliceColors];
}

- (void)setNumberOfSlices:(NSInteger)numberOfSlices
{
    _numberOfSlices = numberOfSlices;
    if([self canSlicePie]){
        [self slicePie];
    }
}
- (void)setPercentages:(NSArray *)percentages
{
    _percentages = percentages;
    if([self canSlicePie]){
        [self slicePie];
    }
}

- (BOOL)canSlicePie
{
    return(self.numberOfSlices > 0 && self.numberOfSlices == self.percentages.count);
}

- (void)slicePie
{
    [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGFloat lastAngle = 0;
    for (NSInteger x = 0; x < self.numberOfSlices; x++) {
        CGFloat percent = [self.percentages[x] doubleValue];
        CGFloat degrees = 360.0 * percent;
        CAShapeLayer *slice = [self sliceLayerForPercentage:percent startAngle:lastAngle];

        if(self.colors.count > x){
            CGColorRef fillColor = (__bridge CGColorRef)self.colors[x];
            CGColorRef stroke = [ARHelpers darkenColor:fillColor withPercent:0.2];
            slice.fillColor = fillColor;
            slice.strokeColor = stroke;
            CGColorRelease(stroke);
        }else {
            CGColorRef fillColor = [ARHelpers darkenColor:self.fillBaseColor withPercent:0.1 * x];
            CGColorRef stroke = [ARHelpers darkenColor:fillColor withPercent:0.2];
            slice.fillColor = fillColor;
            slice.strokeColor = stroke;
            
            CGColorRelease(fillColor);
            CGColorRelease(stroke);
            
        }
        [self addSublayer:slice];
        lastAngle += degrees;
    }
}

#pragma mark - Animation Methods
- (void)animate
{
    switch (self.animationType) {
        case ARSliceAnimationPop:
            [self animateSlicePop];
            break;
        case ARSliceAnimationFan:
            [self animateSliceFan];
            break;
        case ARSliceAnimationNone:
            break;
        default:
            [self animateReveal];
            break;
    }
}

- (void)animateReveal
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

- (void)animateSliceFan
{
    CGFloat lastAngle = 0;
    for (NSInteger x = 0; x < self.numberOfSlices; x++) {
        CGFloat percent = [self.percentages[x] doubleValue];
        CGFloat degrees = 360.0 * percent;
        CGFloat offsetDegreesToStart = -(lastAngle + degrees) ;
        CAShapeLayer *slice = [self.sublayers objectAtIndex:x];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 0.6;
        animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(offsetDegreesToStart)];
        animation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.removedOnCompletion = YES;
        slice.transform = CATransform3DIdentity;
        [slice addAnimation:animation forKey:@"fan"];
        lastAngle += degrees;

    }
}

- (void)animateSlicePop
{

    for (NSInteger x = 0; x < self.numberOfSlices; x++) {
       
        [CATransaction begin];

        CAShapeLayer *slice = [self.sublayers objectAtIndex:x];
        slice.transform = CATransform3DMakeScale(0, 0, 0);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.6;
        animation.fromValue = [NSValue valueWithCATransform3D:slice.transform];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.beginTime = CACurrentMediaTime() + (x * 0.1);
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.removedOnCompletion = NO;
        [CATransaction setCompletionBlock:^{
            slice.transform = CATransform3DIdentity;
            [slice removeAllAnimations];

        }];
        [slice addAnimation:animation forKey:@"pop"];
        
        [CATransaction commit];

    }
}

#pragma mark - Layer Creation

- (CAShapeLayer*)sliceLayerForPercentage:(CGFloat)percentage startAngle:(CGFloat)startAngle
{
    CAShapeLayer *slice = [CAShapeLayer layer];
    CGMutablePathRef path = [self pathForSliceWithPercent:percentage startAngle:startAngle];
    slice.path = path;
    slice.lineWidth = 2.0;
    slice.frame = self.bounds;
    CGPathRelease(path);
    return slice;
}

- (CAShapeLayer*)maskLayer
{
    CAShapeLayer *mask = [CAShapeLayer layer];
    CGFloat radius = [self radiusOfPie];

    UIBezierPath *path = [self pathForMask];
    mask.path = path.CGPath;
    mask.fillColor   = [UIColor clearColor].CGColor;
    mask.strokeColor = [UIColor blackColor].CGColor;
    mask.strokeStart = 0;
    mask.strokeEnd   = 1;
    mask.lineWidth   = radius;
    mask.frame = self.bounds;
    mask.masksToBounds = YES;
    return mask;
}

#pragma mark - Layout

- (void)layoutSublayers
{
    [super layoutSublayers];
    [self layoutSlices];
    _maskLayer.path = [self pathForMask].CGPath;
}

- (void)layoutSlices
{
    if(self.sublayers.count != self.numberOfSlices){
        [self slicePie];
    }else {
        [self updateSlicePositions];
    }
}

- (void)updateSliceColors
{
    for (NSInteger x = 0; x < self.numberOfSlices; x++) {
        CAShapeLayer *slice = [self.sublayers objectAtIndex:x];
        if(self.colors.count > x){
            CGColorRef fillColor = (__bridge CGColorRef)self.colors[x];
            CGColorRef stroke = [ARHelpers darkenColor:fillColor withPercent:0.2];
            slice.fillColor = fillColor;
            slice.strokeColor = stroke;
            CGColorRelease(stroke);
        }else {
            CGColorRef fillColor = [ARHelpers darkenColor:self.fillBaseColor withPercent:0.1 * x];
            CGColorRef stroke = [ARHelpers darkenColor:fillColor withPercent:0.2];
            slice.fillColor = fillColor;
            slice.strokeColor = stroke;
            CGColorRelease(fillColor);
            CGColorRelease(stroke);
        }
        
    }
    _colorChanged = NO;

}

- (void)updateSlicePositions
{
    CGFloat lastAngle = 0;
    for (NSInteger x = 0; x < self.numberOfSlices; x++) {
        CGFloat percent = [self.percentages[x] doubleValue];
        CGFloat degrees = 360.0 * percent;
        CAShapeLayer *slice = [self.sublayers objectAtIndex:x];
        slice.frame = self.bounds;
        CGMutablePathRef path = [self pathForSliceWithPercent:percent startAngle:lastAngle];
        slice.path = path;
        lastAngle += degrees;
        
    }
}

#pragma mark - Path Creation

- (UIBezierPath*)pathForMask
{
    CGFloat radius = [self radiusOfPie];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius/2
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    return path;
}

- (CGMutablePathRef)pathForSliceWithPercent:(CGFloat)percent startAngle:(CGFloat)startAngle
{
    CGFloat radius = [self radiusOfPie];
    CGFloat degrees = 360.0 * percent;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    if(self.sliceGutterWidth > 0){
        center = [ARHelpers pointInCircle:center insetFromCenterBy:self.sliceGutterWidth angle:(startAngle + degrees/2)];
        radius -= self.sliceGutterWidth;

    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if(self.innerRadiusPercent > 0.0){
        CGPathAddArc(path, NULL, center.x, center.y, radius * self.innerRadiusPercent, DEGREES_TO_RADIANS(startAngle + degrees), DEGREES_TO_RADIANS(startAngle), YES);
    }else{
        CGPathMoveToPoint(path, NULL, center.x, center.y);
    }
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, DEGREES_TO_RADIANS(startAngle), DEGREES_TO_RADIANS(startAngle + degrees), NO);

    CGPathCloseSubpath(path);
    return path;
}

- (CGFloat)radiusOfPie
{
    return MIN(self.bounds.size.width - self.leftPadding - self.rightPadding, self.bounds.size.height - self.topPadding - self.bottomPadding) / 2;
}
@end
