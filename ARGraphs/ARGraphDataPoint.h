//
//  CYCGraphDataPoint.h
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARGraphDataPoint : NSObject

/*!
 Create a data point with a specific @c x and @c y value.
 
 @param x value to save in @c xValue property
 @param y value to save in @c yValue property
 */
+ (instancetype)dataPointWithX:(NSInteger)x y:(NSInteger)y;

/*!
 Create a data point with a specific @c x and @c y value.
 
 @param x value to save in @c xValue property
 @param y value to save in @c yValue property
 */
- (instancetype)initWithX:(NSInteger)xValue y:(NSInteger)yValue;

- (instancetype)initWithY:(NSInteger)yValue;

/// x point value
@property (nonatomic) NSInteger xValue;
/// y point value
@property (nonatomic) NSInteger yValue;
@end
