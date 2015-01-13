//
//  CYCGraph.h
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARGraphDataPoint.h"

//typedef NS_OPTIONS(NSInteger, CYCGraphyLegendAlignment){
//    CYCGraphyLegendAlignmentLeft,
//    CYCGraphyLegendAlignmentRight
//};

@protocol ARGraphDataSource;

@interface ARGraph : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic, weak) id <ARGraphDataSource> dataSource;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *labelColor;

@property (nonatomic) BOOL showYLegend;
@property (nonatomic) BOOL showXLegend;
@property (nonatomic) BOOL showOnlyMinMaxYLegend;
- (void)reloadData;

//Chart options
// if showDots is true then dotRadius will be used for the dot size
@property (nonatomic) CGFloat dotRadius;
// shouldFill determines if the area under the datapoints line should be shaded
@property (nonatomic) BOOL shouldFill;
// shouldSmooth will turn the data points into a smoothed line if enough points
@property (nonatomic) BOOL shouldSmooth;
// showDots if true will add a dot at each data point
@property (nonatomic) BOOL showDots;
// showMinMaxLines will add a line at the min Y and max Y values and label each value
@property (nonatomic) BOOL showMinMaxLines;
// showMeanLine will add an average line in the graph
@property (nonatomic) BOOL showMeanLine;

@end

@protocol ARGraphDataSource <NSObject>

- (NSArray*)ARGraphDataPoints:(ARGraph*)graph;
- (NSString*)titleForGraph:(ARGraph*)graph;
- (NSString*)subTitleForGraph:(ARGraph*)graph;
- (NSString*)ARGraphTitleForXAxis:(ARGraph *)graph;
- (NSString*)ARGraphTitleForYAxis:(ARGraph *)graph;

@end
