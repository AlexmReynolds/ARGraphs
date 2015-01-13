//
//  CYCGraph.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/8/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARGraph.h"
#import "ARGraphPointsLayer.h"
#import "ARMinMaxLabelLayer.h"
#import "ARMeanLineLayer.h"

@interface ARGraph ()

//UI
@property (strong, nonatomic) NSLayoutConstraint *xAxisHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *titleHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *yAxisWidthConstraint;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@property (nonatomic, strong) UIView *xAxisContainerView;
@property (nonatomic, strong) UIView *yAxisContainerView;
@property (nonatomic, strong) UIView *titleContainerView;


@property (nonatomic, strong) CAGradientLayer *background;
@property (nonatomic, strong) ARGraphPointsLayer *pointsLayer;
@property (nonatomic, strong) ARMinMaxLabelLayer *minMaxLayer;
@property (nonatomic, strong) ARMeanLineLayer *meanLayer;


@property (nonatomic) NSUInteger dataCount;
@property (nonatomic, strong) NSArray *dataPoints;
@property (nonatomic, strong) NSString *xAxisTitle;

@end

@implementation ARGraph

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        //[[NSBundle mainBundle] loadNibNamed:@"CYCGraphView" owner:self options:nil];
        //_view.frame = self.bounds;
        //[self addSubview:_view];
        self.labelColor = [UIColor whiteColor];
        self.tintColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
        
        _background = [self makeGradientWithColor:self.tintColor];
        _background.frame = self.bounds;
        [self.layer insertSublayer:_background atIndex:0];
        
        _pointsLayer = [ARGraphPointsLayer layer];
        _pointsLayer.frame = self.bounds;
        [self.layer addSublayer:_pointsLayer];
        
        _minMaxLayer = [ARMinMaxLabelLayer layer];
        _minMaxLayer.frame = self.bounds;
        
        [self.layer addSublayer:_minMaxLayer];
        
        _meanLayer = [ARMeanLineLayer layer];
        _meanLayer.frame = self.bounds;
        
        [self.layer addSublayer:_meanLayer];
        
        self.titleContainerView.backgroundColor = [UIColor clearColor];
        self.xAxisContainerView.backgroundColor = [UIColor clearColor];
        self.yAxisContainerView.backgroundColor = [UIColor clearColor];

        [self setDefaults];

    }
    return self;
}

- (void)setDefaults
{
    self.showXLegend = YES;
    self.showYLegend = YES;
    self.showDots = YES;
    self.showMinMaxLines = YES;
    self.showMeanLine = YES;
    self.lineColor = [UIColor colorWithWhite:1.0 alpha:0.6];
}

#pragma mark - Setters

- (void)setDataSource:(id<ARGraphDataSource>)dataSource
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
        self.xAxisHeightConstraint.constant = [self sizeOfText:@"foo" preferredFontForTextStyle:UIFontTextStyleCaption1].height;
    }else {
        self.xAxisHeightConstraint.constant = 0.0;
        
    }
    [self.xAxisContainerView layoutIfNeeded];
    
}

- (void)setShowYLegend:(BOOL)showYLegend
{
    _showYLegend = showYLegend;
    if(_showYLegend){
        NSLog(@"show Legend");
        self.yAxisWidthConstraint.constant = [self sizeOfText:@"foo" preferredFontForTextStyle:UIFontTextStyleCaption1].width;
    }else {
        NSLog(@"hide Legend");

        self.yAxisWidthConstraint.constant = 0.0;

    }
    NSLog(@"constant is now %f", self.yAxisWidthConstraint.constant);

    [self.yAxisContainerView layoutIfNeeded];
    
}

- (void)setShowDots:(BOOL)showDots
{
    self.pointsLayer.showDots = showDots;
    CGFloat padding = 0;
    if(showDots){
        padding = 8;
    }
    self.pointsLayer.topPadding = padding;
    self.pointsLayer.bottomPadding = padding;
    self.minMaxLayer.bottomPadding = padding;
    self.minMaxLayer.topPadding = padding;
    self.meanLayer.bottomPadding = padding;
    self.meanLayer.topPadding = padding;
}

