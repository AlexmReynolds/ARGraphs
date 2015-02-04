//
//  CYCGraphDataPoint.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARGraphDataPoint.h"

@implementation ARGraphDataPoint

+ (instancetype)dataPointWithX:(CGFloat)x y:(CGFloat)y {
    return [[self alloc] initWithX:x y:y];
}

- (instancetype)initWithX:(CGFloat)xValue y:(CGFloat)yValue
{
    self = [super init];
    self.xValue = xValue;
    self.yValue = yValue;
    return self;
}

- (instancetype)initWithY:(CGFloat)yValue
{
    self = [super init];
    self.xValue = NSNotFound;
    self.yValue = yValue;
    return self;
}
@end
