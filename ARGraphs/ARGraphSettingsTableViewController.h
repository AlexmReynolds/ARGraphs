//
//  ARGraphSettingsTableViewController.h
//  ARGraphs
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARGraphTableSettingsDelegate <NSObject>

- (void)settingsChanged;

@end
@interface ARGraphSettingsTableViewController : UITableViewController

@property (nonatomic, weak) id <ARGraphTableSettingsDelegate> delegate;

@property (nonatomic) BOOL showDots;
@property (nonatomic) BOOL showMean;
@property (nonatomic) BOOL showMinMax;
@property (nonatomic) BOOL showYLegend;
@property (nonatomic) BOOL showXLegend;
@property (nonatomic) BOOL showCurvedLine;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *subTitleText;
@property (nonatomic, strong) UIColor *chartColor;
@end
