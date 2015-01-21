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
}

#pragma mark - Drawing methods
+ (instancetype)layer
{
    ARPieChartLayer *layer = [super layer];
    layer.sliceGutterWidth = 4.0;
    layer.innerRadiusPercent = 0.4;
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.8
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    layer.fillBaseColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    CGColorSpaceRelease(colorSpace);
    return layer;
}

- (void)animate
{
    _maskLayer = [self maskLayer];
    self.mask = _maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timeOffset =
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
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;

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

- (void)layoutSublayers
{
    [super layoutSublayers];
    _maskLayer.path = [self pathForMask].CGPath;
}

- (UIBezierPath*)pathForMask
{
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius/2
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    return path;
}

- (void)drawInContext:(CGContextRef)ctx
{
    NSInteger count = self.numberOfSlices;
    
    if(count < 1){
        return;
    }
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(ctx, 2.0);
    CGFloat lastAngle = 0;
    while (count--) {
        [self drawSliceInContext:ctx atIndex:count startAngle:&lastAngle];
    }
}

- (void)drawSliceInContext:(CGContextRef)ctx atIndex:(NSUInteger)index startAngle:(CGFloat*)startAngle
{
    if(self.colors.count > index){
        CGColorRef fillColor = (__bridge CGColorRef)self.colors[index];
        CGColorRef stroke = [ARHelpers darkenColor:fillColor withPercent:0.2];
        CGContextSetFillColorWithColor(ctx, fillColor);
        CGContextSetStrokeColorWithColor(ctx, stroke);
    }else {
        CGColorRef fillColor = [ARHelpers darkenColor:self.fillBaseColor withPercent:0.1 * index];
        CGContextSetFillColorWithColor(ctx, fillColor);
        
    }
    CGFloat percent = self.percentages[index];
    CGFloat degrees = 360.0 * percent;
    
    CGMutablePathRef path = [self pathForSliceAtIndex:index startAngle:*startAngle];
    CGContextAddPath(ctx, path);
    
    CGPathRelease(path);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    *startAngle += degrees;
}

- (CGMutablePathRef)pathForSliceAtIndex:(NSUInteger)index startAngle:(CGFloat)startAngle
{
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    CGFloat percent = self.percentages[index];;
    CGFloat degrees = 360.0 * percent;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    if(self.sliceGutterWidth > 0){
        center = [self point:center insetby:self.sliceGutterWidth startAngle:startAngle degrees:degrees];
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

- (CGPoint)point:(CGPoint)point insetby:(CGFloat)inset startAngle:(CGFloat)angle degrees:(CGFloat)degrees
{
    CGFloat newAngle = (angle + degrees/2);
    newAngle = 360.0 - newAngle;
    CGFloat rads = DEGREES_TO_RADIANS(newAngle);
    CGFloat hypotenues = inset;
    CGFloat opposite = sinf(rads) * hypotenues;
    CGFloat adjacent = cosf(rads) * hypotenues;

    return CGPointMake(point.x + adjacent, point.y - opposite);// invert due to x,y coordinate plane
}

@end
