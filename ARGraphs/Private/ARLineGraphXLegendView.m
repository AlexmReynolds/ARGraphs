//
//  ARGraphxLegendView.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARLineGraphXLegendView.h"
#import "ARHelpers.h"
@interface ARLineGraphXLegendView ()
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ARLineGraphXLegendView{
    NSUInteger _totalNumberOfLabels;
    NSArray *_labels;
    NSUInteger _numberOfDataPoints;
    NSString *_title;

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
        self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        self.rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self.superview addConstraints:@[self.bottomConstraint, self.rightConstraint, self.heightConstraint]];
    }
    
}
#pragma mark - Setters

- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    _titleLabel.textColor = labelColor;
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        label.textColor = labelColor;
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    if(self.heightConstraint.constant > 0){
        self.heightConstraint.constant = [self contentSize].height;
        [self.superview layoutIfNeeded];
    }
}

- (void)reloadData
{
    _numberOfDataPoints = [self.delegate numberOfDataPoints];
    [self createOrUpdateLabels];
}

- (CGSize)contentSize
{
    CGFloat height = 0;
    CGFloat heightOfTestString = [ARHelpers heightOfCaptionText:@"1234" inWidth:self.bounds.size.width];
    if(self.showXValues){
        height += heightOfTestString;
    }
    if(_title != nil && _title.length){
        height += [ARHelpers heightOfCaptionText:_title inWidth:self.bounds.size.width];
        if(self.showXValues){
            height += 2;
        }
    }
    return CGSizeMake(self.bounds.size.width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self createOrUpdateLabels];
}

#pragma mark - Getter

- (UILabel*)titleLabel
{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = _title;
        label.textColor = self.labelColor;
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [label sizeToFit];
        _titleLabel = label;
    }
    return _titleLabel;
}

#pragma mark - Creation Methods

- (void)createOrUpdateLabels
{
    if(self.showXValues){
        NSUInteger canFit = [self numberOfLabelsForWidth:self.bounds.size.width];
        if(_totalNumberOfLabels != canFit){
            _totalNumberOfLabels = MIN(canFit, _numberOfDataPoints);
            [self createMissingLabelsOrDeleteExtras];
            [self updateAllLabelValues];

        }else{
            [self updateAllLabelValues];
        }
    }else {
        _totalNumberOfLabels = 0;
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
    NSInteger indexCounter = 0;
    NSInteger exisitngLabel = _labels.count;
    NSMutableArray *newLabels = [NSMutableArray arrayWithArray:_labels];
    for (indexCounter = 0; indexCounter < _totalNumberOfLabels; indexCounter++) {
        if(exisitngLabel <= indexCounter){
            //create label
            UILabel *label = [self createLabelForXAxisIndex:indexCounter];
            [self addSubview:label];
            [newLabels addObject:label];
        }
    };
    
    _labels = newLabels;
}

- (UILabel*)createLabelForXAxisIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = self.labelColor;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    return label;
}

- (void)deleteUnNeededLabels{
    NSMutableArray *newLabels = [NSMutableArray arrayWithArray:_labels];

    if(_labels.count > _totalNumberOfLabels){
        NSInteger labelsToDelete = _labels.count - _totalNumberOfLabels;
        while(labelsToDelete){
            NSInteger index = _labels.count - labelsToDelete;
            [[newLabels objectAtIndex:index] removeFromSuperview];
            [newLabels removeObjectAtIndex:index];
            labelsToDelete--;
        }
    }
    _labels = newLabels;
}

#pragma mark - Update Methods

- (void)updateAllLabelValues
{
    if(_labels.count == 0){
        return;
    }
    NSArray *copiedLabels = [_labels copy];
    NSArray *labelIndexToDPIndexIncrements = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:NSMakeRange(0, _numberOfDataPoints - 1)];
    
    NSString *stringToMeasure = [self stringForXLegendAtIndex:[[labelIndexToDPIndexIncrements lastObject] integerValue]];
    CGFloat widthOfTestString = [ARHelpers widthOfCaptionText:stringToMeasure inHeight:self.bounds.size.height];

    NSArray *xPosiitonIncrements = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:NSMakeRange(0, self.bounds.size.width - widthOfTestString)];
    
    [copiedLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        [self updateLabel:label atindex:index dpIndex:labelIndexToDPIndexIncrements[index] xPosition:xPosiitonIncrements[index]];
    }];
}

- (void)updateLabel:(UILabel*)label atindex:(NSInteger)index dpIndex:(NSNumber*)dpIndex xPosition:(NSNumber*)xPosition
{
    label.textColor = self.labelColor;
    label.text = [self stringForXLegendAtIndex:[dpIndex integerValue]];
    [self updateFrameOfLabel:label value:[xPosition integerValue]];
}

- (void)updateFrameOfLabel:(UILabel*)label value:(NSUInteger)value
{
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.x = value;
    label.frame = frame;
}

- (NSString*)stringForXLegendAtIndex:(NSUInteger)index
{
    NSInteger value = [self.delegate xLegend:self valueAtIndex:index];
    return [NSString stringWithFormat:@"%li", (long)value];
}

- (CGFloat)xPositionForDataPointIndex:(NSInteger)index totalLabelCount:(NSInteger)total inWidth:(CGFloat)width
{
    NSString *testString = @"1234";
    CGFloat widthOfTestString = [ARHelpers widthOfCaptionText:testString inHeight:self.bounds.size.height];
    CGFloat availablePadding = width - (widthOfTestString * total);
    return (index * (widthOfTestString + availablePadding/total));
}

// We use a hardcoded string because we don't know the datapoint values yet
- (NSUInteger)numberOfLabelsForWidth:(CGFloat)width
{
    NSString *testString = @"1234";
    CGFloat widthOfTestString = [ARHelpers widthOfCaptionText:testString inHeight:self.bounds.size.height];
    NSUInteger numberofLabels =  ceil(width / widthOfTestString);
    return numberofLabels;
}

- (void)addTitleLabelConstraints
{
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    [self addConstraints:@[bottomConstraint, centerX]];
}
@end
