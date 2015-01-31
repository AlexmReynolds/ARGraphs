//
//  ARGraphViewController.m
//  ARGraphs
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARGraphViewController.h"
#import "ARLineGraph.h"
#import "ARLineGraphSettingsTableViewController.h"
@interface ARGraphViewController ()<ARLineGraphDataSource, ARGraphTableSettingsDelegate>
@property (weak, nonatomic) IBOutlet ARLineGraph *chart;
@property (nonatomic, weak) ARLineGraphSettingsTableViewController *settingsTable;

@property (nonatomic,strong) NSMutableArray *graphDataPoints;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ARGraphViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Line Graph";
    self.graphDataPoints = [NSMutableArray array];
    self.settingsTable = [self.childViewControllers lastObject];
    self.settingsTable.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.chart.showMeanLine = self.settingsTable.showMean;
    self.chart.showMinMaxLines = self.settingsTable.showMinMax;
    self.chart.showDots = self.settingsTable.showDots;
    self.chart.showXLegend = self.settingsTable.showXLegend;
    self.chart.showYLegend = self.settingsTable.showYLegend;
    self.chart.tintColor = self.settingsTable.chartColor;
    self.chart.shouldSmooth = self.settingsTable.showCurvedLine;
    self.chart.showXLegendValues = self.settingsTable.showXLegendValues;
    self.chart.layer.cornerRadius = 8.0;
    self.chart.clipsToBounds = YES;
    self.chart.dataSource = self;
    [self.chart beginAnimationIn];
    NSInteger perPopData = 10;
    while (perPopData--) {
        [self.graphDataPoints addObject:[[ARGraphDataPoint alloc] initWithX:arc4random()%10 y:100 + arc4random()%1]];
    }
    [self.chart reloadData];
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(createDataPoint) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)createDataPoint
{
    [self.graphDataPoints addObject:[[ARGraphDataPoint alloc] initWithX:arc4random()%10 y:100 +arc4random()%80]];
    [self.chart appendDataPoint:[self.graphDataPoints lastObject]];
}

- (NSArray*)ARGraphDataPoints:(ARLineGraph *)graph
{
    return self.graphDataPoints;
}

- (NSString *)subTitleForGraph:(ARLineGraph *)graph
{
    return self.settingsTable.subTitleText;
}

- (NSString *)titleForGraph:(ARLineGraph *)graph
{
    return self.settingsTable.titleText;
}

- (NSString *)ARGraphTitleForXAxis:(ARLineGraph *)graph
{
    return self.settingsTable.xLegendText;
}

- (NSString *)ARGraphTitleForYAxis:(ARLineGraph *)graph
{
    return self.settingsTable.yLegnedText;

}

- (void)settingsChanged
{
    self.chart.showMeanLine = self.settingsTable.showMean;
    self.chart.showMinMaxLines = self.settingsTable.showMinMax;
    self.chart.showDots = self.settingsTable.showDots;
    self.chart.showXLegend = self.settingsTable.showXLegend;
    self.chart.showYLegend = self.settingsTable.showYLegend;
    self.chart.tintColor = self.settingsTable.chartColor;
    self.chart.shouldSmooth = self.settingsTable.showCurvedLine;
    self.chart.showXLegendValues = self.settingsTable.showXLegendValues;
    [self.chart reloadData];
}
@end
