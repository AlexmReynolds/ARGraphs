//
//  CYCGraph.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARLineGraph.h"
#import "ARLineGraphPointsLayer.h"
#import "ARYMinMaxLayer.h"
#import "ARLineGraphXLegendView.h"
#import "ARLineGraphYLegendView.h"
#import "ARGraphTitleView.h"
#import "ARLineGraphDataPointUtility.h"
#import "ARGraphBackground.h"


#import "ARLineGraphMean.h"

@interface ARLineGraph ()<ARGraphXLegendDelegate>

//UI
@property (nonatomic, strong) ARGraphBackground *background;

@property (strong, nonatomic) NSLayoutConstraint *titleHeightConstraint;

@property (nonatomic, strong) ARLineGraphXLegendView *xAxisContainerView;
@property (nonatomic, strong) ARLineGraphYLegendView *yAxisContainerView;
@property (nonatomic, strong) ARGraphTitleView *titleContainerView;


@property (nonatomic, strong) ARLineGraphPointsLayer *pointsLayer;
@property (nonatomic, strong) ARYMinMaxLayer *minMaxLayer;
@property (nonatomic, strong) ARLineGraphMean *meanLayer;


@property (nonatomic) NSUInteger dataCount;
@property (nonatomic, strong) NSArray *dataPoints;
@property (nonatomic, strong) NSString *xAxisTitle;
@property (nonatomic, strong) NSString *yAxisTitle;

@property (nonatomic) UIEdgeInsets subLayersPadding;

@property (nonatomic, strong) ARLineGraphDataPointUtility *dataPointUtility;

@end

@implementation ARLineGraph

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    self.dataPointUtility = [[ARLineGraphDataPointUtility alloc] init];
    
    
    _background = [ARGraphBackground gradientWithColor:self.tintColor.CGColor];
    _background.frame = self.bounds;
    [self.layer insertSublayer:_background atIndex:0];
    
    _pointsLayer = [ARLineGraphPointsLayer layer];
    _pointsLayer.shouldRasterize = YES;
    _pointsLayer.frame = self.bounds;
    [self.layer addSublayer:_pointsLayer];
    
    _minMaxLayer = [ARYMinMaxLayer layer];
    _minMaxLayer.shouldRasterize = YES;
    _minMaxLayer.frame = self.bounds;
    
    [self.layer addSublayer:_minMaxLayer];
    
    _meanLayer = [ARLineGraphMean layer];
    _meanLayer.shouldRasterize = YES;
    _meanLayer.frame = self.bounds;
    
    [self.layer addSublayer:_meanLayer];
    
    [self applyDefaults];
}

- (void)applyDefaults
{
    self.backgroundColor = [UIColor clearColor];
    _labelColor = [UIColor whiteColor];
    self.xAxisContainerView.labelColor = _labelColor;

    self.tintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.showXLegend = YES;
    self.showYLegend = YES;
    self.normalizeXValues = NO;
    self.showDots = YES;
    self.showMinMaxLines = YES;
    self.showMeanLine = YES;
    self.useBackgroundGradient = YES;
    self.showXLegendValues = YES;
    self.showYLegendValues = YES;
    _lineColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.pointsLayer.lineColor = _lineColor.CGColor;
    self.minMaxLayer.lineColor = _lineColor.CGColor;
    self.meanLayer.lineColor = _lineColor.CGColor;
    self.insets = UIEdgeInsetsMake(4, 4, 4, 4);
}

#pragma mark - Setters

- (void)setUseBackgroundGradient:(BOOL)useBackgroundGradient
{
    _useBackgroundGradient = useBackgroundGradient;
    _background.hidden = !useBackgroundGradient;
}

