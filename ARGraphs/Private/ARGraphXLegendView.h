//
//  ARGraphXLegendView.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARGraphXLegendDelegate;
@interface ARGraphXLegendView : UIView

@property (nonatomic, weak) id <ARGraphXLegendDelegate> delegate;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic) BOOL showXValues;
// This does a full reload. Very bad for perfromance if chart is live updating. User AppendDataPoint instead
- (void)reloadData;
@end

@protocol ARGraphXLegendDelegate <NSObject>
@required
- (NSString*)titleForXLegend:(ARGraphXLegendView*)lengend;
- (NSInteger)xLegend:(ARGraphXLegendView*)lengend valueAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfDataPoints;
@end