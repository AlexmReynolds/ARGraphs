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
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reloadData
{
    _numberOfDataPoints = [self.delegate numberOfDataPoints];
    NSUInteger newNumber = [self numberOfLabelsForWidth:self.bounds.size.width];
    if(newNumber != _totalNumberOfLabels){
        _totalNumberOfLabels = MIN(newNumber, _numberOfDataPoints);
        [self createLabels];
        // re-layout
    }else{
        //Update Values
        [self updateLabelValues];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger newNumber = [self numberOfLabelsForWidth:self.bounds.size.width];
    if(newNumber != _totalNumberOfLabels || newNumber < _numberOfDataPoints){
        _totalNumberOfLabels = MIN(newNumber, _numberOfDataPoints);
        [self createLabels];
        // re-layout
    }else{
        //Update Values
        [self updateLabelValues];
    }
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
            label.text = [self.delegate xLegend:self labelForXLegendAtIndex:dpIndex];
            [label sizeToFit];
            CGRect frame = label.frame;
            CGFloat centerPoint = (self.bounds.size.width / _totalNumberOfLabels) * index;
            
            frame.origin.x = centerPoint - frame.size.width/2;
            label.frame = frame;
        }
    }];
}

- (UILabel*)labelForXAxisIndex:(NSInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = self.labelColor;
    NSUInteger dpIndex = [self dataPointIndexForLabelIndex:index];
    if(dpIndex != NSNotFound){
        label.text = [self.delegate xLegend:self labelForXLegendAtIndex:dpIndex];
    }
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    [label sizeToFit];
    CGRect frame = label.frame;
    CGFloat centerPoint = (self.bounds.size.width / _totalNumberOfLabels) * index;
    
    frame.origin.x = centerPoint - frame.size.width/2;
    label.frame = frame;
    return label;
}

- (NSUInteger)dataPointIndexForLabelIndex:(NSUInteger)labelIndex
{
    NSUInteger dpIndex = NSNotFound;
    if(_numberOfDataPoints > 0){
        if(labelIndex == _totalNumberOfLabels - 1){ // lastIndex
            dpIndex = _numberOfDataPoints -1;
        }else {
            dpIndex = labelIndex * (_numberOfDataPoints / _totalNumberOfLabels);
            // 1/14
            // 1/42
            // make common denominator
            dpIndex = ((float)(labelIndex / (float)_totalNumberOfLabels)) * (float)_numberOfDataPoints;
            
        }
        NSLog(@"LT:%lu DPT:%lu LI:%lu DPI:%lu", (unsigned long)_totalNumberOfLabels, (unsigned long)_numberOfDataPoints, (unsigned long)labelIndex, (unsigned long)dpIndex);
    }
    return dpIndex;
}

- (CGFloat)xPositionForDataPointIndex:(NSInteger)index totalPoints:(NSInteger)total inWidth:(CGFloat)width
{
    CGFloat itemWidth = width/total;
    return index * itemWidth + itemWidth/2;
}

- (NSUInteger)numberOfLabelsForWidth:(CGFloat)width
{
    NSString *testString = @"1234";
    CGSize sizeOfTestString = [self sizeOfText:testString];
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
