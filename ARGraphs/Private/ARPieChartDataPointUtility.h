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

@property (nonatomic, readonly) NSArray *sums;
@property (nonatomic, readonly) NSArray *percentages;


- (CGFloat)slicePercentageAtIndex:(NSUInteger)index;
- (CGFloat)sliceSumAtIndex:(NSUInteger)index;
- (NSInteger)datapointsTotal;
- (NSUInteger)largestSliceIndex;
- (NSUInteger)smallestSliceIndex;

@end
