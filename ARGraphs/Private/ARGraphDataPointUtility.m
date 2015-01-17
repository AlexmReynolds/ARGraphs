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
    _yMin = 0;
    _yMax = 0;
    _yMean = 0;
    _xMax = 0;
    _xMin = 0;
    
    return self;
}
- (void)setDatapoints:(NSArray *)datapoints
{
    _datapoints = datapoints;
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
    _yMax = [[self.datapoints valueForKeyPath:@"@max.yValue"] integerValue];
    _yMin = [[self.datapoints valueForKeyPath:@"@min.yValue"] integerValue];
    _yMean = [[self.datapoints valueForKeyPath:@"@avg.yValue"] integerValue];
}

- (void)updateMinMaxMean:(ARGraphDataPoint*)newDataPoint
{
    _yMin = MIN(_yMin, newDataPoint.yValue);
    _yMax = MAX(_yMax, newDataPoint.yValue);
    _realMean = (_realMean * self.datapoints.count + newDataPoint.yValue)/(float)(self.datapoints.count + 1);
    _yMean = floor(_realMean); // round down
}
@end
