//
//  ARPieChart.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARPieChart.h"
#import "ARPieChartDataPointUtility.h"
#import "ARPieChartLayer.h"
#import "ARPieChartLabelsLayer.h"
#import "ARGraphBackground.h"


@interface ARPieChart ()

@property (nonatomic, strong) ARPieChartDataPointUtility *dataPointUtility;
@property (nonatomic, strong) ARPieChartLayer *pieLayer;
@property (nonatomic, strong) ARPieChartLabelsLayer *labelsLayer;
@property (nonatomic, strong) ARGraphBackground *background;

@property (nonatomic) NSUInteger dataCount;
@property (nonatomic, strong) NSArray *dataPoints;
@end
@implementation ARPieChart


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.dataPointUtility = [[ARPieChartDataPointUtility alloc] init];

        _background = [ARGraphBackground gradientWithColor:self.tintColor.CGColor];
        _background.frame = self.bounds;
        [self.layer insertSublayer:_background atIndex:0];
        
        _pieLayer = [ARPieChartLayer layer];
        _pieLayer.frame = self.bounds;
        [self.layer addSublayer:_pieLayer];
        
        _labelsLayer = [[ARPieChartLabelsLayer alloc] init];
        _labelsLayer.frame = self.bounds;
        [self.layer addSublayer:_labelsLayer];
        [self applyDefaults];
    }
    return self;
}

- (void)applyDefaults
{
    self.useBackgroundGradient = YES;
    self.labelColor = [UIColor whiteColor];
    self.tintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.insets = UIEdgeInsetsMake(8, 8, 8, 8);
    self.pieLayer.bottomPadding = self.insets.bottom;
    self.pieLayer.topPadding = self.insets.top;
    self.pieLayer.leftPadding = self.insets.left;
    self.pieLayer.rightPadding = self.insets.right;

}

#pragma mark - Setters
- (void)setUseBackgroundGradient:(BOOL)useBackgroundGradient
{
    _background.hidden = !useBackgroundGradient;
}

- (void)setDataSource:(id<ARPieChartDataSource>)dataSource
{
    _dataSource = dataSource;
    _dataPoints = [[self.dataSource ARPieChartDataPoints:self] copy];
    _dataPointUtility.datapoints = _dataPoints;
    [self layoutIfNeeded];
    
    [self reloadData];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    self.background.color = tintColor.CGColor;
    self.pieLayer.fillBaseColor = tintColor.CGColor;
    [self.pieLayer setNeedsDisplay];
}


- (void)setInnerRadiusPercent:(CGFloat)innerRadiusPercent
{
    self.pieLayer.innerRadiusPercent = innerRadiusPercent;
    self.labelsLayer.innerRadiusPercent = innerRadiusPercent;
}

- (void)setSliceGutterWidth:(CGFloat)sliceGutterWidth
{
    self.pieLayer.sliceGutterWidth = sliceGutterWidth;
}

- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    _labelsLayer.labelColor = labelColor.CGColor;
}

- (void)reloadData
{    
    _pieLayer.percentages = [self.dataPointUtility percentages];
    _pieLayer.numberOfSlices = self.dataCount;
    [_pieLayer setNeedsDisplay];
    
    _labelsLayer.percentages = [self.dataPointUtility percentages];
    _labelsLayer.numberOfSlices = self.dataCount;
    _labelsLayer.labelStrings = [self getLabelStringArray];
    [_labelsLayer setNeedsDisplay];
}

- (NSUInteger)dataCount
{
    return self.dataPoints.count;
}

- (void)layoutSubviews
{
    CGRect pointsLayerFrame = self.bounds;

    _pieLayer.frame = pointsLayerFrame;
    _background.frame = self.bounds;
    _labelsLayer.frame = self.bounds;
}

- (NSArray*)getLabelStringArray
{
    NSInteger count = self.dataCount;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while (count--) {
        if([self.dataSource respondsToSelector:@selector(ARPieChart:titleForPieIndex:)]){
            [array addObject:[self.dataSource ARPieChart:self titleForPieIndex:count]];
        }
    }
    return array;
}

- (void)beginAnimationIn
{
    [_pieLayer animate];
    _labelsLayer.opacity = 0.0;
    [_labelsLayer performSelector:@selector(animate) withObject:nil afterDelay:0.5];
}


@end
