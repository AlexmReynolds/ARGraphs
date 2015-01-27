//
//  ARLineGraphYLegendView.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/27/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ARLineGraphYLegendDelegate;
@interface ARLineGraphYLegendView : UIView
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) id <ARLineGraphYLegendDelegate> delegate;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic) BOOL showXValues;
- (void)reloadData;
@end

@protocol ARLineGraphYLegendDelegate <NSObject>
@required
- (NSString*)titleForYLegend:(ARLineGraphYLegendView*)lengend;
- (NSInteger)yLegend:(ARLineGraphYLegendView*)lengend valueAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfDataPoints;
@end