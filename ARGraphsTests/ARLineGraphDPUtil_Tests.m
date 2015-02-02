//
//  ARLineGraphDPUtil.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 2/2/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ARLineGraphDataPointUtility.h"
#import "ARGraphDataPoint.h"
@interface ARLineGraphDPUtil_Tests : XCTestCase{
    ARLineGraphDataPointUtility *sut;
}

@end

@implementation ARLineGraphDPUtil_Tests

- (void)setUp {
    sut = [[ARLineGraphDataPointUtility alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    sut = nil;
    [super tearDown];
}

- (void)testSut_SHouldExist {
    // This is an example of a functional test case.
    XCTAssertNotNil(sut, @"sut was nil");
}

- (void)testOneDataPoint_ShouldBeTheMaxAndMins
{
    ARGraphDataPoint *dp = [[ARGraphDataPoint alloc] initWithX:2 y:3];
    [sut setDatapoints:@[dp]];
    XCTAssertEqual(dp.yValue, sut.yMax, @"max was not equal to datapoint");
    XCTAssertEqual(dp.yValue, sut.yMin, @"max was not equal to datapoint");
    XCTAssertEqual(dp.xValue, sut.xMax, @"max was not equal to datapoint");
    XCTAssertEqual(dp.xValue, sut.xMin, @"max was not equal to datapoint");
    XCTAssertEqual(dp.yValue, sut.yMean, @"max was not equal to datapoint");
    XCTAssertEqual(dp.xValue, sut.xMean, @"max was not equal to datapoint");

}

- (void)testFourDataPoint_ShouldSetMaxAndMin
{
    ARGraphDataPoint *dp1 = [[ARGraphDataPoint alloc] initWithX:2 y:3];
    ARGraphDataPoint *dp2 = [[ARGraphDataPoint alloc] initWithX:7 y:4];
    ARGraphDataPoint *dp3 = [[ARGraphDataPoint alloc] initWithX:4 y:5];
    ARGraphDataPoint *dp4 = [[ARGraphDataPoint alloc] initWithX:3 y:8];

    [sut setDatapoints:@[dp1,dp2,dp3,dp4]];
    XCTAssertEqual(dp4.yValue, sut.yMax, @"max was not equal to datapoint");
    XCTAssertEqual(dp1.yValue, sut.yMin, @"max was not equal to datapoint");
    XCTAssertEqual(dp2.xValue, sut.xMax, @"max was not equal to datapoint");
    XCTAssertEqual(dp1.xValue, sut.xMin, @"max was not equal to datapoint");
    XCTAssertEqual(5, sut.yMean, @"max was not equal to datapoint");
    XCTAssertEqual(4, sut.xMean, @"max was not equal to datapoint");
}

- (void)testAppendingDataPoint_ShouldSetMaxAndMin
{
    ARGraphDataPoint *dp = [[ARGraphDataPoint alloc] initWithX:2 y:3];
    
    [sut appendDataPoint:dp];
    XCTAssertEqual(dp.yValue, sut.yMax, @"max was not equal to datapoint");
    XCTAssertEqual(dp.yValue, sut.yMin, @"max was not equal to datapoint");
    XCTAssertEqual(dp.xValue, sut.xMax, @"max was not equal to datapoint");
    XCTAssertEqual(dp.xValue, sut.xMin, @"max was not equal to datapoint");
    XCTAssertEqual(dp.yValue, sut.yMean, @"max was not equal to datapoint");
    XCTAssertEqual(dp.xValue, sut.xMean, @"max was not equal to datapoint");
}

- (void)testAppendingDataPointWithExisitingData_ShouldSetMaxAndMin
{
    ARGraphDataPoint *dp = [[ARGraphDataPoint alloc] initWithX:2 y:3];
    [sut setDatapoints:@[dp]];
    
    ARGraphDataPoint *dp2 = [[ARGraphDataPoint alloc] initWithX:4 y:7];
    
    [sut appendDataPoint:dp2];
    
    
    XCTAssertEqual(7, sut.yMax, @"max was not equal to datapoint");
    XCTAssertEqual(3, sut.yMin, @"max was not equal to datapoint");
    XCTAssertEqual(4, sut.xMax, @"max was not equal to datapoint");
    XCTAssertEqual(2, sut.xMin, @"max was not equal to datapoint");
    XCTAssertEqual(5, sut.yMean, @"max was not equal to datapoint");
    XCTAssertEqual(3, sut.xMean, @"max was not equal to datapoint");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSArray *dpArray = [self arrayOfDataPoints:40000];
        [sut setDatapoints:dpArray];
        // Put the code you want to measure the time of here.
    }];
}

- (NSArray*)arrayOfDataPoints:(NSInteger)count
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while(count--){
        [array addObject:[[ARGraphDataPoint alloc] initWithX:10-count y:14-count]];
    }
    return array;
}

@end
