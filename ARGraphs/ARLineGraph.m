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
#import "ARLineGraphDataPointUtility.h"
#import "ARGraphBackground.h"


#import "ARLineGraphMean.h"

@interface ARLineGraph ()<ARGraphXLegendDelegate, ARLineGraphYLegendDelegate>

//UI
@property (nonatomic, strong) ARGraphBackground *background;

@property (strong, nonatomic) NSLayoutConstraint *titleHeightConstraint;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@property (nonatomic, strong) ARLineGraphXLegendView *xAxisContainerView;
@property (nonatomic, strong) ARLineGraphYLegendView *yAxisContainerView;
@property (nonatomic, strong) UIView *titleContainerView;


@property (nonatomic, strong) ARLineGraphPointsLayer *pointsLayer;
@property (nonatomic, strong) ARYMinMaxLayer *minMaxLayer;
@property (nonatomic, strong) ARLineGraphMean *meanLayer;


@property (nonatomic) NSUInteger dataCount;
@property (nonatomic, strong) NSArray *dataPoints;
@property (nonatomic, strong) NSString *xAxisTitle;
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
    self.showDots = YES;
    self.showMinMaxLines = YES;
    self.showMeanLine = YES;
    self.useBackgroundGradient = YES;
    self.showXLegendValues = YES;
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
    
    self.titleHeightConstraint.constant = [self sizeOfText:self.titleLabel.text preferredFontForTextStyle:UIFontTextStyleHeadline].height + 8;
    
    [self layoutIfNeeded];
    
    [self reloadData];
}

- (void)setShowXLegend:(BOOL)showXLegend
{
    _showXLegend = showXLegend;
    if(_showXLegend){
        self.xAxisContainerView.heightConstraint.constant = [self sizeOfText:@"foo" preferredFontForTextStyle:UIFontTextStyleCaption1].height;
    }else {
        self.xAxisContainerView.heightConstraint.constant = 0.0;
        
    }
    [self.xAxisContainerView layoutIfNeeded];
    
}

- (void)setShowYLegend:(BOOL)showYLegend
{
    _showYLegend = showYLegend;
    if(_showYLegend){
        self.yAxisContainerView.widthConstraint.constant = [self sizeOfText:@"foo" preferredFontForTextStyle:UIFontTextStyleCaption1].width;
    }else {
        self.yAxisContainerView.widthConstraint.constant = 0.0;

    }
    [self.yAxisContainerView layoutIfNeeded];
    
}

- (void)setShowDots:(BOOL)showDots
{
    _showDots = showDots;
    self.pointsLayer.showDots = showDots;
    CGFloat padding = 0;
    if(showDots){
        padding = self.pointsLayer.dotRadius + self.pointsLayer.lineWidth;
    }
    
    UIEdgeInsets oldPadding = self.subLayersPadding;
    oldPadding.top = padding;
    oldPadding.bottom = padding;
    self.subLayersPadding = oldPadding;
}

