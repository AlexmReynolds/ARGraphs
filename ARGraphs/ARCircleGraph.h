//
//  ARCircleGraph.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ARCircleGraph : UIView
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGFloat value;
@property (nonatomic, strong) NSString *valueFormat;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) UIColor *minColor;
@property (nonatomic) UIColor *maxColor;

@end
