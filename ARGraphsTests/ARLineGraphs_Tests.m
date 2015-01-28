//
//  ARGraphsTests.m
//  ARGraphsTests
//
//  Created by Alex Reynolds on 1/12/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "ARLineGraph.h"
#import "ARLineGraphPointsLayer.h"
#import "ARLineGraphMean.h"
#import "ARYMinMaxLayer.h"
#import "ARLineGraphXLegendView.h"
#import "ARLineGraphYLegendView.h"
#import "ARGraphTitleView.h"

@interface ARLineGraph (Tests)
- (CAGradientLayer*)getBackgroundForTests;
- (ARLineGraphPointsLayer*)getPointsLayerForTests;
- (ARYMinMaxLayer*)getMinMaxLayerForTests;
- (ARLineGraphMean*)getMeanLayerForTests;

- (ARLineGraphXLegendView*)getXLegendContainerForTests;
- (ARLineGraphYLegendView*)getYLegendContainerForTests;
- (ARGraphTitleView*)getTitleViewForTests;

- (NSArray*)getDataPointsForTests;
@end

@implementation ARLineGraph (Tests)
- (CAGradientLayer*)getBackgroundForTests
{
    return [self valueForKey:@"_background"];
}

- (ARLineGraphPointsLayer*)getPointsLayerForTests
{
    return [self valueForKey:@"_pointsLayer"];
}

- (ARYMinMaxLayer*)getMinMaxLayerForTests
{
    return [self valueForKey:@"_minMaxLayer"];
}

- (ARLineGraphMean*)getMeanLayerForTests
{
    return [self valueForKey:@"_meanLayer"];
}

- (ARLineGraphXLegendView*)getXLegendContainerForTests
{
    return [self valueForKey:@"_xAxisContainerView"];
}

- (ARLineGraphYLegendView*)getYLegendContainerForTests
{
    return [self valueForKey:@"_yAxisContainerView"];
}

- (ARGraphTitleView *)getTitleViewForTests
{
    return [self valueForKey:@"_titleContainerView"];
}

- (NSArray*)getDataPointsForTests
{
    return [self valueForKey:@"_dataPoints"];
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
        XCTAssertTrue([sut.lineColor isEqual:[UIColor colorWithWhite:1.0 alpha:1.0]], @"lineColor was not defaulted to white");
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

- (void)testSettingShowMInMaxToNo_ShouldHideMinMaxLayer
{
    sut.showMinMaxLines = NO;
    XCTAssertTrue([sut getMinMaxLayerForTests].hidden, @"minMaxLayer was not hidden");
}

- (void)testSettingShowMInMaxToNo_ShouldSetXLegendRightToNegative20
{
    sut.showMinMaxLines = YES;
    XCTAssertTrue([sut getXLegendContainerForTests].rightConstraint.constant == -20, @"x legend right was not set to 0");
}

- (void)testSettingShowMInMaxToNo_ShouldSetXLegendRightTo0
{
    sut.showMinMaxLines = NO;
    XCTAssertTrue([sut getXLegendContainerForTests].rightConstraint.constant == 0, @"x legend right was not set to 0");
}

- (void)testSettingShowMeanLineToNo_ShouldHideMeanLayer
{
    sut.showMeanLine = NO;
    XCTAssertTrue([sut getMeanLayerForTests].hidden, @"meanLine was not hidden");
}

- (void)testSetShowXLegendToNO_ShouldSetHeightConstraintToZero
{
    sut.showXLegend = NO;
    XCTAssertEqual([sut getXLegendContainerForTests].heightConstraint.constant, 0.0, @"constraint was not set to 0");
}

- (void)testSetShowXLegendToYES_ShouldSetHeightConstraintToZero
{
    sut.showXLegend = YES;
    XCTAssertTrue([sut getXLegendContainerForTests].heightConstraint.constant > 0.0, @"constraint was not set");
}

- (void)testSetShowYLegendToNO_ShouldSetWidthConstraintToZero
{
    sut.showYLegend = NO;
    XCTAssertEqual([sut getYLegendContainerForTests].widthConstraint.constant, 0.0, @"constraint was not set to 0");
}

- (void)testSetShowYLegendToYES_ShouldSetWidthConstraintToZero
{
    sut.showYLegend = YES;
    XCTAssertTrue([sut getYLegendContainerForTests].widthConstraint.constant > 0.0, @"constraint was not set");
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
    CGFloat expected = [sut getPointsLayerForTests].dotRadius + [sut getPointsLayerForTests].lineWidth;

    XCTAssertTrue([sut getPointsLayerForTests].topPadding == expected, @"show dots BOOL did not padd chart");
}

- (void)testSetShowDotsToYES_ShouldPadMinMaxLayerForDotRadius
{
    sut.showDots = YES;
    CGFloat expected = [sut getPointsLayerForTests].dotRadius + [sut getPointsLayerForTests].lineWidth;

    XCTAssertTrue([sut getMinMaxLayerForTests].topPadding == expected, @"show dots BOOL did not padd chart");
}

- (void)testSetShowDotsToYES_ShouldPadMeanLayerForDotRadius
{
    sut.showDots = YES;
    CGFloat expected = [sut getPointsLayerForTests].dotRadius + [sut getPointsLayerForTests].lineWidth;
    XCTAssertTrue([sut getMeanLayerForTests].topPadding == expected, @"show dots BOOL did not padd chart");
}

- (void)testSetShowMinMaxToYES_ShouldPadPointsLayerToAddSpaceForMinMax
{
    sut.showMinMaxLines = YES;
    XCTAssertTrue([sut getPointsLayerForTests].rightPadding == 20, @"showMinMaxLines BOOL did not pad chart for labels");
}

- (void)testSetShowMinMaxToNO_ShouldPadPointsLayerToAddSpaceForMinMax
{
    sut.showMinMaxLines = NO;
    XCTAssertTrue([sut getPointsLayerForTests].rightPadding == 0, @"showMinMaxLines BOOL did not pad chart for labels");
}

- (void)testSettingDotRadius_ShouldSetDotRadiusOnPointsLayer
{
    sut.dotRadius = 10.0;
    XCTAssertEqual(sut.dotRadius, [sut getPointsLayerForTests].dotRadius, @"dotRadius was not set");
}

- (void)testSettingLineColor_ShouldSetLineColorOnSubLayers
{
    sut.lineColor = [UIColor redColor];
    UIColor *pointsLine = [UIColor colorWithCGColor:[sut getPointsLayerForTests].lineColor];
    UIColor *meanLine = [UIColor colorWithCGColor:[sut getMeanLayerForTests].lineColor];
    UIColor *maxLine = [UIColor colorWithCGColor:[sut getMinMaxLayerForTests].lineColor];
    
    XCTAssertTrue([sut.lineColor isEqual:pointsLine], @"colors were not equal");
    XCTAssertTrue([sut.lineColor isEqual:meanLine], @"colors were not equal");
    XCTAssertTrue([sut.lineColor isEqual:maxLine], @"colors were not equal");

}

- (void)testSettingLabelColor_ShouldSetLabelColorOnSubLayers
{
    sut.labelColor = [UIColor redColor];
    UIColor *maxLine = [UIColor colorWithCGColor:[sut getMinMaxLayerForTests].labelColor];
    XCTAssertTrue([sut.labelColor isEqual:maxLine], @"colors were not equal");
}

#pragma mark - MEthods

- (void)testAppendingADatapoint_ShouldAddItToDataPoints
{
    ARGraphDataPoint *point = [ARGraphDataPoint dataPointWithX:1 y:2];
    [sut appendDataPoint:point];
    XCTAssertEqual(point, [[sut getDataPointsForTests] lastObject], @"Datapoint was not appended");
}

#pragma mark - Delegate
- (void)testSettingDataSource_ShouldCallDataPoints
{
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARLineGraphDataSource)];
    [[mockDelegate expect] ARGraphDataPoints:sut];
    [[mockDelegate expect] titleForGraph:sut];
    [[mockDelegate expect] subTitleForGraph:sut];
    [[mockDelegate expect] ARGraphTitleForXAxis:sut];
    
    sut.dataSource = mockDelegate;

    XCTAssertNoThrow([mockDelegate verify],@"method was not called");
}

