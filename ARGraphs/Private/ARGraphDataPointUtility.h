//
//  ARGraphDataPointUtility.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/16/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ARGraphDataPoint;
@interface ARGraphDataPointUtility : NSObject

@property (nonatomic, copy) NSArray *datapoints;

@property (nonatomic, readonly) NSInteger yMax;
@property (nonatomic, readonly) NSInteger yMin;
@property (nonatomic, readonly) NSInteger xMax;
@property (nonatomic, readonly) NSInteger xMin;
@property (nonatomic, readonly) NSInteger yMean;

- (void)appendDataPoint:(ARGraphDataPoint*)dataPoint;

@end
