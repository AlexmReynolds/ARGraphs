//
//  ARLineGraphYLegendView.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/27/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARLineGraphYLegendView.h"
#import "ARHelpers.h"

@interface ARLineGraphYLegendView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic) NSInteger totalNumberOfLabels;
@property (nonatomic) NSRange range;

@end

static CGFloat kPaddingBetweenLabels = 2.0;

@implementation ARLineGraphYLegendView{
    NSArray *_labels;
    NSRange _range;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.titleLabel];
        [self addTitleLabelConstraints];
        self.labelColor = [UIColor whiteColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview){
        self.leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self.superview addConstraints:@[self.leftConstraint, self.widthConstraint]];
    }
}
#pragma mark - Setters

- (void)setYMax:(NSInteger)yMax
{
    _yMax = yMax;
    self.range = NSMakeRange(_yMin, _yMax - _yMin);

    if(self.widthConstraint.constant > 0){
        self.widthConstraint.constant = [self contentSize].width;
        [self.superview layoutIfNeeded];
    }

}

- (void)setYMin:(NSInteger)yMin
{
    _yMin = yMin;
    self.range = NSMakeRange(_yMin, _yMax - _yMin);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    if(self.widthConstraint.constant > 0){
        self.widthConstraint.constant = [self contentSize].width;
        [self.superview layoutIfNeeded];
    }

}

- (void)setRange:(NSRange)range
{
    _range = range;
    if(range.length > 0){
        [self createOrUpdateLabels];
    }
}

- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    self.titleLabel.textColor = labelColor;
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        label.textColor = labelColor;
    }];
}
 
#pragma mark - Getters

- (CGSize)contentSize
{
    CGFloat width = 0;
    CGFloat widthOfTestString = [ARHelpers widthOfCaptionText:[NSString stringWithFormat:@"%li", _yMax] inHeight:self.bounds.size.height];

    if(_title != nil && _title.length){
        width = [ARHelpers heightOfCaptionText:self.title inWidth:self.bounds.size.width] + widthOfTestString + 6;
    }else{
        width = widthOfTestString;
    }
    return CGSizeMake(width, self.bounds.size.height);
}
- (UILabel*)titleLabel
{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = _title;
        label.textColor = self.labelColor;
        label.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));

        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [label sizeToFit];
        _titleLabel = label;
    }
    return _titleLabel;
}

#pragma mark - Helpers

- (void)createOrUpdateLabels
{
    if(self.showYValues){
        NSInteger canFit = [self numberOfLabelsForHeight:self.bounds.size.height];
        if(_totalNumberOfLabels != canFit){
            _totalNumberOfLabels = MIN(canFit,_range.length + 1);
            [self createMissingLabelsOrDeleteExtras];
        //    [self updateLabelValues];
            
        }else{
            [self updateAllLabelValues];
        }
    }else {
        [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _labels = @[];
    }
}

- (void)createMissingLabelsOrDeleteExtras
{
    NSMutableArray *copiedLabels = [NSMutableArray arrayWithArray:_labels];
    NSArray *increments = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:_range];
    CGFloat stringHeight = [ARHelpers heightOfCaptionText:@"foo" inWidth:self.bounds.size.width];
    NSArray *yPositionIncrements = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:NSMakeRange(0, self.bounds.size.height - stringHeight)];
    [ARHelpers CRUDObjectsWithExisting:_labels totalNeeded:_totalNumberOfLabels create:^(NSInteger index) {
        NSInteger inverseYPosition = yPositionIncrements.count - index - 1;
        UILabel *label = [self makeLabel];
        [self updateLabel:label yValue:[yPositionIncrements[inverseYPosition] floatValue] value:increments[index]];
        [self addSubview:label];
        [copiedLabels addObject:label];
    } delete:^(NSInteger index) {
        [[copiedLabels objectAtIndex:index] removeFromSuperview];
        [copiedLabels removeObjectAtIndex:index];
    } update:^(NSInteger index) {
        
        NSInteger inverseYPosition = yPositionIncrements.count - index - 1;
        [self updateLabel:copiedLabels[index] yValue:[yPositionIncrements[inverseYPosition] floatValue] value:increments[index]];
    }];
    _labels = copiedLabels;
}

- (void)updateAllLabelValues
{
    NSArray *copiedLabels = [_labels copy];
    NSArray *increments = [ARHelpers incrementArrayForNumberOfItems:copiedLabels.count range:_range];
    NSArray *yPositionIncrements = [ARHelpers incrementArrayForNumberOfItems:copiedLabels.count range:NSMakeRange(0, self.bounds.size.height)];

    [copiedLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        NSInteger inverseYPosition = yPositionIncrements.count - index - 1;
        [self updateLabel:label yValue:[yPositionIncrements[inverseYPosition] floatValue] value:increments[index]];
    }];
}

- (void)updateLabel:(UILabel*)label yValue:(CGFloat)yValue value:(NSNumber*)value
{
    label.textColor = self.labelColor;
    label.text = [NSString stringWithFormat:@"%li",[value integerValue]];
    [self updateFrameOfLabel:label yValue:yValue];
}

- (UILabel*)makeLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = self.labelColor;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    return label;
}

- (NSString*)labelTextAtIndex:(NSInteger)index increment:(NSInteger)increment
{
    return [NSString stringWithFormat:@"%ld", _yMin + index * increment];
}

- (void)updateFrameOfLabel:(UILabel*)label yValue:(CGFloat)yValue
{
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.x = self.bounds.size.width - frame.size.width;
    frame.origin.y = yValue;
    label.frame = frame;
}
- (NSUInteger)numberOfLabelsForHeight:(CGFloat)height
{
    NSString *testString = @"1234";
    CGFloat heightOfTestString = [ARHelpers heightOfCaptionText:testString inWidth:self.bounds.size.width];
    NSUInteger numberofLabels =  floor(height / (heightOfTestString + kPaddingBetweenLabels));
    return numberofLabels;
}

- (void)addTitleLabelConstraints
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    [self addConstraints:@[leftConstraint, centerY]];
}

@end
