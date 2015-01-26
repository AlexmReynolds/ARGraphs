//
//  ARPieChartDataPointUtility.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARPieChartDataPointUtility.h"
#import "ARGraphDataPoint.h"


@implementation ARPieChartDataPointUtility{
    NSInteger _allDataPointsTotal;
    NSUInteger _smallestIndex;
    NSUInteger _largestIndex;
}

- (instancetype)init
{
    self = [super init];
    _allDataPointsTotal = 0;
    _smallestIndex = NSNotFound;
    _largestIndex = NSNotFound;
    return self;
}
- (void)setDatapoints:(NSArray *)datapoints
{
    _datapoints = datapoints;
    _percentages = @[];
    _sums = @[];
    [self parseDataPoints:datapoints];
    
}

- (void)parseDataPoints:(NSArray*)dataPoints
{
    _allDataPointsTotal = 0;
    _smallestIndex = 0;
    NSInteger __block smallestValue = NSIntegerMax;
    _largestIndex = 0;
    NSInteger __block largestValue = NSIntegerMin;
    NSMutableArray *sum = [[NSMutableArray alloc] init];
    NSMutableArray *percentages = [[NSMutableArray alloc] init];

    
    [dataPoints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger value = 0;
        if([obj isKindOfClass:[NSArray class]]){
            value = [self sumDataPoints:obj];
        }else if([obj isKindOfClass:[ARGraphDataPoint class]]) {
            value = [self sumDataPoints:@[obj]];
        }
        
        if(value < smallestValue){
            _smallestIndex = idx;
            smallestValue = value;
        }
        
        if(value > largestValue){
            _largestIndex = idx;
            largestValue = value;
        }
        [sum addObject:@(value)];

        _allDataPointsTotal += value;
    }];
    
    for (NSInteger x = 0; x < dataPoints.count; x++) {
        [percentages addObject:@([[sum objectAtIndex:x] doubleValue] / (double)_allDataPointsTotal)];
    }
    _sums = sum;
    _percentages = percentages;
}

- (NSInteger)sumDataPoints:(NSArray*)dataPoints
{
    NSInteger __block sum = 0;
    [dataPoints enumerateObjectsUsingBlock:^(ARGraphDataPoint *dataPoint, NSUInteger idx, BOOL *stop) {
        sum += dataPoint.yValue;
    }];
    return sum;
}

#pragma mark - Public Methods

- (CGFloat)slicePercentageAtIndex:(NSUInteger)index
{
    if(index < self.datapoints.count){
        CGFloat sectionSum =  [_sums[index] doubleValue];
        return sectionSum / (CGFloat)_allDataPointsTotal;
    }else {
        return 0.0;
    }
}

- (CGFloat)sliceSumAtIndex:(NSUInteger)index
{
    if(index < self.datapoints.count){
        return [_sums[index] doubleValue];
    }else {
        return NSNotFound;
    }
}

- (NSInteger)datapointsTotal
{
    return _allDataPointsTotal;
}

- (NSUInteger)largestSliceIndex
{
    return _largestIndex;
}

- (NSUInteger)smallestSliceIndex
{
    return _smallestIndex;
}
@end
