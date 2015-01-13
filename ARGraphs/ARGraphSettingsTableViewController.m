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
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *subTitleField;
@property (weak, nonatomic) IBOutlet UITextField *redTintValue;
@property (weak, nonatomic) IBOutlet UITextField *greenTintValue;
@property (weak, nonatomic) IBOutlet UITextField *blueTintValue;
@end

@implementation ARGraphSettingsTableViewController

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

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 5;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)subtitleChanged:(id)sender {
    if([self.delegate respondsToSelector:@selector(settingsChanged)]){
        [self.delegate settingsChanged];
    }
}
- (IBAction)titleChanged:(id)sender {
    if([self.delegate respondsToSelector:@selector(settingsChanged)]){
        [self.delegate settingsChanged];
    }
}

- (IBAction)minMaxLabels:(id)sender {
    if([self.delegate respondsToSelector:@selector(settingsChanged)]){
        [self.delegate settingsChanged];
    }
}
- (IBAction)meanLabels:(id)sender {
    if([self.delegate respondsToSelector:@selector(settingsChanged)]){
        [self.delegate settingsChanged];
    }
}
- (IBAction)colorChanged:(id)sender {
    if([self.delegate respondsToSelector:@selector(settingsChanged)]){
        [self.delegate settingsChanged];
    }
}
@end
