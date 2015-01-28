//
//  ARLineGraphYLegendView.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/27/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ARLineGraphYLegendView : UIView
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;


@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic) BOOL showYValues;

@property (nonatomic) NSInteger yMax;
@property (nonatomic) NSInteger yMin;
@property (nonatomic, strong) NSString *title;

- (CGSize)contentSize;
@end

