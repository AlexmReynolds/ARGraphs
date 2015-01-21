//
//  ARPieChartDPUtil_Tests.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/19/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ARPieChartDataPointUtility.h"
#import "ARGraphDataPoint.h"

@interface ARPieChartDPUtil_Tests : XCTestCase{
    ARPieChartDataPointUtility *sut;
}

@end

@implementation ARPieChartDPUtil_Tests
- (void)setUp {
    sut = [[ARPieChartDataPointUtility alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    sut = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssertNotNil(sut,@"sut should exist");
}

#pragma mark - Array of DataPoints

- (void)testSum_ShouldSumAllDataPointsInSimpleArray
{
    sut.datapoints = [self arrayOfDataPoints]; //10 + 11 + 12 + 13 + 14
    
    XCTAssertEqual([sut datapointsTotal], 60, @"Sum was not 60");
}

- (void)testSmallestSliceIndex_ShouldReturn4
{
    sut.datapoints = [self arrayOfDataPoints]; //10 + 11 + 12 + 13 + 14
    XCTAssertEqual([sut smallestSliceIndex], 0, @"Smallest index was not 0");
}

- (void)testLargestSliceIndex_ShouldReturn0
{
    sut.datapoints = [self arrayOfDataPoints]; //10 + 11 + 12 + 13 + 14
    XCTAssertEqual([sut largestSliceIndex], 4, @"Largest index was not 4");
}

- (void)testSliceSumAtIndex1_ShouldReturn11
{
    sut.datapoints = [self arrayOfDataPoints]; //10 + 11 + 12 + 13 + 14
    XCTAssertEqual([sut sliceSumAtIndex:1],11, @"sum at index 1 was not 11");

}

- (void)testSliceSumAtIndex4_ShouldReturn14
{
    sut.datapoints = [self arrayOfDataPoints]; //10 + 11 + 12 + 13 + 14
    XCTAssertEqual([sut sliceSumAtIndex:4] ,14, @"sum at index 4 was not 14");
}

- (void)testSlicePercentageAtIndex4_ShouldReturnPercent
{
    sut.datapoints = [self arrayOfDataPoints]; //10 + 11 + 12 + 13 + 14
    XCTAssertEqual([sut slicePercentageAtIndex:4] ,14.0/60.0, @"sum at index 4 was not 14");
}

#pragma mark - Array of arrays of DataPoints

- (void)testSum_ShouldSumAllDataPointsInComplexArray
{
    sut.datapoints = [self arrayOfArrayOfDataPoints]; //60 * 5
    
    XCTAssertEqual([sut datapointsTotal], 300);
}

- (NSArray*)arrayOfDataPoints
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger count = 5;
    while(count--){
        [array addObject:[[ARGraphDataPoint alloc] initWithX:10-count y:14-count]];
    }
    return array;
}

- (NSArray*)arrayOfArrayOfDataPoints
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger count = 5;
    while(count--){
        [array addObject:[self arrayOfDataPoints]];
    }
    return array;
}

@end
