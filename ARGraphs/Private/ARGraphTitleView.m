//
//  ARLineGraphTitleView.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/27/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARGraphTitleView.h"

@interface ARGraphTitleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

@implementation ARGraphTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLabel];
        [self addConstraintsToTitleLabel];
        [self addConstraintsToSubTitleLabel];
        self.labelColor = [UIColor whiteColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview){
        self.topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        self.leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
        
        [self.superview addConstraints:@[self.topConstraint, self.leftConstraint, self.rightConstraint, self.heightConstraint]];
    }
}

#pragma mark - Setters
- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    self.titleLabel.textColor = labelColor;
    self.subtitleLabel.textColor = labelColor;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    self.heightConstraint.constant = [self sizeOfText:title preferredFontForTextStyle:UIFontTextStyleBody].height;
    [self layoutIfNeeded];
}

- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    self.subtitleLabel.text = subtitle;
}

- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _titleLabel.text = @"foo";
        _titleLabel.textColor =  self.labelColor;
    }
    return _titleLabel;
}

- (void)addConstraintsToTitleLabel
{
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_titleLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_titleLabel.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.subtitleLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-10.0];
    
    [_titleLabel.superview addConstraints:@[centerY, left, right]];
}

- (UILabel *)subtitleLabel{
    if(_subtitleLabel == nil){
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _subtitleLabel.text = @"bar";
        _subtitleLabel.textColor = self.labelColor;

        [_subtitleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_subtitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return _subtitleLabel;
}
- (void)addConstraintsToSubTitleLabel
{
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
    
    [_subtitleLabel.superview addConstraints:@[centerY, left, right]];
}

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
@end
