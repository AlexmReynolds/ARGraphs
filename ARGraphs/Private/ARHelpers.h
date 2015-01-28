//
//  ARHelpers.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/20/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * 180.0 / M_PI)


@interface ARHelpers : NSObject
+ (CGColorRef)darkenColor:(CGColorRef)color withPercent:(CGFloat)percent;
+ (CGColorRef)lightenColor:(CGColorRef)color withPercent:(CGFloat)percent;
+ (CGPoint)pointInCircle:(CGPoint)point insetFromCenterBy:(CGFloat)inset angle:(CGFloat)angle;
+ (NSArray *)incrementArrayForNumberOfItems:(NSInteger)numberOfItems range:(NSRange)range;
@end