- (void)setShowMinMaxLines:(BOOL)showMinMaxLines
{
    _showMinMaxLines = showMinMaxLines;
    self.minMaxLayer.hidden = !showMinMaxLines;
    CGFloat padding = 0;
    if(showMinMaxLines){
        padding = 20;
    }
    UIEdgeInsets oldPadding = self.subLayersPadding;
    oldPadding.right = padding;
    self.subLayersPadding = oldPadding;
    self.xAxisContainerView.rightConstraint.constant = -padding;
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

- (void)setShowXLegendValues:(BOOL)showXLegendValues
{
    _showXLegendValues = showXLegendValues;
    self.xAxisContainerView.showXValues = showXLegendValues;
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
    
}

#pragma mark - Getters


- (NSString *)xAxisTitle
{
    if(_xAxisTitle == nil){
        if([self.dataSource respondsToSelector:@selector(ARGraphTitleForXAxis:)]){
            _xAxisTitle = [self.dataSource ARGraphTitleForXAxis:self];
        }else {
            nil;
        }
    }
    return _xAxisTitle;
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
    CGRect pointsLayerFrame = self.bounds;
    pointsLayerFrame.size.height -= self.xAxisContainerView.bounds.size.height;
    pointsLayerFrame.size.height -= self.titleContainerView.bounds.size.height;

    pointsLayerFrame.size.width -= self.yAxisContainerView.bounds.size.width;
    pointsLayerFrame.origin.y += self.titleContainerView.bounds.size.height;
    pointsLayerFrame.origin.x += self.yAxisContainerView.bounds.size.width;
    _pointsLayer.frame = pointsLayerFrame;
    _minMaxLayer.frame = pointsLayerFrame;
    _meanLayer.frame = pointsLayerFrame;
    _background.frame = self.bounds;
}

- (void)reloadData
{

    _dataPoints = [[self.dataSource ARGraphDataPoints:self] copy];
    _dataPointUtility.datapoints = _dataPoints;
    
    if([self.dataSource respondsToSelector:@selector(titleForGraph:)]){
        self.titleLabel.text = [self.dataSource titleForGraph:self] ?: @"";
    }
    if([self.dataSource respondsToSelector:@selector(subTitleForGraph:)]){
        self.subtitleLabel.text = [self.dataSource subTitleForGraph:self] ?: @"";
    }

    [self updateSubLayers];
}

- (void)updateSubLayers
{
    if(self.showXLegend){
        [self.xAxisContainerView reloadData];
    }
    
    NSInteger yMin = [[self dataPointUtility] yMin];
    NSInteger yMax = [[self dataPointUtility] yMax];
    self.minMaxLayer.yMin = yMin;
    self.minMaxLayer.yMax = yMax;
    [self.minMaxLayer setNeedsDisplay];
    
    self.pointsLayer.yMin = yMin;
    self.pointsLayer.yMax = yMax;
    self.pointsLayer.dataPoints = self.dataPoints;
    [self.pointsLayer setNeedsDisplay];
    
    self.meanLayer.yMin = yMin;
    self.meanLayer.yMax = yMax;
    self.meanLayer.yMean = [[self dataPointUtility] yMean];
    [self.meanLayer setNeedsDisplay];
}

#pragma mark - X Legend Delegate
- (NSString*)titleForXLegend:(ARLineGraphXLegendView *)lengend
{
    if([self.dataSource respondsToSelector:@selector(ARGraphTitleForXAxis:)]){
        return [self.dataSource ARGraphTitleForXAxis:self];
    }else{
        return nil;
    }
}
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

- (UIView *)titleContainerView
{
    if(_titleContainerView == nil){
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        self.titleHeightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self addConstraints:@[top, left, right, self.titleHeightConstraint]];
        _titleContainerView = view;
    }
    
    return _titleContainerView;
}
- (ARLineGraphXLegendView*)xAxisContainerView
{
    if(_xAxisContainerView == nil){
        ARLineGraphXLegendView *view = [[ARLineGraphXLegendView alloc] init];
        view.delegate = self;
        [self addSubview:view];
        view.leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.yAxisContainerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        [self addConstraint:view.leftConstraint];
        _xAxisContainerView = view;
        [self layoutIfNeeded];

    }

    return _xAxisContainerView;
}

- (ARLineGraphYLegendView*)yAxisContainerView
{
    if(_yAxisContainerView == nil){
        ARLineGraphYLegendView *view = [[ARLineGraphYLegendView alloc] init];
        view.delegate = self;
        [self addSubview:view];
        view.topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self addConstraint:view.topConstraint];
        _yAxisContainerView = view;
        [self layoutIfNeeded];

    }
    return _yAxisContainerView;
}

- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _titleLabel.text = @"foo";
        _titleLabel.textColor =  self.labelColor;

        [self.titleContainerView addSubview:_titleLabel];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_titleLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_titleLabel.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:8.0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.subtitleLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-10.0];

        [_titleLabel.superview addConstraints:@[centerY, left, right]];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if(_subtitleLabel == nil){
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _subtitleLabel.text = @"bar";
        _subtitleLabel.textColor = self.labelColor;
        [self.titleContainerView addSubview:_subtitleLabel];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-8.0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
        
        [_subtitleLabel.superview addConstraints:@[centerY, left, right]];
        [_subtitleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_subtitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    }
    return _subtitleLabel;
}

#pragma mark - Helpers

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
