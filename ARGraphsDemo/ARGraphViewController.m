//
//  ARGraphViewController.m
//  ARGraphs
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARGraphViewController.h"
#import "ARGraph.h"
#import "ARGraphSettingsTableViewController.h"
@interface ARGraphViewController ()<ARGraphDataSource, ARGraphTableSettingsDelegate>
@property (weak, nonatomic) IBOutlet ARGraph *chart;
@property (nonatomic, weak) ARGraphSettingsTableViewController *settingsTable;
@end

@implementation ARGraphViewController

- (void)viewDidLoad {
    self.settingsTable = [self.childViewControllers lastObject];
    self.settingsTable.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.chart.dataSource = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSArray*)ARGraphDataPoints:(ARGraph *)graph
{
    NSArray *data = @[
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)],
                      [[ARGraphDataPoint alloc] initWithX:arc4random_uniform(30) y:arc4random_uniform(30)]
                      
                      ];
    return data;
}

- (NSString *)subTitleForGraph:(ARGraph *)graph
{
    return self.settingsTable.subTitleText;
}

- (NSString *)titleForGraph:(ARGraph *)graph
{
    return self.settingsTable.titleText;

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

    [self.chart reloadData];
}
@end
