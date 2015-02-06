//
//  ARCircleGraphViewController.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/3/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARCircleGraphViewController.h"
#import "ARCircleGraph.h"
@interface ARCircleGraphViewController ()
@property (weak, nonatomic) IBOutlet ARCircleGraph *graph;

@end

@implementation ARCircleGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Circle Graph";

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.graph.percent = 0.8;
    self.graph.lineWidth = 4.0;
    self.graph.valueFormat = @"%.02f";
    self.graph.backgroundColor = [UIColor clearColor];
    self.graph.labelColor = [UIColor redColor];
    self.graph.title = @"Farts";
    
    self.graph.value = 100;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
