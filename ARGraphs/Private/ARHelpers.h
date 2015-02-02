//
//  ARHelpers.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/20/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class ARGraphDataPoint;

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * 180.0 / M_PI)


@interface ARHelpers : NSObject
/**
 *  @abstract Takes a CGColorRef and returns a new colorRef that has been darkened
 *
 *  @discussion Multiplies the color components of a CGColorRef by 1 - the percent passed in to darken all the color components
 *
 *  @param  color to darken
 *  @param  percent to use to darken the color by
 *  @return CGColorRef that has been darkened
 */
+ (CGColorRef)darkenColor:(CGColorRef)color withPercent:(CGFloat)percent;

/**
 *  @abstract Takes a CGColorRef and returns a new colorRef that has been lighten
 *
 *  @discussion Multiplies the color components of a CGColorRef by 1 + the percent passed in to lighten all the color components
 *
 *  @param  color to lighten
 *  @param  percent to use to lighten the color by
 *  @return CGColorRef that has been lightened
 */
+ (CGColorRef)lightenColor:(CGColorRef)color withPercent:(CGFloat)percent;

/**
 *  @abstract Makes a CGPoint that has been translated from its current position
 *
 *  @discussion Takes a given point and makes a point that has been translated away from the current point by a given amount based on an angle
 *
 *  @param  point to start from
 *  @param  inset to translate the point
 *  @param  angle to translate the point to
 *  @return CGPoint a new point that has been translated by the inset in the direction given
 */
+ (CGPoint)pointInCircle:(CGPoint)point insetFromCenterBy:(CGFloat)inset angle:(CGFloat)angle;

/**
 *  @abstract Makes an array of increments that spans a range
 *
 *  @discussion Creates an array of increments between a range. The first Increment will always be the starting number in the range. The last item will always be the end of the range. This is useful for calculating indexes or x,y positions. Given 300 pixes and 10 labels what are the x positions for them evenly spaced.
 *
 *  @param  numberOfItems is the number of increments needed
 *  @param  range for the increments to cover
 *  @return NSArray of NSNumbers that are the increments
 */
+ (NSArray *)incrementArrayForNumberOfItems:(NSInteger)numberOfItems range:(NSRange)range;

/**
 *  @abstract Measures a string at caption size
 *
 *  @discussion Measures a string fro Caption font size constrained to a width
 *
 *  @param  text to measure
 *  @param  width to fit the text into
 *  @return CGFloat of the string at the caption font size
 */
+ (CGFloat)heightOfCaptionText:(NSString*)text inWidth:(CGFloat)width;

/**
 *  @abstract Measures a string at caption size
 *
 *  @discussion Measures a string fro Caption font size constrained to a height
 *
 *  @param  text to measure
 *  @param  width to fit the text into
 *  @return CGFloat of the string at the caption font size
 */
+ (CGFloat)widthOfCaptionText:(NSString*)text inHeight:(CGFloat)height;

/**
 *  @abstract Calls CRUD blocks so we dont have to recreate exisiting items
 *
 *  @discussion Runs CRUD blocks to minimize unneeded creation of objects
 *
 *  @param  existing objects array
 *  @param  totalNeeded the amount of objects we need
 *  @param  createBlock block to call when totalNeeded is more than exisiting objects
 *  @param  deleteBlock block to call when totalNeeded is less than existing objects
 *  @param  updateBlock block to call when an object exists and should be update

 */
+ (void)CRUDObjectsWithExisting:(NSArray*)existing totalNeeded:(NSInteger)totalNeeded create:(void(^)(NSInteger index))createBlock delete:(void(^)(NSInteger index))deleteBlock update:(void(^)(NSInteger index))updateBlock;

/**
 *  @abstract Calls CRUD blocks so we dont have to recreate exisiting items
 *
 *  @discussion Runs CRUD blocks to minimize unneeded creation of objects
 *
 *  @param  dataPoint the datapoint value for this axis
 *  @param  availableHeight space in view that point can sit in
 *  @param  range that datapoint values lie between
 *  @return  CGFloat position for datapoint in view
 
 */
+ (CGFloat)yPositionForYDataPoint:(NSInteger)dataPoint availableHeight:(CGFloat)availableHeight yRange:(NSRange)range;
+ (CGPoint)positionForDataPoint:(ARGraphDataPoint*)dataPoint availableSize:(CGSize)availableSize yRange:(NSRange)yRange xRange:(NSRange)xRange;

@end
