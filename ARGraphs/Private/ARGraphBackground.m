//
//  ARGraphBackground.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARGraphBackground.h"
#import "ARHelpers.h"

@implementation ARGraphBackground
+ (instancetype) gradientWithColor:(CGColorRef)color {
    
    CGColorRef colorOne = [ARHelpers lightenColor:color withPercent:0.2];
    CGColorRef colorTwo = [ARHelpers darkenColor:color withPercent:0.2];
    //CGColorRelease(color);
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)(colorOne), colorTwo, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    ARGraphBackground *headerLayer = [ARGraphBackground layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    return headerLayer;
}


- (void)setColor:(CGColorRef)color
{
    CGColorRef colorOne = [ARHelpers lightenColor:color withPercent:0.2];
    CGColorRef colorTwo = [ARHelpers darkenColor:color withPercent:0.2];
    self.colors = [NSArray arrayWithObjects:(__bridge id)(colorOne), colorTwo, nil];
    
}

@end
