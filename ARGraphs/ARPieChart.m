//
//  ARPieChart.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARPieChart.h"
#import "ARPieChartDataPointUtility.h"
#import "ARGraphBackground.h"
#import "ARPieChartLayer.h"

@interface ARPieChart ()

@property (nonatomic, strong) ARGraphBackground *background;
@property (nonatomic, strong) ARPieChartDataPointUtility *dataPointUtility;
@property (nonatomic, strong) ARPieChartLayer *pieLayer;

@property (nonatomic) NSUInteger dataCount;
@property (nonatomic, strong) NSArray *dataPoints;
@end
@implementation ARPieChart


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.dataPointUtility = [[ARPieChartDataPointUtility alloc] init];
        
        self.labelColor = [UIColor whiteColor];
        self.tintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        
        _background = [ARGraphBackground gradientWithColor:self.tintColor.CGColor];
        _background.frame = self.bounds;
        [self.layer insertSublayer:_background atIndex:0];
        
        _pieLayer = [ARPieChartLayer layer];
        _pieLayer.frame = self.bounds;
        [self.layer addSublayer:_pieLayer];
    }
    return self;
}

#pragma mark - Setters

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

}

- (void)setSliceGutterWidth:(CGFloat)sliceGutterWidth
{
    self.pieLayer.sliceGutterWidth = sliceGutterWidth;
}
- (void)reloadData
{    
    _pieLayer.percentages = [self.dataPointUtility percentages];
    _pieLayer.numberOfSlices = self.dataCount;
    [_pieLayer animate];

    [_pieLayer setNeedsDisplay];
    

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
}


@end
