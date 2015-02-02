//
//  ARGraphDataPointUtility.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/16/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARLineGraphDataPointUtility.h"
#import "ARGraphDataPoint.h"

@implementation ARLineGraphDataPointUtility{
    CGFloat _realYMean;
    CGFloat _realXMean;
}
- (instancetype)init
{
    self = [super init];
    [self resetValues];
    
    return self;
}

- (void)resetValues
{
    _realYMean = 0.0;
    _realXMean = 0.0;
    _yMax = NSNotFound;
    _yMin = NSNotFound;
    _xMax =  NSNotFound;
    _xMin = NSNotFound;
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

// Here we run 1 loop over all the datapoints to calculate our values
// We don't use valueForKeyPath:@"@max.yValue because we'd have to run 1 for each xMin, XMax etc.
// When using valueForKeyPath: we'd have to do this 6 times which on 40,000 Datapoints is 100 times slower
- (void)setMaxMinMean
{
    CGFloat sumX = 0;
    CGFloat sumY = 0;
    
    NSInteger numberOfItems = self.datapoints.count;
    while (numberOfItems--) {
        ARGraphDataPoint *dp = self.datapoints[numberOfItems];
        [self parseMinMaxForDataPoint:dp];
        sumX += dp.xValue;
        sumY += dp.yValue;
    }
    
    _realYMean = sumY / self.datapoints.count;
    _realXMean = sumX / self.datapoints.count;
    
    _yMean = floor(_realYMean); // round down
    _xMean = floor(_realXMean); // round down
}

- (void)updateMinMaxMean:(ARGraphDataPoint*)newDataPoint
{
    [self parseMinMaxForDataPoint:newDataPoint];
    _realXMean = (_realXMean * self.datapoints.count + newDataPoint.xValue)/(float)(self.datapoints.count + 1);
    _realYMean = (_realYMean * self.datapoints.count + newDataPoint.yValue)/(float)(self.datapoints.count + 1);
    _yMean = floor(_realYMean); // round down
    _xMean = floor(_realXMean); // round down

}

- (void)parseMinMaxForDataPoint:(ARGraphDataPoint*)dp
{
    _yMin = _yMin != NSNotFound ? _yMin : NSIntegerMax;
    _yMax = _yMax != NSNotFound ? _yMax : NSIntegerMin;
    _xMin = _xMin != NSNotFound ? _xMin : NSIntegerMax;
    _xMax = _xMax != NSNotFound ? _xMax : NSIntegerMin;
    
    _yMax = MAX(_yMax, dp.yValue);
    _yMin = MIN(_yMin, dp.yValue);
    _xMax = MAX(_xMax, dp.xValue);
    _xMin = MIN(_xMin, dp.xValue);
}

@end
