//
//  ARPieChartViewController.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARPieChartViewController.h"
#import "ARPieChartSettingsTableViewController.h"
#import "ARPieChart.h"
@interface ARPieChartViewController ()<ARPieChartDataSource, ARPieChartTableSettingsDelegate>
@property (weak, nonatomic) IBOutlet ARPieChart *chart;
@property (nonatomic, weak) ARPieChartSettingsTableViewController *settingsTable;

@end

@implementation ARPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingsTable = [self.childViewControllers lastObject];
    self.title = @"Pie Chart";
    self.settingsTable.delegate = self;
    self.chart.dataSource = self;
    self.chart.innerRadiusPercent = self.settingsTable.innerRadiusPercent;
    self.chart.sliceGutterWidth = self.settingsTable.sliceInset;
    self.chart.tintColor = self.settingsTable.chartColor;
    self.chart.useBackgroundGradient = self.settingsTable.useBackgroundGradient;

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.chart beginAnimationIn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)ARPieChartDataPoints:(ARPieChart *)graph
{
    ARGraphDataPoint *dp = [[ARGraphDataPoint alloc] initWithX:5 y:10];
    ARGraphDataPoint *dp1 = [[ARGraphDataPoint alloc] initWithX:12 y:20];
    ARGraphDataPoint *dp2 = [[ARGraphDataPoint alloc] initWithX:5 y:30];
    ARGraphDataPoint *dp3 = [[ARGraphDataPoint alloc] initWithX:5 y:40];
    ARGraphDataPoint *dp4 = [[ARGraphDataPoint alloc] initWithX:5 y:50];

    
    return @[dp,dp1,dp2,dp3,dp4];
}

- (NSString *)ARPieChart:(ARPieChart *)chart titleForPieIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"i %lu", (unsigned long)index];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)settingsChanged
{
    self.chart.innerRadiusPercent = self.settingsTable.innerRadiusPercent;
    self.chart.sliceGutterWidth = self.settingsTable.sliceInset;
    self.chart.tintColor = self.settingsTable.chartColor;
    self.chart.useBackgroundGradient = self.settingsTable.useBackgroundGradient;
}
@end
