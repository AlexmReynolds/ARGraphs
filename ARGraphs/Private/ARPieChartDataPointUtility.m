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
- (void)dealloc
{
    free(self.sums);
    free(self.percentages);

}
- (void)setDatapoints:(NSArray *)datapoints
{
    _datapoints = datapoints;
    [self allocateMemoriesForDataPoints:datapoints];
    [self parseDataPoints:datapoints];
    
}

- (void)allocateMemoriesForDataPoints:(NSArray*)dataPoints
{
    _sums = malloc(sizeof(NSInteger) * dataPoints.count);
    _percentages = malloc(sizeof(CGFloat) * dataPoints.count);
}

- (void)parseDataPoints:(NSArray*)dataPoints
{
    _allDataPointsTotal = 0;
    _smallestIndex = 0;
    NSInteger __block smallestValue = NSIntegerMax;
    _largestIndex = 0;
    NSInteger __block largestValue = NSIntegerMin;
    
    
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
        _sums[idx] = value;
        _allDataPointsTotal += value;
    }];
    
    for (NSInteger x = 0; x < dataPoints.count; x++) {
        _percentages[x] = (double)_sums[x] / (double)_allDataPointsTotal;
    }
    
    NSLog(@"smallest val: %li, largest val:%li", (long)smallestValue, (long)largestValue);
    NSLog(@"smallest idx: %li, largest idx:%li", (long)_smallestIndex, (long)_largestIndex);

}

- (NSInteger)sumDataPoints:(NSArray*)dataPoints
{
    NSInteger __block sum = 0;
    [dataPoints enumerateObjectsUsingBlock:^(ARGraphDataPoint *dataPoint, NSUInteger idx, BOOL *stop) {
        sum += dataPoint.yValue;
        NSLog(@"DP valu %li",dataPoint.yValue);

    }];
    return sum;
}

#pragma mark - Public Methods

- (double)slicePercentageAtIndex:(NSUInteger)index
{
    if(index < self.datapoints.count){
        NSInteger sectionSum =  _sums[index];
        return (double)sectionSum / (double)_allDataPointsTotal;
    }else {
        return 0.0;
    }
}

- (NSInteger)sliceSumAtIndex:(NSUInteger)index
{
    if(index < self.datapoints.count){
        return _sums[index];
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
