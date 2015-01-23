//
//  ARGraphsTests.m
//  ARGraphsTests
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ARLineGraph.h"
#import "ARGraphPointsLayer.h"
#import "ARMeanLineLayer.h"
#import "ARYMinMaxLayer.h"


@interface ARLineGraph (Tests)
- (CAGradientLayer*)getBackgroundForTests;
- (ARGraphPointsLayer*)getPointsLayerForTests;
- (ARYMinMaxLayer*)getMinMaxLayerForTests;
- (ARMeanLineLayer*)getMeanLayerForTests;

- (NSLayoutConstraint*)getXLegendHeightConstraintForTests;
- (NSLayoutConstraint*)getYLegendHeightConstraintForTests;

@end

@implementation ARLineGraph (Tests)
- (CAGradientLayer*)getBackgroundForTests
{
    return [self valueForKey:@"_background"];
}

- (ARGraphPointsLayer*)getPointsLayerForTests
{
    return [self valueForKey:@"_pointsLayer"];
}

- (ARYMinMaxLayer*)getMinMaxLayerForTests
{
    return [self valueForKey:@"_minMaxLayer"];
}

- (ARMeanLineLayer*)getMeanLayerForTests
{
    return [self valueForKey:@"_meanLayer"];
}

- (NSLayoutConstraint*)getXLegendHeightConstraintForTests
{
    return [self valueForKey:@"_xAxisHeightConstraint"];

}

- (NSLayoutConstraint*)getYLegendHeightConstraintForTests
{
    return [self valueForKey:@"_yAxisWidthConstraint"];
    
}
@end

@interface ARLineGraphs_Tests : XCTestCase{
    ARLineGraph *sut;
}

@end

@implementation ARLineGraphs_Tests

- (void)setUp {
    sut = [[ARLineGraph alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    sut = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSut_shouldExist {
    // This is an example of a functional test case.
    XCTAssertNotNil(sut, @"Sut was nil");
}

- (void)testSutGradientBackgound_shouldExist {
    // This is an example of a functional test case.
    XCTAssertNotNil([sut getBackgroundForTests], @"gradient was nil");
}

- (void)testSutPointsLayer_shouldExist {
    // This is an example of a functional test case.
    XCTAssertNotNil([sut getPointsLayerForTests], @"points layer was nil");
}

- (void)testSutMinMaxLayer_shouldExist {
    // This is an example of a functional test case.
    XCTAssertNotNil([sut getMinMaxLayerForTests], @"min max layer was nil");
}

- (void)testSutMeanLayer_shouldExist {
    // This is an example of a functional test case.
    XCTAssertNotNil([sut getMeanLayerForTests], @"mean layer was nil");
}

- (void)testSutCreation_Performance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        sut = [[ARLineGraph alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    }];
}

#pragma mark - Defaults

- (void)testShowXLegend_ShouldDefaultToYes
{
    XCTAssertTrue(sut.showXLegend, @"showXLegend was not defaulted to YES");
}

- (void)testShowYLegend_ShouldDefaultToYes
{
    XCTAssertTrue(sut.showYLegend, @"showXLegend was not defaulted to YES");
}

- (void)testShowXLegendValues_ShouldDefaultToYes
{
    XCTAssertTrue(sut.showXLegendValues, @"showXLegendValues was not defaulted to YES");
}
- (void)testShowDots_ShouldDefaultToYes
{
    XCTAssertTrue(sut.showDots, @"showDots was not defaulted to YES");
}
- (void)testShowMinMax_ShouldDefaultToYes
{
    XCTAssertTrue(sut.showMinMaxLines, @"showMinMaxLines was not defaulted to YES");
}
- (void)testShowMean_ShouldDefaultToYes
{
    XCTAssertTrue(sut.showMeanLine, @"showMeanLine was not defaulted to YES");
}
- (void)testUseBackgroundGradient_ShouldDefaultToYes
{
    XCTAssertTrue(sut.useBackgroundGradient, @"useBackgroundGradient was not defaulted to YES");
}

- (void)testTintColor_ShouldDefaultToYes
{
    XCTAssertTrue([sut.tintColor isEqual:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]], @"tint was not defaulted to red");
}

- (void)testLineColor_ShouldDefaultToYes
{
        XCTAssertTrue([sut.lineColor isEqual:[UIColor colorWithWhite:1.0 alpha:0.6]], @"lineColor was not defaulted to white");
}

- (void)testLabelColor_ShouldDefaultToYes
{
    XCTAssertTrue([sut.labelColor isEqual:[UIColor whiteColor]], @"lineColor was not defaulted to white");
}

#pragma mark - Customizing methods

- (void)testSettingUseBackgroundGradientToNo_ShouldHideGradientLayer
{
    sut.useBackgroundGradient = NO;
    XCTAssertTrue([sut getBackgroundForTests].hidden, @"gradient was not hidden");
}

- (void)testSetShowXLegendToNO_ShouldSetHeightConstraintToZero
{
    sut.showXLegend = NO;
    XCTAssertEqual([sut getXLegendHeightConstraintForTests].constant, 0.0, @"constraint was not set to 0");
}

- (void)testSetShowXLegendToYES_ShouldSetHeightConstraintToZero
{
    sut.showXLegend = YES;
    XCTAssertTrue([sut getXLegendHeightConstraintForTests].constant > 0.0, @"constraint was not set");
}

- (void)testSetShowYLegendToNO_ShouldSetWidthConstraintToZero
{
    sut.showYLegend = NO;
    XCTAssertEqual([sut getYLegendHeightConstraintForTests].constant, 0.0, @"constraint was not set to 0");
}

- (void)testSetShowYLegendToYES_ShouldSetWidthConstraintToZero
{
    sut.showYLegend = YES;
    XCTAssertTrue([sut getYLegendHeightConstraintForTests].constant > 0.0, @"constraint was not set");
}

- (void)testSetShowDotsToYES_ShouldSetShowDotsOnThePointPayer
{
    sut.showDots = YES;
    XCTAssertTrue(sut.showDots == [sut getPointsLayerForTests].showDots, @"show dots BOOL was not set on points layer");
}

- (void)testSetShowDotsToNO_ShouldSetShowDotsOnThePointPayer
{
    sut.showDots = NO;
    XCTAssertTrue(sut.showDots == [sut getPointsLayerForTests].showDots, @"show dots BOOL was not set on points layer");
}

- (void)testSetShowDotsToYES_ShouldPadPointsLayerForDotRadius
{
    sut.showDots = YES;
    XCTAssertTrue([sut getPointsLayerForTests].topPadding == [sut getPointsLayerForTests].dotRadius, @"show dots BOOL did not padd chart");
}

- (void)testSetShowDotsToYES_ShouldPadMinMaxLayerForDotRadius
{
    sut.showDots = YES;
    XCTAssertTrue([sut getMinMaxLayerForTests].topPadding == [sut getPointsLayerForTests].dotRadius, @"show dots BOOL did not padd chart");
}

- (void)testSetShowDotsToYES_ShouldPadMeanLayerForDotRadius
{
    sut.showDots = YES;
    XCTAssertTrue([sut getMeanLayerForTests].topPadding == [sut getPointsLayerForTests].dotRadius, @"show dots BOOL did not padd chart");
}
@end
