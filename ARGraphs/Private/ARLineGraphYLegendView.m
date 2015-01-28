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
        self.leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self.superview addConstraints:@[self.bottomConstraint, self.leftConstraint, self.widthConstraint]];
    }
}
#pragma mark - Setters

- (void)setYMax:(NSInteger)yMax
{
    _yMax = yMax;
    self.range = NSMakeRange(_yMin, _yMax - _yMin);
    CGSize sizeOfTestString = [self sizeOfText:[NSString stringWithFormat:@"%li", _yMax]];
    if(self.widthConstraint.constant > 0){
        self.widthConstraint.constant = sizeOfTestString.width + 4;
        [self.superview layoutIfNeeded];
    }

}

- (void)setYMin:(NSInteger)yMin
{
    _yMin = yMin;
    self.range = NSMakeRange(_yMin, _yMax - _yMin);

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
    _titleLabel.textColor = labelColor;
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        label.textColor = labelColor;
    }];
}
 
#pragma mark - Getters
- (UILabel*)titleLabel
{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc] init];
        label.text = _title;
        label.textColor = self.labelColor;
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
            [self createLabels];
        }else{
            [self updateLabelValues];
        }
    }else {
        [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _labels = @[];
    }
}
- (void)createLabels
{
    NSInteger exisitngLabel = _labels.count;
    NSMutableArray *newLabels = [NSMutableArray arrayWithArray:_labels];
    NSInteger indexCounter = 0;
    NSInteger numberOfLabelsToCreate = _totalNumberOfLabels - exisitngLabel;

    NSArray *increments = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:_range];

    for (indexCounter = 0; indexCounter < _totalNumberOfLabels; indexCounter++) {
        if(exisitngLabel > indexCounter){
            // updated Label
            UILabel *label = [newLabels objectAtIndex:indexCounter];
            [self updateLabel:label atindex:indexCounter value:increments[indexCounter]];
        }else {
            //create laebl
            UILabel *label = [self labelForYAxisIndex:indexCounter value:increments[indexCounter]];
            [self addSubview:label];
            [newLabels addObject:label];
        }
    };
    
    if(exisitngLabel > _totalNumberOfLabels){
        NSInteger labelsToDelete = exisitngLabel - numberOfLabelsToCreate;
        while(labelsToDelete--){
            [[_labels objectAtIndex:labelsToDelete] removeFromSuperview];
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
    frame.origin.y = [self yPositionForLabelIndex:index totalLabelCount:_totalNumberOfLabels inHeight:self.bounds.size.height];
    label.frame = frame;
}
- (CGFloat)yPositionForLabelIndex:(NSInteger)index totalLabelCount:(NSInteger)total inHeight:(CGFloat)height
{
    NSString *testString = @"1234";
    CGSize sizeOfTestString = [self sizeOfText:testString];
    CGFloat availablePadding = height - (sizeOfTestString.height * total);
    CGFloat offsetForTitleLabel = 0;
    if(_title != nil && _title.length){
        offsetForTitleLabel = _titleLabel.frame.size.height + kPaddingBetweenLabels;
        availablePadding -= offsetForTitleLabel;
    }
    
    NSInteger inverseIndex = _totalNumberOfLabels - index - 1;
    return (inverseIndex * (sizeOfTestString.height + availablePadding/total)) + offsetForTitleLabel;
}
- (NSUInteger)numberOfLabelsForHeight:(CGFloat)height
{
    NSString *testString = @"1234";
    CGSize sizeOfTestString = [self sizeOfText:testString];
    if(_title != nil && _title.length){
        height -= _titleLabel.frame.size.height + kPaddingBetweenLabels;
    }
    NSUInteger numberofLabels =  floor(height / (sizeOfTestString.height + kPaddingBetweenLabels));
    return numberofLabels;
}


- (CGSize)sizeOfText:(NSString*)text{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
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

@end
