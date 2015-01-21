//
//  ARPieChartDataPointUtility.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ARPieChartDataPointUtility : NSObject

@property (nonatomic, copy) NSArray *datapoints;

@property (nonatomic, readonly) NSInteger *sums;
@property (nonatomic, readonly) CGFloat *percentages;


- (double)slicePercentageAtIndex:(NSUInteger)index;
- (NSInteger)sliceSumAtIndex:(NSUInteger)index;
- (NSInteger)datapointsTotal;
- (NSUInteger)largestSliceIndex;
- (NSUInteger)smallestSliceIndex;

@end
