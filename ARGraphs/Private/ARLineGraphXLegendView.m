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
        self.labelColor = [UIColor whiteColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.clipsToBounds = YES;
        [self addSubview:self.titleLabel];
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

- (void)reloadData
{
    _numberOfDataPoints = [self.delegate numberOfDataPoints];
    _title = [self.delegate titleForXLegend:self];
    if(_title != nil){
        _titleLabel.hidden = NO;
        _titleLabel.text = _title;
        [_titleLabel sizeToFit];
    }else{
        _titleLabel.hidden = YES;
    }
    [self createOrUpdateLabels];
}

- (void)createOrUpdateLabels
{
    if(self.showXValues){
        NSUInteger canFit = [self numberOfLabelsForWidth:self.bounds.size.width];
        if(_totalNumberOfLabels != canFit){
            _totalNumberOfLabels = MIN(canFit, _numberOfDataPoints);
            [self createLabels];
        }else{
            [self updateLabelValues];
        }
    }else {
        [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _labels = @[];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self createOrUpdateLabels];
}

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

- (void)createLabels
{
    NSInteger exisitngLabel = _labels.count;
    NSMutableArray *newLabels = [NSMutableArray arrayWithArray:_labels];
    NSInteger indexCounter = 0;
    NSInteger numberOfLabelsToCreate = _totalNumberOfLabels - exisitngLabel;
    NSArray *increments = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:NSMakeRange(0, _numberOfDataPoints - 1)];

    for (indexCounter = 0; indexCounter < _totalNumberOfLabels; indexCounter++) {
        if(exisitngLabel > indexCounter){
            // updated Label
            UILabel *label = [newLabels objectAtIndex:indexCounter];
            [self updateLabel:label atindex:indexCounter value:increments[indexCounter]];
        }else {
            //create laebl
            UILabel *label = [self labelForXAxisIndex:indexCounter];
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
    NSArray *increments = [ARHelpers incrementArrayForNumberOfItems:_totalNumberOfLabels range:NSMakeRange(0, _numberOfDataPoints - 1)];

    [copiedLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        [self updateLabel:label atindex:index value:increments[index]];
    }];
}

- (void)updateLabel:(UILabel*)label atindex:(NSInteger)index value:(NSNumber*)value
{
    label.textColor = self.labelColor;
    label.text = [self stringForXLegendAtIndex:[value integerValue]];
    [self updateFrameOfLabel:label atIndex:index];
}

- (UILabel*)labelForXAxisIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = self.labelColor;
    NSUInteger dpIndex = [self dataPointIndexForLabelIndex:index];
    if(dpIndex != NSNotFound){
        label.text = [self stringForXLegendAtIndex:dpIndex];
    }
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self updateFrameOfLabel:label atIndex:index];

    return label;
}

- (void)updateFrameOfLabel:(UILabel*)label atIndex:(NSUInteger)index
{
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.x = [self xPositionForDataPointIndex:index totalPoints:_totalNumberOfLabels inWidth:self.bounds.size.width];
    label.frame = frame;
}

- (NSUInteger)dataPointIndexForLabelIndex:(NSUInteger)labelIndex
{
    NSUInteger dpIndex = NSNotFound;
    if(_numberOfDataPoints > 0){
        if(labelIndex == _totalNumberOfLabels - 1){ // lastIndex
            dpIndex = _numberOfDataPoints -1;
        }else {
            CGFloat increment = (float)_numberOfDataPoints / ((float)_totalNumberOfLabels - 1.0);
            dpIndex = ceil((float)labelIndex * increment);
            
        }
    }
    return dpIndex;
}

- (NSString*)stringForXLegendAtIndex:(NSUInteger)index
{
    NSInteger value = [self.delegate xLegend:self valueAtIndex:index];
    return [NSString stringWithFormat:@"%li", (long)value];
}

- (CGFloat)xPositionForDataPointIndex:(NSInteger)index totalPoints:(NSInteger)total inWidth:(CGFloat)width
{
    CGFloat itemWidth = width/total;
    CGFloat offsetForTitleLabel = 0;
    if(_title != nil && _title.length){
        itemWidth = (width - _titleLabel.frame.size.width)/total;
        offsetForTitleLabel = _titleLabel.frame.size.width + itemWidth/2;
    }


    return index * itemWidth + offsetForTitleLabel;
}

- (NSUInteger)numberOfLabelsForWidth:(CGFloat)width
{
    NSString *testString = @"1234";
    CGSize sizeOfTestString = [self sizeOfText:testString];
    if(_title != nil && _title.length){
        width -= _titleLabel.frame.size.width + sizeOfTestString.width/2;
    }
    NSUInteger numberofLabels =  ceil(width / sizeOfTestString.width);
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
