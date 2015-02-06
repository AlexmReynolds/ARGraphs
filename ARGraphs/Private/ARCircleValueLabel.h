//
//  ARCircleValueLabel.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARCircleValueLabel : UILabel

@property (nonatomic, strong) NSLayoutConstraint *left;
@property (nonatomic, strong) NSLayoutConstraint *right;
@property (nonatomic, strong) NSLayoutConstraint *top;
@property (nonatomic, strong) NSLayoutConstraint *bottom;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat currentValue;

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, copy) void (^completionBlock)();

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue;
-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromCurrentValueTo:(CGFloat)endValue;
-(void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromZeroTo:(CGFloat)endValue;
-(void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

@end
