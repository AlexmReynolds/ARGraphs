//
//  ARGraphDataPointUtility.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/16/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARGraphDataPointUtility.h"
#import "ARGraphDataPoint.h"

@implementation ARGraphDataPointUtility{
    CGFloat _realMean;

}
- (instancetype)init
{
    self = [super init];
    [self resetValues];
    
    return self;
}

- (void)resetValues
{
    _yMin = 0;
    _yMax = 0;
    _yMean = 0;
    _xMax = 0;
    _xMin = 0;
    _realMean = 0.0;
}

- (void)setDatapoints:(NSArray *)datapoints
{
    _datapoints = datapoints;
    [self resetValues];
    if(_datapoints.count){
        [self setMaxMinMean];
    }
    
}

- (void)appendDataPoint:(ARGraphDataPoint *)dataPoint
{
    [self updateMinMaxMean:dataPoint];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.datapoints];
    [array addObject:dataPoint];
    _datapoints = array;
}

- (void)setMaxMinMean
{
    CGFloat __block minYValue = CGFLOAT_MAX;
    CGFloat __block maxYValue = CGFLOAT_MIN;
    CGFloat __block ySum = 0;
    
    [self.datapoints enumerateObjectsUsingBlock:^(ARGraphDataPoint *dp, NSUInteger idx, BOOL *stop) {
        if(dp.yValue < minYValue){
            minYValue = dp.yValue;
        }
        if(dp.yValue > maxYValue){
            maxYValue = dp.yValue;
            
        }
        ySum += dp.yValue;
    }];
    
    _yMax = maxYValue;
    _yMin = minYValue;
    
    if(ySum){
        _realMean = ySum / (CGFloat)self.datapoints.count;
        _yMean = floor(_realMean); // round down
    }else {
        _yMean = ySum;
    }
    
}

- (void)updateMinMaxMean:(ARGraphDataPoint*)newDataPoint
{
    _yMin = MIN(_yMin, newDataPoint.yValue);
    _yMax = MAX(_yMax, newDataPoint.yValue);
    _realMean = (_realMean * self.datapoints.count + newDataPoint.yValue)/(float)(self.datapoints.count + 1);
    _yMean = floor(_realMean); // round down
}
@end
