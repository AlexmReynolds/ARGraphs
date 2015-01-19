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

// This does a full reload. Very bad for perfromance if chart is live updating. User AppendDataPoint instead
- (void)reloadData;
@end

@protocol ARGraphXLegendDelegate <NSObject>
@required
- (NSString*)xLegend:(ARGraphXLegendView*)lengend labelForXLegendAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfDataPoints;
@end