//
//  CYCGraphDataPoint.h
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARGraphDataPoint : NSObject
- (instancetype)initWithX:(NSInteger)xValue y:(NSInteger)yValue;
@property (nonatomic) NSInteger xValue;
@property (nonatomic) NSInteger yValue;
@end
