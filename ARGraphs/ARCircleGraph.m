//
//  ARCircleGraph.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARCircleGraph.h"
#import "ARCircleRing.h"
#import "ARCircleValueLabel.h"

@interface ARCircleGraph ()
@property (nonatomic, strong) ARCircleRing *ring;
@property (nonatomic, strong) ARCircleValueLabel *valueLabel;

@end

@implementation ARCircleGraph

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    _ring = [[ARCircleRing alloc] init];
    _ring.lineColor = [UIColor blueColor].CGColor;
    _ring.lineCap = kCALineCapRound;
    _ring.fillColor = [UIColor clearColor].CGColor;
    _ring.maxColor = [UIColor redColor].CGColor;
    _ring.minColor = [UIColor yellowColor].CGColor;
    [self.layer addSublayer:_ring];
    
    _valueLabel = [[ARCircleValueLabel alloc] init];

    [self addSubview:_valueLabel];
    [self applyDefaults];
}

- (void)applyDefaults
{
    self.lineWidth = 8.0;
    self.valueFormat = @"%.0f";
    self.animationDuration = 1.0;;
}

#pragma mark - Setters
- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    self.ring.percent = percent;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.ring.lineWidth = lineWidth;
    self.valueLabel.lineWidth = lineWidth;
}
- (void)setValue:(CGFloat)value
{
    _value = value;
    [_valueLabel countFromZeroTo:value];
}

- (void)setValueFormat:(NSString *)valueFormat
{
    _valueFormat = valueFormat;
    _valueLabel.format = valueFormat;
}

- (void)setAnimationDuration:(CGFloat)animationDuration
{
    _animationDuration = animationDuration;
    _ring.animationDuration = animationDuration;
    _valueLabel.animationDuration = animationDuration;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _ring.frame = self.bounds;
}

@end