- (void)testIfDataSourceSendsTitle_ShouldSetTitleLabel
{
    NSString *string = @"foobar";
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARLineGraphDataSource)];
    [[mockDelegate expect] ARGraphDataPoints:sut];
    [[[mockDelegate expect] andReturn:string] titleForGraph:sut];
    [[mockDelegate expect] subTitleForGraph:sut];
    [[mockDelegate expect] ARGraphTitleForXAxis:sut];
    
    sut.dataSource = mockDelegate;
    
    XCTAssertTrue([[sut getTitleViewForTests].title isEqualToString:string],@"title label was not set to %@", string);
}

- (void)testIfDataSourceSendsSubTitle_ShouldSetSubTitleLabel
{
    NSString *string = @"hello world";
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARLineGraphDataSource)];
    [[mockDelegate expect] ARGraphDataPoints:sut];
    [[mockDelegate expect] titleForGraph:sut];
    [[[mockDelegate expect] andReturn:string] subTitleForGraph:sut];
    [[mockDelegate expect] ARGraphTitleForXAxis:sut];
    
    sut.dataSource = mockDelegate;
    
    XCTAssertTrue([[sut getTitleViewForTests].subtitle isEqualToString:string],@"subtitle label was not set to %@", string);
}

- (void)testIfDataSourceSendsDataPoints_ShouldSetDataPointsArray
{
    NSArray *dataPoints = @[[ARGraphDataPoint dataPointWithX:0 y:0],
                            [ARGraphDataPoint dataPointWithX:1 y:1],
                            ];
    
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARLineGraphDataSource)];
    [[[mockDelegate expect] andReturn:dataPoints] ARGraphDataPoints:sut];
    [[mockDelegate expect] titleForGraph:sut];
    [[mockDelegate expect] subTitleForGraph:sut];
    [[mockDelegate expect] ARGraphTitleForXAxis:sut];
    
    sut.dataSource = mockDelegate;
    
    XCTAssertTrue([[sut getDataPointsForTests] isEqual:dataPoints],@"subtitle label was not set to %@", dataPoints);
}
@end
