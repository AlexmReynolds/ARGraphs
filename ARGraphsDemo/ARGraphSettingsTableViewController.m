//
//  ARGraphSettingsTableViewController.m
//  ARGraphs
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARGraphSettingsTableViewController.h"

@interface ARGraphSettingsTableViewController ()
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

@implementation ARGraphSettingsTableViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Getters
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

- (BOOL)showXLegend
{
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

#pragma mark - Actions
- (IBAction)settingChanged:(id)sender {
    [self settingWasChanged];
}

- (void)settingWasChanged
{
    if([self.delegate respondsToSelector:@selector(settingsChanged)]){
        [self.delegate settingsChanged];
    }
}
@end
