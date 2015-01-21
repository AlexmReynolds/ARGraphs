//
//  ARGraphxLegendView.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARGraphXLegendView.h"

@implementation ARGraphXLegendView{
    NSUInteger _totalNumberOfLabels;
    NSArray *_labels;
    NSUInteger _numberOfDataPoints;
    UILabel *_titleLabel;
    NSString *_title;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    [_titleLabel removeFromSuperview];
    if(_title != nil){
        _titleLabel = [self makeTitleLabel];
        [self addSubview:_titleLabel];
    }
    [self createOrUpdateLabels];


}

- (void)createOrUpdateLabels
{
    if(self.showXValues){
        NSUInteger canFit = [self numberOfLabelsForWidth:self.bounds.size.width];
        if(canFit != _totalNumberOfLabels){
            _totalNumberOfLabels = MIN(canFit, _numberOfDataPoints);
            [self createLabels];
            // re-layout
        }else{
            //Update Values
            [self updateLabelValues];
        }
    }else {
        [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self createOrUpdateLabels];
}

- (UILabel*)makeTitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.text = _title;
    label.textColor = self.labelColor;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [label sizeToFit];
    return label;
}

- (void)createLabels
{
    [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger count = 0;
    for (count = 0; count < _totalNumberOfLabels; count++) {
        UILabel *label = [self labelForXAxisIndex:count];
        [self addSubview:label];
        [array addObject:label];
    };
    
    _labels = array;
    
}

- (void)updateLabelValues
{
    NSArray *copiedLabels = [_labels copy];
    [copiedLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        NSUInteger dpIndex = [self dataPointIndexForLabelIndex:index];
        if(dpIndex != NSNotFound){
            label.textColor = self.labelColor;
            label.text = [self stringForXLegendAtIndex:dpIndex];
            [self updateFrameOfLabel:label atIndex:index];
        }
    }];
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
    return [NSString stringWithFormat:@"%ld", value];
}

- (CGFloat)xPositionForDataPointIndex:(NSInteger)index totalPoints:(NSInteger)total inWidth:(CGFloat)width
{
    CGFloat itemWidth = width/total;
    CGFloat offsetForTitleLabel = 0;
    if(_title != nil && _title.length){
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
