//
//  ARPieChart.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARGraphDataPoint.h"
#import "ARPieChartAnimationTypes.h"

@protocol ARPieChartDataSource;

@interface ARPieChart : UIView
@property (nonatomic, weak) id <ARPieChartDataSource> dataSource;
@property (nonatomic) ARSliceAnimation animationType;
@property (nonatomic, strong) UIColor *labelColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat sliceGutterWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat innerRadiusPercent UI_APPEARANCE_SELECTOR;
@property (nonatomic) BOOL useBackgroundGradient UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIEdgeInsets insets UI_APPEARANCE_SELECTOR;

/*!
 @abstract Animate the chart into view
 
 @discussion This method is to reveal the chart and data when first shown or data updated
 */
- (void)beginAnimationIn;
@end

@protocol ARPieChartDataSource <NSObject>
@required
- (NSArray *)ARPieChartDataPoints:(ARPieChart *)graph;

@optional
- (NSString *)titleForPieChart:(ARPieChart *)chart;
- (NSString *)subTitleForPieChart:(ARPieChart *)chart;
- (NSString *)ARPieChart:(ARPieChart *)chart titleForPieIndex:(NSUInteger)index;
- (UIColor *)ARPieChart:(ARPieChart *)chart colorForSliceAtIndex:(NSUInteger)index;

@end