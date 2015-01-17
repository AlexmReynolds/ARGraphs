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

/*!
 @abstract The graph view.
 
 @see @c ARGraphDataSource for information on conforming DataSource protocol
 */
@interface ARGraph : UIView
#pragma mark - Properties
/// The view the graph should embed it self in
@property (strong, nonatomic) IBOutlet UIView *view;

/// Data source the graph should pull its data from.
/// @note The dataSource is not retained.
@property (nonatomic, weak) id <ARGraphDataSource> dataSource;
/// The line color of the graph line.
@property (nonatomic, strong) UIColor *lineColor;
/// The label color of the graph.
@property (nonatomic, strong) UIColor *labelColor;

/// Set to @c YES to show the Y legend on the graph. @c NO to hide.
/// Default is @c YES.
@property (nonatomic) BOOL showYLegend;
/// Set to @c YES to show the X legend on the graph. @c NO to hide.
/// Default is @c YES.
@property (nonatomic) BOOL showXLegend;
/// Set to @c YES to only show the minimum and maximum Y legend markings on the graph. @c NO to hide.
/// Default is @c NO.
@property (nonatomic) BOOL showOnlyMinMaxYLegend;

/// Set to @c YES to show a dot at each data point
/// Default is @c YES
@property (nonatomic) BOOL showDots;
/// Configure the radius of each dot. Only used if @c showDots is @c YES
@property (nonatomic) CGFloat dotRadius;
/// Set to @c YES to shade the area under the datapoints line.
/// Default is @c NO
@property (nonatomic) BOOL shouldFill;
/// Set to @c YES to turn the data points into a smoothed line if enough points.
/// Default is @c NO
@property (nonatomic) BOOL shouldSmooth;
/// Set to @c YES to show a line at the min Y and max Y values and label each value.
/// Default is @c YES
@property (nonatomic) BOOL showMinMaxLines;
/// Set to @c YES to show an average line in the graph. @c NO to hide.
/// Default is @c YES
@property (nonatomic) BOOL showMeanLine;

#pragma mark - Methods
/*! 
 Full reload of the graph
 
 @note Very bad for performance if chart is live updating. If Live updating is preffered, Use @c appendDataPoint: instead
 */
- (void)reloadData;

/*! 
 @abstract Append a data point to the current graph.
 
 @discussion This method is ideal for live updates to the chart 
 Also preferred if data set is constantly growing
 
 @param dataPoint data point to append to the current graph
 */
- (void)appendDataPoint:(ARGraphDataPoint*)dataPoint;

@end


@protocol ARGraphDataSource <NSObject>

/*!
 Get all the data points for a graph
 
 @param graph the @c ARGraph to get the points for
 
 @return array of @c ARGraphDataPoint objects
 */
- (NSArray*)ARGraphDataPoints:(ARGraph*)graph;

/*!
 Get the title for the graph.
 
 @param graph the @c ARGraph to get the title for
 
 @return title for the graph
 */
- (NSString*)titleForGraph:(ARGraph*)graph;

/*!
 Get the subtitle for the graph.
 
 @param graph the @c ARGraph to get the subtitle for
 
 @return subtitle for the graph
 */- (NSString*)subTitleForGraph:(ARGraph*)graph;

/*!
 Get the title for the X Axis of the graph.
 
 @param graph the @c ARGraph to get the X Axis title for
 
 @return title of the X Axis of the graph
 */
- (NSString*)ARGraphTitleForXAxis:(ARGraph *)graph;

/*!
 Get the title for the Y Axis of the graph.
 
 @param graph the @c ARGraph to get the Y Axis title for
 
 @return title of the Y Axis of the graph
 */- (NSString*)ARGraphTitleForYAxis:(ARGraph *)graph;

@end
