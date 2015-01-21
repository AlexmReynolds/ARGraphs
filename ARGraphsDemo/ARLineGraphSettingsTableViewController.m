//
//  ARGraphSettingsTableViewController.m
//  ARGraphs
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARLineGraphSettingsTableViewController.h"

@interface ARLineGraphSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *showDotsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showMeanSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showMinMaxSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showXLegendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showYLegendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showCurvedLineSwitch;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *subTitleField;
@property (weak, nonatomic) IBOutlet UITextField *redTintValue;
@property (weak, nonatomic) IBOutlet UITextField *greenTintValue;
@property (weak, nonatomic) IBOutlet UITextField *blueTintValue;
@end

@implementation ARLineGraphSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)showDots
{
    return self.showDotsSwitch.on;

}
- (BOOL)showMean
{
    return self.showMeanSwitch.on;
}
- (BOOL)showMinMax
{
    return self.showMinMaxSwitch.on;
}
- (BOOL)showXLegend{
    return self.showXLegendSwitch.on;

}

- (BOOL)showYLegend
{
    return self.showYLegendSwitch.on;

}

- (BOOL)showCurvedLine{
    return self.showCurvedLineSwitch.on;
    
}

- (NSString *)titleText
{
    return self.titleField.text;
}

- (NSString *)subTitleText
{
    return self.subTitleField.text;
}

- (UIColor *)chartColor
{
    CGFloat red = [self.redTintValue.text floatValue];
    CGFloat green = [self.greenTintValue.text floatValue];
    CGFloat blue = [self.blueTintValue.text floatValue];

    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0];
}

- (IBAction)subtitleChanged:(id)sender {
    [self settingWasChanged];

}
- (IBAction)titleChanged:(id)sender {
    [self settingWasChanged];

}

- (IBAction)minMaxLabels:(id)sender {
    [self settingWasChanged];

}
- (IBAction)meanLabels:(id)sender {
    [self settingWasChanged];

}
- (IBAction)showXLegendChanged:(id)sender {
    [self settingWasChanged];

}
- (IBAction)showYLegendChanged:(id)sender {
    [self settingWasChanged];

}

- (IBAction)curveChanged:(id)sender {
    [self settingWasChanged];

}

- (IBAction)colorChanged:(id)sender {
    [self settingWasChanged];
}

- (void)settingWasChanged
{
    if([self.delegate respondsToSelector:@selector(settingsChanged)]){
        [self.delegate settingsChanged];
    }
}
@end
