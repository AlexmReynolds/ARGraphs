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

@protocol ARLineGraphDataSource;

@interface ARLineGraph : UIView

/*!
 @abstract The graph view.
 
 @see @c ARGraphDataSource for information on conforming DataSource protocol
 */

/// Data source the graph should pull its data from.
/// @note The dataSource is not retained.
@property (nonatomic, weak) id <ARLineGraphDataSource> dataSource;
/// The line color of the graph line.
@property (nonatomic, strong) UIColor *lineColor UI_APPEARANCE_SELECTOR;
/// The label color of the graph.
@property (nonatomic, strong) UIColor *labelColor UI_APPEARANCE_SELECTOR;

/// Set to @c YES to show the Y legend on the graph. @c NO to hide.
/// Default is @c YES.
@property (nonatomic) BOOL showYLegend UI_APPEARANCE_SELECTOR;
/// Set to @c YES to show the X legend on the graph. @c NO to hide.
/// Default is @c YES.
@property (nonatomic) BOOL showXLegend UI_APPEARANCE_SELECTOR;

@property (nonatomic) BOOL showXLegendValues UI_APPEARANCE_SELECTOR;

@property (nonatomic) BOOL useBackgroundGradient UI_APPEARANCE_SELECTOR;

/// Set to @c YES to only show the minimum and maximum Y legend markings on the graph. @c NO to hide.
/// Default is @c NO.
@property (nonatomic) BOOL showOnlyMinMaxYLegend UI_APPEARANCE_SELECTOR;

/// Set to @c YES to show a dot at each data point
/// Default is @c YES
@property (nonatomic) BOOL showDots UI_APPEARANCE_SELECTOR;
/// Configure the radius of each dot. Only used if @c showDots is @c YES
@property (nonatomic) CGFloat dotRadius UI_APPEARANCE_SELECTOR;
/// Set to @c YES to shade the area under the datapoints line.
/// Default is @c NO
@property (nonatomic) BOOL shouldFill UI_APPEARANCE_SELECTOR;
/// Set to @c YES to turn the data points into a smoothed line if enough points.
/// Default is @c NO
@property (nonatomic) BOOL shouldSmooth UI_APPEARANCE_SELECTOR;
/// Set to @c YES to show a line at the min Y and max Y values and label each value.
/// Default is @c YES
@property (nonatomic) BOOL showMinMaxLines UI_APPEARANCE_SELECTOR;
/// Set to @c YES to show an average line in the graph. @c NO to hide.
/// Default is @c YES
@property (nonatomic) BOOL showMeanLine UI_APPEARANCE_SELECTOR;

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

/*!
 @abstract Animate the graph into view
 
 @discussion This method is to reveal the graph and data when first shown or data updated
 */
- (void)beginAnimationIn;

@end


@protocol ARLineGraphDataSource <NSObject>
@required
/*!
 Get all the data points for a graph
 
 @param graph the @c ARGraph to get the points for
 
 @return array of @c ARGraphDataPoint objects
 */
- (NSArray*)ARGraphDataPoints:(ARLineGraph*)graph;
@optional
/*!
 Get the title for the graph.
 
 @param graph the @c ARGraph to get the title for
 
 @return title for the graph
 */
- (NSString*)titleForGraph:(ARLineGraph*)graph;

/*!
 Get the subtitle for the graph.
 
 @param graph the @c ARGraph to get the subtitle for
 
 @return subtitle for the graph
 */- (NSString*)subTitleForGraph:(ARLineGraph*)graph;

/*!
 Get the title for the X Axis of the graph.
 
 @param graph the @c ARGraph to get the X Axis title for
 
 @return title of the X Axis of the graph
 */
- (NSString*)ARGraphTitleForXAxis:(ARLineGraph *)graph;

/*!
 Get the title for the Y Axis of the graph.
 
 @param graph the @c ARGraph to get the Y Axis title for
 
 @return title of the Y Axis of the graph
 */- (NSString*)ARGraphTitleForYAxis:(ARLineGraph *)graph;

@end
