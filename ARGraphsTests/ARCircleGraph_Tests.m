//
//  ARCircleGraph_Tests.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/6/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ARCircleGraph.h"
#import "ARCircleRingLayer.h"
#import "ARCircleValueLabel.h"
#import "ARCircleTitleLabel.h"
@interface ARCircleGraph (Tests)
- (ARCircleValueLabel*)getValueLabelForTests;
- (ARCircleTitleLabel*)getTitleLabelForTests;
- (ARCircleRingLayer*)getRingForTests;
@end

@implementation ARCircleGraph (Tests)

- (ARCircleTitleLabel *)getTitleLabelForTests
{
    return [self valueForKey:@"titleLabel"];
}

- (ARCircleValueLabel *)getValueLabelForTests
{
    return [self valueForKey:@"valueLabel"];
}

- (ARCircleRingLayer *)getRingForTests
{
    return [self valueForKey:@"ringLayer"];
}

@end

@interface ARCircleGraph_Tests : XCTestCase{
    ARCircleGraph *sut;
}

@end

@implementation ARCircleGraph_Tests

- (void)setUp {
    sut = [[ARCircleGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    sut = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSut_ShouldExist {
    // This is an example of a functional test case.
    XCTAssertNotNil(sut, @"sut was nil");
}

- (void)testCreationPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        sut = [[ARCircleGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }];
}

#pragma mark - Defaults

- (void)testDefaultGraphBackgroundColor
{
    UIColor *expected = [UIColor clearColor];
    XCTAssertEqual(expected, sut.backgroundColor, @"graph background color was not clear");
}
- (void)testDefaultTitleColor
{
    UIColor *expected = [UIColor darkTextColor];
    sut.titleColor = expected;
    XCTAssertEqual(expected, [sut getTitleLabelForTests].textColor, @"title label color was not dark");
    
}

- (void)testDefaultTitleBackgroundColor
{
    UIColor *expected = [UIColor clearColor];
    XCTAssertEqual(expected, [sut getTitleLabelForTests].backgroundColor, @"title label background color was not clear");
}

- (void)testDefaultValueColor
{
    UIColor *expected = [UIColor whiteColor];
    sut.valueColor = expected;
    XCTAssertEqual(expected, [sut getValueLabelForTests].textColor, @"value label color was not white");
}

- (void)testDefaultValueBackgroundColor
{
    UIColor *expected = [UIColor clearColor];
    XCTAssertEqual(expected, [sut getValueLabelForTests].backgroundColor, @"value label background color was not clear");
}

- (void)testDefaultRingColor
{
    UIColor *expected = [UIColor redColor];
    sut.ringColor = expected;
    UIColor *ringColor = [UIColor colorWithCGColor:[sut getRingForTests].minColor];
    
    XCTAssertTrue([expected isEqual:ringColor], @"ring color was not set");
}
- (void)testDefaultRingBackgorundColor
{
    UIColor *expected = [UIColor colorWithWhite:1.0 alpha:0.2];
    ARCircleRingLayer *ringLayer = [sut getRingForTests];
    CALayer *background = [ringLayer.sublayers firstObject];
    UIColor *ringBackgroundColor = [UIColor colorWithCGColor:background.backgroundColor];
    XCTAssertTrue([expected isEqual:ringBackgroundColor], @"ring background color was not set");
}

- (void)testDefaultTrackColor
{
    UIColor *expected = [UIColor colorWithWhite:0.2 alpha:0.4];
    ARCircleRingLayer *ringLayer = [sut getRingForTests];
    CAShapeLayer *background = [ringLayer.sublayers objectAtIndex:1];
    UIColor *trackColor = [UIColor colorWithCGColor:background.strokeColor];
    XCTAssertTrue([expected isEqual:trackColor], @"ring track color was not set");
}

- (void)testDefaultTitlePosiiton
{
    XCTAssertTrue(sut.titlePosition == ARCircleGraphTitlePositionTop, @"Title position was defaulted to bottom");
}

#pragma mark - settings

- (void)testSettingTitleColor
{
    UIColor *expected = [UIColor greenColor];
    sut.titleColor = expected;
    XCTAssertEqual(expected, [sut getTitleLabelForTests].textColor, @"title label color was not set");
    
}

- (void)testSettingValueColor
{
    UIColor *expected = [UIColor greenColor];
    sut.valueColor = expected;
    XCTAssertEqual(expected, [sut getValueLabelForTests].textColor, @"value label color was not set");
    
}

- (void)testSettingRingColor
{
    UIColor *expected = [UIColor purpleColor];
    sut.ringColor = expected;
    UIColor *ringColor = [UIColor colorWithCGColor:[sut getRingForTests].minColor];

    XCTAssertTrue([expected isEqual:ringColor], @"title label color was not set");
    
}

- (void)testSettingValue
{
    sut.value = 100.0;
    NSString *labelText = [sut getValueLabelForTests].text;
    XCTAssertEqual(100.0, [labelText floatValue], @"label was not set to text");
}

- (void)testSettingLineWidth_ShouldInsetValueLabel
{
    sut.lineWidth = 10.0;
    CGFloat expected = 10.0 + 8.0; //inset plus padding;
    ARCircleValueLabel *label = [sut getValueLabelForTests];
    XCTAssertEqual(label.left.constant, expected, @"label was not inset");
    XCTAssertEqual(label.top.constant, expected, @"label was not inset");
    XCTAssertEqual(label.right.constant, -expected, @"label was not inset");
    XCTAssertEqual(label.bottom.constant, -expected, @"label was not inset");
}

- (void)testSettingLineWidth_ShouldSetRingStrokeWidth
{
    sut.lineWidth = 10.0;
    CGFloat expected = 10.0;
    ARCircleRingLayer *ring = [sut getRingForTests];
    XCTAssertEqual(ring.lineWidth, expected, @"label was not inset");
}

- (void)testSettingValueFormat
{
    sut.valueFormat = @"%.01f foobar";
    sut.value = 11.0f;
    ARCircleValueLabel *label = [sut getValueLabelForTests];
    XCTAssertTrue([label.text isEqualToString:@"11.0 foobar"], @"format was not applied");
}
- (void)testNotSettingValueFormat_ShouldSetToDefaultFormat
{
    sut.value = 11.0f;
    ARCircleValueLabel *label = [sut getValueLabelForTests];
    XCTAssertTrue([label.text isEqualToString:@"11"], @"format was not applied");
}

- (void)testSettingTitle_ShouldSetTitleLabel
{
    sut.title = @"boogers";
    ARCircleTitleLabel *label = [sut getTitleLabelForTests];
    XCTAssertTrue([label.text isEqualToString:@"boogers"], @"title was not set");
}

- (void)testSettingTitle_ShouldShowLabel
{
    sut.title = @"boogers";
    ARCircleTitleLabel *label = [sut getTitleLabelForTests];
    XCTAssertTrue(label.bounds.size.height > 0, @"title was not set");
}

- (void)testNotSettingTitle_ShouldHideLabel
{
    ARCircleTitleLabel *label = [sut getTitleLabelForTests];
    XCTAssertTrue(label.bounds.size.height == 0, @"title was not set");
}
@end
