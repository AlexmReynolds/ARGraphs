//
//  ARGraphxLegendView.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARLineGraphXLegendView.h"

@interface ARLineGraphXLegendView ()
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation ARLineGraphXLegendView{
    NSUInteger _totalNumberOfLabels;
    NSArray *_labels;
    NSUInteger _numberOfDataPoints;
    NSString *_title;

}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    self.rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
    
    [self.superview addConstraints:@[self.bottomConstraint, self.rightConstraint, self.heightConstraint]];
    
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
        [self addSubview:self.titleLabel];
    }else{
        [self.titleLabel removeFromSuperview];
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

    for (indexCounter = 0; indexCounter < _totalNumberOfLabels; indexCounter++) {
        if(exisitngLabel > indexCounter){
            // updated Label
            UILabel *label = [newLabels objectAtIndex:indexCounter];
            [self updateLabel:label atindex:indexCounter];
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
    [copiedLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        [self updateLabel:label atindex:index];
    }];
}

- (void)updateLabel:(UILabel*)label atindex:(NSInteger)index
{
    NSUInteger dpIndex = [self dataPointIndexForLabelIndex:index];
    if(dpIndex != NSNotFound){
        label.textColor = self.labelColor;
        label.text = [self stringForXLegendAtIndex:dpIndex];
        [self updateFrameOfLabel:label atIndex:index];
    }
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
