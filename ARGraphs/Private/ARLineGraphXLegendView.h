//
//  ARGraphXLegendView.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARGraphXLegendDelegate;
@interface ARLineGraphXLegendView : UIView

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *rightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;

@property (nonatomic, weak) id <ARGraphXLegendDelegate> delegate;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic) BOOL showXValues;
// This does a full reload. Very bad for perfromance if chart is live updating. User AppendDataPoint instead
- (void)reloadData;
@end

@protocol ARGraphXLegendDelegate <NSObject>
@required
- (NSString*)titleForXLegend:(ARLineGraphXLegendView*)lengend;
- (NSInteger)xLegend:(ARLineGraphXLegendView*)lengend valueAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfDataPoints;
@end