- (void)setDataSource:(id<ARLineGraphDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setShowXLegend:(BOOL)showXLegend
{
    _showXLegend = showXLegend;
    [self layoutLegends];

}

- (void)setShowYLegend:(BOOL)showYLegend
{
    _showYLegend = showYLegend;

    [self layoutLegends];
}
- (void)setNormalizeXValues:(BOOL)normalizeXValues
{
    _normalizeXValues = normalizeXValues;
    self.pointsLayer.normalizeXValues = normalizeXValues;
    [self.pointsLayer layoutIfNeeded];
    self.xAxisContainerView.normalizeXValues = normalizeXValues;
}
- (void)setShowXLegendValues:(BOOL)showXLegendValues
{
    _showXLegendValues = showXLegendValues;
    self.xAxisContainerView.showXValues = showXLegendValues;
    [self layoutLegends];
}

- (void)setShowYLegendValues:(BOOL)showYLegendValues
{
    _showYLegendValues = showYLegendValues;
    self.yAxisContainerView.showYValues = showYLegendValues;
    [self layoutLegends];
}


- (void)setShowDots:(BOOL)showDots
{
    _showDots = showDots;
    self.pointsLayer.showDots = showDots;
    self.subLayersPadding = [self calculatePaddingForSubLayers];
}

- (void)setShowMinMaxLines:(BOOL)showMinMaxLines
{
    _showMinMaxLines = showMinMaxLines;
    self.minMaxLayer.hidden = !showMinMaxLines;
    self.subLayersPadding = [self calculatePaddingForSubLayers];
    if(self.showMinMaxLines){
        self.xAxisContainerView.rightConstraint.constant = -20;
    }else {
        self.xAxisContainerView.rightConstraint.constant = 0;
    }
}

- (void)setShowMeanLine:(BOOL)showMeanLine
{
    _showMeanLine = showMeanLine;
    self.meanLayer.hidden = !showMeanLine;
}

- (void)setShouldSmooth:(BOOL)shouldSmooth
{
    _shouldSmooth = shouldSmooth;
    self.pointsLayer.shouldSmooth = shouldSmooth;
}

- (void)setShouldFill:(BOOL)shouldFill
{
    _shouldFill = shouldFill;
    self.pointsLayer.shouldFill = shouldFill;
}

- (void)setDotRadius:(CGFloat)dotRadius
{
    _dotRadius = dotRadius;
    self.pointsLayer.dotRadius = dotRadius;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.pointsLayer.lineColor = lineColor.CGColor;
    self.minMaxLayer.lineColor = lineColor.CGColor;
    self.meanLayer.lineColor = lineColor.CGColor;
}
- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    self.xAxisContainerView.labelColor = labelColor;
    self.minMaxLayer.labelColor = labelColor.CGColor;
}
- (void)setSubLayersPadding:(UIEdgeInsets)subLayersPadding
{
    _subLayersPadding = subLayersPadding;
    self.pointsLayer.rightPadding = subLayersPadding.right;
    self.pointsLayer.topPadding = subLayersPadding.top;
    self.pointsLayer.bottomPadding = subLayersPadding.bottom;
    self.minMaxLayer.bottomPadding = subLayersPadding.bottom;
    self.minMaxLayer.topPadding = subLayersPadding.top;
    self.meanLayer.bottomPadding = subLayersPadding.bottom;
    self.meanLayer.topPadding = subLayersPadding.top;
    
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    if(_background != nil){
        self.background.color = tintColor.CGColor;
        _background.frame = self.bounds;
    }
    
}
- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    self.yAxisContainerView.leftConstraint.constant = insets.left;
    self.titleContainerView.topConstraint.constant = insets.top;
    self.titleContainerView.leftConstraint.constant = insets.left;
    self.titleContainerView.rightConstraint.constant = insets.right;
    [self layoutIfNeeded];
}
- (void)setAnimationDuration:(CGFloat)animationDuration
{
    _animationDuration = animationDuration;
    _pointsLayer.animationDuration = animationDuration;
}

#pragma mark - Getters


- (NSString *)xAxisTitle
{
    if([self.dataSource respondsToSelector:@selector(ARGraphTitleForXAxis:)]){
        return [self.dataSource ARGraphTitleForXAxis:self];
    }else {
        return nil;
    }
}

- (NSString *)yAxisTitle
{
    if([self.dataSource respondsToSelector:@selector(ARGraphTitleForYAxis:)]){
        return [self.dataSource ARGraphTitleForYAxis:self];
    }else {
        return nil;
    }
}

- (NSUInteger)dataCount
{
    return self.dataPoints.count;
}

- (void)appendDataPoint:(ARGraphDataPoint *)dataPoint
{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataPoints];
    [temp addObject:dataPoint];
    self.dataPoints = temp;
    [self.dataPointUtility appendDataPoint:dataPoint];
    [self updateSubLayers];
}

#pragma mark - Base MEthods

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect pointsLayerFrame = self.bounds;
    pointsLayerFrame.size.height -= (self.bounds.size.height - CGRectGetMinY(self.xAxisContainerView.frame));
    pointsLayerFrame.size.height -= CGRectGetMaxY(self.titleContainerView.frame);

    pointsLayerFrame.size.width -= (CGRectGetMaxX(self.yAxisContainerView.frame) + self.insets.right);
    pointsLayerFrame.origin.y += CGRectGetMaxY(self.titleContainerView.frame);
    pointsLayerFrame.origin.x += CGRectGetMaxX(self.yAxisContainerView.frame);
    _pointsLayer.frame = pointsLayerFrame;
    _minMaxLayer.frame = pointsLayerFrame;
    _meanLayer.frame = pointsLayerFrame;
    _background.frame = self.bounds;
}

- (void)layoutLegends
{
    if(self.showXLegend){
        self.xAxisContainerView.heightConstraint.constant = [self.xAxisContainerView contentSize].height;
    }else {
        self.xAxisContainerView.heightConstraint.constant = 0.0;
        
    }
    
    if(self.showYLegend){
        self.yAxisContainerView.widthConstraint.constant = [self.yAxisContainerView contentSize].width;
    }else {
        self.yAxisContainerView.widthConstraint.constant = 0.0;
    }
    NSLog(@"bottom Y is %f", self.yAxisContainerView.bottomConstraint.constant);
    [self layoutIfNeeded];
}

