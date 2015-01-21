//
//  ARPieChartSettingsTableViewController.h
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/20/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ARPieChartTableSettingsDelegate <NSObject>

- (void)settingsChanged;

@end
@interface ARPieChartSettingsTableViewController : UITableViewController

@property (nonatomic, weak) id <ARPieChartTableSettingsDelegate> delegate;
@property (nonatomic) CGFloat sliceInset;
@property (nonatomic) CGFloat innerRadiusPercent;
@property (nonatomic, strong) UIColor *chartColor;

@end
