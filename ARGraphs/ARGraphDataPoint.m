//
//  CYCGraphDataPoint.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARGraphDataPoint.h"

@implementation ARGraphDataPoint

+ (instancetype)dataPointWithX:(NSInteger)x y:(NSInteger)y {
    return [[self alloc] initWithX:x y:y];
}

- (instancetype)initWithX:(NSInteger)xValue y:(NSInteger)yValue
{
    self = [super init];
    self.xValue = xValue;
    self.yValue = yValue;
    return self;
}
@end