- (void)reloadData
{

    _dataPoints = [[self.dataSource ARGraphDataPoints:self] copy];
    _dataPointUtility.datapoints = _dataPoints;
    self.xAxisContainerView.title = self.xAxisTitle;
    self.yAxisContainerView.title = self.yAxisTitle;

    if([self.dataSource respondsToSelector:@selector(titleForGraph:)]){
        self.titleContainerView.title = [self.dataSource titleForGraph:self] ?: @"";
    }
    if([self.dataSource respondsToSelector:@selector(subTitleForGraph:)]){
        self.titleContainerView.subtitle = [self.dataSource subTitleForGraph:self] ?: @"";
    }

    [self updateSubLayers];
}

- (void)updateSubLayers
{


    NSInteger yMin = [[self dataPointUtility] yMin];
    NSInteger yMax = [[self dataPointUtility] yMax];
    NSInteger xMin = [[self dataPointUtility] xMin];
    NSInteger xMax = [[self dataPointUtility] xMax];
    if(yMax != NSNotFound && yMin != NSNotFound){
        self.minMaxLayer.yMin = yMin;
        self.minMaxLayer.yMax = yMax;
        [self.minMaxLayer setNeedsDisplay];
        
        self.pointsLayer.yMin = yMin;
        self.pointsLayer.yMax = yMax;
        self.pointsLayer.xMin = xMin;
        self.pointsLayer.xMax = xMax;
        self.pointsLayer.dataPoints = self.dataPoints;
        [self.pointsLayer setNeedsDisplay];
        
        self.meanLayer.yMin = yMin;
        self.meanLayer.yMax = yMax;
        self.meanLayer.yMean = [[self dataPointUtility] yMean];
        [self.meanLayer setNeedsDisplay];

        self.yAxisContainerView.yMax = yMax;
        self.yAxisContainerView.yMin = yMin;
        self.xAxisContainerView.xMax = xMax;
        self.xAxisContainerView.xMin = xMin;
    }
    
    if(self.showXLegend){
        [self.xAxisContainerView reloadData];
    }
    if(self.showYLegend){
        [self.yAxisContainerView reloadData];
    }

}
#pragma mark - X Legend Delegate
- (NSInteger)xLegend:(ARLineGraphXLegendView *)lengend valueAtIndex:(NSUInteger)index
{
    ARGraphDataPoint *dp = [self.dataPoints objectAtIndex:index];
    return dp.xValue;
}

- (NSUInteger)numberOfDataPoints
{
    return self.dataPoints.count;
}

#pragma mark - View Creation

- (ARGraphTitleView *)titleContainerView
{
    if(_titleContainerView == nil){
        ARGraphTitleView *view = [[ARGraphTitleView alloc] init];
        [self addSubview:view];
        _titleContainerView = view;
    }
    
    return _titleContainerView;
}
- (ARLineGraphXLegendView*)xAxisContainerView
{
    if(_xAxisContainerView == nil){
        _xAxisContainerView = [[ARLineGraphXLegendView alloc] init];
        _xAxisContainerView.delegate = self;
        [self addSubview:_xAxisContainerView];
        _xAxisContainerView.leftConstraint = [NSLayoutConstraint constraintWithItem:_xAxisContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.yAxisContainerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        [self addConstraint:_xAxisContainerView.leftConstraint];
        [self layoutIfNeeded];
    }

    return _xAxisContainerView;
}

- (ARLineGraphYLegendView*)yAxisContainerView
{
    if(_yAxisContainerView == nil){
        _yAxisContainerView = [[ARLineGraphYLegendView alloc] init];
        [self addSubview:_yAxisContainerView];
        _yAxisContainerView.topConstraint = [NSLayoutConstraint constraintWithItem:_yAxisContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        _yAxisContainerView.bottomConstraint = [NSLayoutConstraint constraintWithItem:_yAxisContainerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.xAxisContainerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        [self addConstraints:@[_yAxisContainerView.topConstraint, _yAxisContainerView.bottomConstraint]];
        [self layoutIfNeeded];

    }
    return _yAxisContainerView;
}

#pragma mark - Helpers
- (UIEdgeInsets)calculatePaddingForSubLayers
{
    CGFloat left = 0, right = 0, top = 0, bottom = 0;
    if(_showMinMaxLines){
        right += 20;
    }
    if(_showDots){
        top += self.pointsLayer.dotRadius + self.pointsLayer.lineWidth;
        bottom += self.pointsLayer.dotRadius + self.pointsLayer.lineWidth;
    }
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}
- (CGSize)sizeOfText:(NSString*)text preferredFontForTextStyle:(NSString*)style {
    UIFont *font = [UIFont preferredFontForTextStyle:style];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.attributedText = attributedText;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    font = nil;
    attributedText = nil;
    
    return size;
}

- (void)beginAnimationIn
{
    [_pointsLayer animate];
}

@end
