//
//  ARCircleGraph.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARCircleGraph.h"
#import "ARCircleRingLayer.h"
#import "ARCircleValueLabel.h"
#import "ARCircleTitleLabel.h"
@interface ARCircleGraph ()
@property (nonatomic, strong) ARCircleRingLayer *ring;
@property (nonatomic, strong) ARCircleValueLabel *valueLabel;
@property (nonatomic, strong) ARCircleTitleLabel *titleLabel;

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
    _ring = [[ARCircleRingLayer alloc] init];
    _ring.lineCap = kCALineCapRound;
    _ring.fillColor = [UIColor clearColor].CGColor;

    [self.layer addSublayer:_ring];
    
    _valueLabel = [[ARCircleValueLabel alloc] init];
    _titleLabel = [[ARCircleTitleLabel alloc] init];
    [self addSubview:_titleLabel];
    [self addSubview:_valueLabel];
    [self applyDefaults];
}

- (void)applyDefaults
{
    self.lineWidth = 8.0;
    self.valueFormat = @"%.0f";
    self.animationDuration = 1.0;
    self.minColor = [UIColor blueColor];
    self.maxColor = [UIColor redColor];
    self.ringColor = [UIColor blueColor];
    self.titlePosition = ARCircleGraphTitlePositionTop;

}

- (void)beginAnimationIn
{
    [_valueLabel countFromZeroTo:self.value];
    [self.ring animateToPercent:self.percent];
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
    _valueLabel.currentValue = value;
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

- (void)setMinColor:(UIColor *)minColor
{
    _minColor = minColor;
    _ring.minColor = minColor.CGColor;

}

- (void)setMaxColor:(UIColor *)maxColor
{
    _maxColor = maxColor;
    _ring.maxColor = maxColor.CGColor;
}

- (void)setRingColor:(UIColor *)ringColor
{
    _ringColor = ringColor;
    _ring.lineColor = ringColor.CGColor;
}

- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    _titleLabel.textColor = labelColor;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
    [self setNeedsDisplay];
}

- (void)setTitlePosition:(ARCircleGraphTitlePosition)titlePosition
{
    _titlePosition = titlePosition;
    switch (titlePosition) {
        case ARCircleGraphTitlePositionBottom:
            [self removeConstraint:self.titleLabel.top];
            [self addConstraint:self.titleLabel.bottom];
            [self needsUpdateConstraints];
            break;
        case ARCircleGraphTitlePositionTop:
            [self removeConstraint:self.titleLabel.bottom];
            [self addConstraint:self.titleLabel.top];
            [self needsUpdateConstraints];
            break;
    }
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_title == nil || _title.length == 0){
        _ring.frame = self.bounds;
        _valueLabel.bottom.constant = 0;
    }else {
        CGRect frame = self.bounds;
        frame.size.height -= _titleLabel.frame.size.height;

        switch (_titlePosition) {
            case ARCircleGraphTitlePositionBottom:
                _valueLabel.bottom.constant = -_titleLabel.bounds.size.height;

                break;
            case ARCircleGraphTitlePositionTop:
                frame.origin.y = _titleLabel.frame.size.height;
                _valueLabel.top.constant = _titleLabel.bounds.size.height;

                break;
        }
        _ring.frame = frame;

    }
}


@end