- (void)setShowMinMaxLines:(BOOL)showMinMaxLines
{
    self.minMaxLayer.hidden = !showMinMaxLines;
    if(showMinMaxLines){
        self.pointsLayer.rightPadding = 20;
    }else {
        self.pointsLayer.rightPadding = 0;
    }
}

- (void)setShowMeanLine:(BOOL)showMeanLine
{
    self.meanLayer.hidden = !showMeanLine;
}

- (void)setShouldSmooth:(BOOL)shouldSmooth
{
    self.pointsLayer.shouldSmooth = shouldSmooth;
}

- (void)setShouldFill:(BOOL)shouldFill
{
    self.pointsLayer.shouldFill = shouldFill;
}

- (void)setDotRadius:(CGFloat)dotRadius
{
    self.pointsLayer.dotRadius = dotRadius;
}

- (void)setLineColor:(UIColor *)lineColor
{
    self.pointsLayer.lineColor = lineColor.CGColor;
    self.minMaxLayer.lineColor = lineColor.CGColor;
    self.meanLayer.lineColor = lineColor.CGColor;
}

#pragma mark - Getters


- (NSString *)xAxisTitle
{
    if(_xAxisTitle == nil){
        if([self.dataSource respondsToSelector:@selector(argraphTitleForXAxis:)]){
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

- (NSArray*)dataPoints
{
    if(_dataPoints == nil){
        _dataPoints = [self.dataSource ARGraphDataPoints:self];
    }
    return _dataPoints;
}

- (UIColor *)labelColor
{
    if(_labelColor == nil){
        _labelColor = [UIColor whiteColor];
    }
    return _labelColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    if(_background != nil){
        [_background removeFromSuperlayer];
        _background = [self makeGradientWithColor:tintColor];
        _background.frame = self.bounds;
        [self.layer insertSublayer:_background atIndex:0];
    }

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
}


- (void)reloadData
{
    _dataCount = NSNotFound;
    if(self.showXLegend){
        [self setupXLegend];
    }
    
    if([self.dataSource respondsToSelector:@selector(titleForGraph:)]){
        self.titleLabel.text = [self.dataSource titleForGraph:self] ?: @"";
    }
    if([self.dataSource respondsToSelector:@selector(subTitleForGraph:)]){
        self.subtitleLabel.text = [self.dataSource subTitleForGraph:self] ?: @"";

    }
    
    self.minMaxLayer.minDataPoint = [self minDataPoint];
    self.minMaxLayer.maxDataPoint = [self maxDataPoint];
    [self.minMaxLayer setNeedsDisplay];
    
    self.pointsLayer.minDataPoint = [self minDataPoint];
    self.pointsLayer.maxDataPoint = [self maxDataPoint];
    self.pointsLayer.dataPoints = self.dataPoints;
    [self.pointsLayer setNeedsDisplay];
    
    self.meanLayer.minDataPoint = [self minDataPoint];
    self.meanLayer.maxDataPoint = [self maxDataPoint];
    self.meanLayer.mean = [self meanDataPoint];
    [self.meanLayer setNeedsDisplay];


    //purge
}

- (void)setupXLegend
{
    NSUInteger count = self.dataCount;
    [[self.xAxisContainerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int x = 0; x < count; x++) {
        [self.xAxisContainerView addSubview:[self labelForXAxisIndex:x]];
    }
}

- (UILabel*)labelForXAxisIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = self.labelColor;
    ARGraphDataPoint *dp = [self.dataPoints objectAtIndex:index];
    if(index == 0 && self.xAxisTitle){
        label.text = [NSString stringWithFormat:@"%@%li", self.xAxisTitle, (long)dp.xValue];

    }else{
        label.text = [NSString stringWithFormat:@"%li", (long)dp.xValue];
    }
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    [label sizeToFit];
    CGRect frame = label.frame;
    CGFloat centerPoint = [self xPositionForDataPointIndex:index totalPoints:self.dataCount inWidth:self.xAxisContainerView.frame.size.width];
    
    frame.origin.x = centerPoint - frame.size.width/2;
    label.frame = frame;
    return label;
}

#pragma mark - Helpers

- (CGFloat)xPositionForDataPointIndex:(NSInteger)index totalPoints:(NSInteger)total inWidth:(CGFloat)width
{
    CGFloat itemWidth = width/total;
    return index * itemWidth + itemWidth/2;
}


- (ARGraphDataPoint *)minDataPoint
{
    ARGraphDataPoint __block *minDP = nil;
    CGFloat __block value = CGFLOAT_MAX;
    [self.dataPoints enumerateObjectsUsingBlock:^(ARGraphDataPoint *dp, NSUInteger idx, BOOL *stop) {
        if(dp.yValue < value){
            minDP = dp;
            value = dp.yValue;
        }
    }];
    
    return minDP;
}

- (ARGraphDataPoint *)maxDataPoint
{
    ARGraphDataPoint __block *maxDP = nil;
    CGFloat __block value = CGFLOAT_MIN;
    [self.dataPoints enumerateObjectsUsingBlock:^(ARGraphDataPoint *dp, NSUInteger idx, BOOL *stop) {
        if(dp.yValue > value){
            maxDP = dp;
            value = dp.yValue;

        }
    }];

    return maxDP;
}

- (CGFloat)meanDataPoint
{
    CGFloat __block sum = 0;
    [self.dataPoints enumerateObjectsUsingBlock:^(ARGraphDataPoint *dp, NSUInteger idx, BOOL *stop) {
        sum += dp.yValue;
    }];
    if(sum){
        return sum / self.dataCount;
    }else {
        return sum;
    }
}

#pragma mark - View Creation

- (CAGradientLayer*) makeGradientWithColor:(UIColor*)color {
    
    UIColor *colorOne = [self lightenColor:color withPercent:0.2];
    UIColor *colorTwo = [self darkenColor:color withPercent:0.2];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

- (UIView *)titleContainerView
{
    if(_titleContainerView == nil){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor greenColor];

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
- (UIView*)xAxisContainerView
{
    if(_xAxisContainerView == nil){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blueColor];

        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.yAxisContainerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        self.xAxisHeightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self addConstraints:@[bottom, left, right, self.xAxisHeightConstraint]];
        
        _xAxisContainerView = view;

    }

    return _xAxisContainerView;
}

- (UIView*)yAxisContainerView
{
    if(_yAxisContainerView == nil){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor redColor];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        self.yAxisWidthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self addConstraints:@[bottom, left, top, self.yAxisWidthConstraint]];
        _yAxisContainerView = view;

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

- (UIColor *)darkenColor:(UIColor*)color withPercent:(CGFloat)percent {
    percent = fabs(percent);
    UIColor *clr = nil;
    while (percent > 1.0f) {
        percent /= 10.0f;
    }
    
    percent = 1 - percent;
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(color.CGColor);
    
    CGFloat hue, sat, brightness, alpha, white;
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB) {
        if ([color getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha]) {
            clr = [UIColor colorWithHue:hue saturation:sat brightness:fabs(MIN(brightness * percent, 1.0)) alpha:alpha];
        }
        
    } else if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome) {
        if ([color getWhite:&white alpha:&alpha]) {
            clr = [UIColor colorWithWhite:fabs(MIN(white * percent, 1.0)) alpha:alpha];
        }
    }
    
    return clr;
}

- (UIColor *)lightenColor:(UIColor*)color withPercent:(CGFloat)percent {
    percent = fabs(percent);
    UIColor *clr = nil;
    while (percent > 1.0f) {
        percent /= 10.0f;
    }
    percent += 1;
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(color.CGColor);
    
    CGFloat hue, sat, brightness, alpha, white;
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB) {
        if ([color getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha]) {
            //            DDLogVerbose(@"getHue passed");
            clr = [UIColor colorWithHue:hue saturation:sat brightness:fabs(MIN(brightness * percent, 1.0)) alpha:alpha];
        }
        
    } else if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome) {
        if ([color getWhite:&white alpha:&alpha]) {
            //            DDLogVerbose(@"getWhite passed");
            clr = [UIColor colorWithWhite:fabs(MIN(white * percent, 1.0)) alpha:alpha];
        }
    }
    
    return clr;
}

@end
