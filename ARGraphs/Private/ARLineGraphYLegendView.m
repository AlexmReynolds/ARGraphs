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
            _totalNumberOfLabels = canFit;
            [self createMissingLabelsOrDeleteExtras];
            [self updateLabelValues];
            
        }else{
            [self updateLabelValues];
        }
    }else {
        [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _labels = @[];
    }
}

- (void)createMissingLabelsOrDeleteExtras
{
    NSInteger exisitngLabel = _labels.count;
    NSInteger numberOfLabelsToCreate = _totalNumberOfLabels - exisitngLabel;
    
    if(numberOfLabelsToCreate > 0){
        [self createNewLabels];
    }else if(numberOfLabelsToCreate < 0) {
        [self deleteUnNeededLabels];
    }
}
- (void)createNewLabels
{
    NSInteger exisitngLabel = _labels.count;
    NSMutableArray *newLabels = [NSMutableArray arrayWithArray:_labels];
    NSInteger indexCounter = 0;
    NSArray *increments = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:_range];

    for (indexCounter = 0; indexCounter < _totalNumberOfLabels; indexCounter++) {
        if(exisitngLabel > indexCounter){
            // updated Label
        }else {
            //create laebl
            UILabel *label = [self labelForYAxisIndex:indexCounter value:increments[indexCounter]];
            [self addSubview:label];
            [newLabels addObject:label];
        }
    };
    
    _labels = newLabels;
    
}
- (void)deleteUnNeededLabels{
    NSMutableArray *newLabels = [NSMutableArray arrayWithArray:_labels];
    
    if(_labels.count > _totalNumberOfLabels){
        NSInteger labelsToDelete = _labels.count - _totalNumberOfLabels;
        for (NSInteger x = 1; x < labelsToDelete; x++) {
            NSInteger index = _labels.count - x;
            [[newLabels objectAtIndex:index] removeFromSuperview];
            [newLabels removeObjectAtIndex:index];
            labelsToDelete--;
        }
    }
    _labels = newLabels;
}

- (void)updateLabelValues
{
    NSArray *copiedLabels = [_labels copy];
    NSArray *increments = [ARHelpers incrementArrayForNumberOfItems:copiedLabels.count range:_range];
    [copiedLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        [self updateLabel:label atindex:index value:increments[index]];
    }];
}

- (void)updateLabel:(UILabel*)label atindex:(NSInteger)index value:(NSNumber*)value
{

    label.textColor = self.labelColor;
    label.text = [NSString stringWithFormat:@"%li",[value integerValue]];
    [self updateFrameOfLabel:label atIndex:index];
}

- (UILabel*)labelForYAxisIndex:(NSInteger)index value:(NSNumber*)value
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = self.labelColor;
    label.text = [NSString stringWithFormat:@"%li",[value integerValue]];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self updateFrameOfLabel:label atIndex:index];
    
    return label;
}

- (NSString*)labelTextAtIndex:(NSInteger)index increment:(NSInteger)increment
{
    return [NSString stringWithFormat:@"%ld", _yMin + index * increment];
}

- (void)updateFrameOfLabel:(UILabel*)label atIndex:(NSUInteger)index
{
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.x = self.bounds.size.width - frame.size.width;
    frame.origin.y = [self yPositionForLabelIndex:index totalLabelCount:_totalNumberOfLabels inHeight:self.bounds.size.height];
    label.frame = frame;
}
- (CGFloat)yPositionForLabelIndex:(NSInteger)index totalLabelCount:(NSInteger)total inHeight:(CGFloat)height
{
    NSString *testString = @"1234";
    CGFloat heightOfTestString = [ARHelpers heightOfCaptionText:testString inWidth:self.bounds.size.width];
    CGFloat availablePadding = height - (heightOfTestString * total);
    NSInteger inverseIndex = _totalNumberOfLabels - index - 1;
    return (inverseIndex * (heightOfTestString + availablePadding/total));
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
