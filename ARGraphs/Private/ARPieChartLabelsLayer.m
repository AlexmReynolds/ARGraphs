//
//  ARPieChartLabelsLayer.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/21/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARPieChartLabelsLayer.h"
#import "ARHelpers.h"
@implementation ARPieChartLabelsLayer{
    NSArray *_textLayers;
}
- (instancetype)init
{
    self = [super init];
    if(self){
        self.interalLabels = YES;
    }
    return self;
}

#pragma mark - Setters

- (void)setNumberOfSlices:(NSInteger)numberOfSlices
{
    _numberOfSlices = numberOfSlices;
    if(self.numberOfSlices > 0){
        [self layoutLabels];
    }
    [self setNeedsDisplay];
}

- (void)setLabelStrings:(NSArray *)labelStrings
{
    _labelStrings = labelStrings;
    [self setNeedsDisplay];
}

#pragma mark - Animation

- (void)animate
{
    self.opacity = 1.0;

    [self addAnimation:[self opacityAnimation] forKey:@"opacityAnimation"];
}

- (CABasicAnimation*)opacityAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.5;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.removedOnCompletion = YES;
    return animation;
}

#pragma mark - Layout
- (void)layoutSublayers
{
    [super layoutSublayers];
    [self updateLabels];

}

- (void)layoutLabels
{
    if(_textLayers.count != self.numberOfSlices){
        [_textLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        _textLayers = [self makeLabels];
    }else{
        [self updateLabels];
    }
}

- (NSArray*)makeLabels
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger count = self.numberOfSlices;
    for(NSInteger x = 0; x < count; x++){
        CATextLayer *textLayer = [self textLayerForPieIndex:x];
        [array addObject:textLayer];
        [self addSublayer:textLayer];
    }
    return array;
}

- (void)updateLabels
{
    CGFloat __block lastAngle = 0;
    [_textLayers enumerateObjectsUsingBlock:^(CATextLayer *label, NSUInteger idx, BOOL *stop) {
        if(self.labelStrings.count > idx){
            label.string = [self.labelStrings objectAtIndex:idx];
            CGRect textRect = [label.string boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];

            if(self.interalLabels){
                CGFloat percent = self.percentages[idx];
                CGFloat degrees = 360.0 * percent;
                label.frame =  [self insetLabelFrameForLabelSize:textRect.size sliceDegrees:degrees sliceStartAngel:lastAngle];
                lastAngle += degrees;
            }else {
                // NEED TO WRITE POSITIONING METHOD FOR EXTERNAL LABELS
            }
            


        }
    }];
}

- (CGRect)insetLabelFrameForLabelSize:(CGSize)size sliceDegrees:(CGFloat)degrees sliceStartAngel:(CGFloat)startAngle
{
    CGFloat radius = [self radiusOfPie];
    CGFloat offset = (radius/2) + (radius*self.innerRadiusPercent);
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint origin = [ARHelpers pointInCircle:center insetFromCenterBy:offset startAngle:startAngle degrees:degrees];
    CGRect frame = CGRectMake(origin.x - size.width/2, origin.y - size.height/2, size.width, size.height);
    return frame;
}
- (CATextLayer*)textLayerForPieIndex:(NSUInteger)index
{
    CATextLayer *textLayer = [CATextLayer layer];    
    [textLayer setString:@"Hello World"];
    [textLayer setForegroundColor:self.labelColor];
    [textLayer setFontSize:12.0];
    CGFontRef font = CGFontCreateWithFontName((CFStringRef)@"Helvetica"); //NEED TO RELEASE
    textLayer.font = font;
    
    CGFontRelease(font); //RELEASED
    textLayer.shouldRasterize = NO;
    textLayer.anchorPoint = CGPointMake(0, 0.5);
    textLayer.contentsScale = 2.0;
    
    return textLayer;
}

- (CGFloat)radiusOfPie
{
    return MIN(self.bounds.size.width - self.leftPadding - self.rightPadding, self.bounds.size.height - self.topPadding - self.bottomPadding) / 2;
}

@end
