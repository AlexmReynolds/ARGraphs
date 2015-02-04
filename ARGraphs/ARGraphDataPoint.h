//
//  CYCGraphDataPoint.h
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ARGraphDataPoint : NSObject

/*!
 Create a data point with a specific @c x and @c y value.
 
 @param x value to save in @c xValue property
 @param y value to save in @c yValue property
 */
+ (instancetype)dataPointWithX:(CGFloat)x y:(CGFloat)y;

/*!
 Create a data point with a specific @c x and @c y value.
 
 @param x value to save in @c xValue property
 @param y value to save in @c yValue property
 */
- (instancetype)initWithX:(CGFloat)xValue y:(CGFloat)yValue;

- (instancetype)initWithY:(CGFloat)yValue;

/// x point value
@property (nonatomic) CGFloat xValue;
/// y point value
@property (nonatomic) CGFloat yValue;
@end
