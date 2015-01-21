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
@interface ARGraphViewController ()<ARGraphDataSource, ARGraphTableSettingsDelegate>
@property (weak, nonatomic) IBOutlet ARLineGraph *chart;
@property (nonatomic, weak) ARLineGraphSettingsTableViewController *settingsTable;

@property (nonatomic,strong) NSMutableArray *graphDataPoints;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ARGraphViewController

- (void)viewDidLoad {
    self.graphDataPoints = [[NSMutableArray alloc] init];
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
    self.chart.labelColor = [UIColor whiteColor];
    
    NSInteger perPopData = 10;
    while (perPopData--) {
        [self.graphDataPoints addObject:[[ARGraphDataPoint alloc] initWithX:arc4random()%10 y:arc4random()%8]];
    }
    [self.chart reloadData];
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(createDataPoint) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)createDataPoint
{
    [self.graphDataPoints addObject:[[ARGraphDataPoint alloc] initWithX:arc4random()%10 y:arc4random()%8]];
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
