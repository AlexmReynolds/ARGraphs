//
//  ARPieChartSettingsTableViewController.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/20/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARPieChartSettingsTableViewController.h"

@interface ARPieChartSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *innerRadiusPercentTextField;
@property (weak, nonatomic) IBOutlet UITextField *insetAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *tintRed;
@property (weak, nonatomic) IBOutlet UITextField *greenTint;
@property (weak, nonatomic) IBOutlet UITextField *blueTint;
@property (weak, nonatomic) IBOutlet UISwitch *backgroundHiddenSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animationTypeSegment;
@end

@implementation ARPieChartSettingsTableViewController

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
- (NSInteger)animationType
{
    return _animationTypeSegment.selectedSegmentIndex;
}
- (CGFloat)sliceInset
{
    return [self.insetAmountTextField.text floatValue];
}

- (CGFloat)innerRadiusPercent
{
    return [self.innerRadiusPercentTextField.text floatValue];
}

- (UIColor *)chartColor
{
    CGFloat red = [self.tintRed.text floatValue];
    CGFloat green = [self.greenTint.text floatValue];
    CGFloat blue = [self.blueTint.text floatValue];
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0];
}

- (BOOL)useBackgroundGradient
{
    return self.backgroundHiddenSwitch.on;
}
- (IBAction)animationTypeChanged:(id)sender {
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
