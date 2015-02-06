//
//  ARCircleGraph.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, ARCircleGraphTitlePosition){
    ARCircleGraphTitlePositionTop = 1,
    ARCircleGraphTitlePositionBottom
};

@interface ARCircleGraph : UIView

// Percent of the ring to draw from 0.0 to 1.0
@property (nonatomic) CGFloat percent;

// the numeric value of the label. This is used to count up to in animation
@property (nonatomic) CGFloat value;

// Formatted string to use like @"%.02f K"
@property (nonatomic, strong) NSString *valueFormat;

// string for chart title"
@property (nonatomic, strong) NSString *title;

// This will put the title above or below the ring graph
@property (nonatomic) ARCircleGraphTitlePosition titlePosition;

// lineWidth of the percent ring. Changing this will inset the label
@property (nonatomic) CGFloat lineWidth UI_APPEARANCE_SELECTOR;

// The duration of the animation for the counting label and ring
@property (nonatomic) CGFloat animationDuration UI_APPEARANCE_SELECTOR;

// Color to use for ring no matter the percent
@property (nonatomic) UIColor *ringColor UI_APPEARANCE_SELECTOR;

// Color to use for the inner label
@property (nonatomic) UIColor *labelColor UI_APPEARANCE_SELECTOR;

// Color to use for ring when percent is 1.0. Percentages between 0-1 will mix min max color
@property (nonatomic) UIColor *minColor UI_APPEARANCE_SELECTOR;

// Color to use for ring when percent is 0.0. Percentages between 0-1 will mix min max color
@property (nonatomic) UIColor *maxColor UI_APPEARANCE_SELECTOR;


/*!
 @abstract Animate the graph into view
 
 @discussion This method is to animate from 0 to our value and the ring
 */
- (void)beginAnimationIn;
@end
