//
//  ARPieChart.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARGraphDataPoint.h"

@protocol ARPieChartDataSource;

@interface ARPieChart : UIView
@property (nonatomic, weak) id <ARPieChartDataSource> dataSource;

@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic) CGFloat sliceGutterWidth;
@property (nonatomic) CGFloat innerRadiusPercent;
@property (nonatomic) BOOL useBackgroundGradient;
@property (nonatomic) UIEdgeInsets insets;
@end

@protocol ARPieChartDataSource <NSObject>
@required
- (NSArray *)ARPieChartDataPoints:(ARPieChart *)graph;

@optional
//- (NSArray*)ARPieChart:(ARPieChart*)chart dataPointForPieIndex:(NSUInteger)index;
//- (NSArray*)ARPieChart:(ARPieChart*)chart dataPointArrayForPieIndex:(NSUInteger)index;
- (NSString *)titleForPieChart:(ARPieChart *)chart;
- (NSString *)subTitleForPieChart:(ARPieChart *)chart;
- (NSString *)ARPieChart:(ARPieChart *)chart titleForPieIndex:(NSUInteger)index;
- (UIColor *)ARPieChart:(ARPieChart *)chart colorForSliceAtIndex:(NSUInteger)index;

@end