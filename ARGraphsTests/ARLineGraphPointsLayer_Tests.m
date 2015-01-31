//
//  ARLineGraphPointsLayer_Tests.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/30/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ARLineGraphPointsLayer.h"
#import "ARGraphDataPoint.h"

@interface ARLineGraphPointsLayer (Tests)
- (CGPoint)pointForDataPoint:(ARGraphDataPoint*)dataPoint index:(NSInteger)index total:(NSInteger)total;
- (BOOL)drawDataPointDot:(ARGraphDataPoint*)dataPoint index:(NSInteger)index inContext:(CGContextRef)context inRect:(CGRect)rect;
@end

@interface ARLineGraphPointsLayer_Tests : XCTestCase{
    ARLineGraphPointsLayer *sut;
}

@end

@implementation ARLineGraphPointsLayer_Tests

- (void)setUp {
    sut = [[ARLineGraphPointsLayer alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    sut = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSut_ShouldExists {
    XCTAssertNotNil(sut, @"sut did not exist");
}

- (void)testSetting1DataPoint_ShouldNotFindASuitablePointOnTheChart {
    NSArray *dataPoints = @[[ARGraphDataPoint dataPointWithX:0 y:0]
                            ];
    sut.dataPoints = dataPoints;
    sut.yMax = 0;
    sut.yMin = 0;

    CGPoint point = [sut pointForDataPoint:dataPoints[0] index:0 total:1];
    
    XCTAssertTrue(point.y == NSNotFound, @"Y was still found");
    XCTAssertTrue(point.x == NSNotFound, @"x was still found");
}

- (void)testSetting1DataPoint_ShouldNotBeAbleToDrawAPoint {
    NSArray *dataPoints = @[[ARGraphDataPoint dataPointWithX:0 y:0]
                            ];
    sut.dataPoints = dataPoints;
    sut.yMax = 0;
    sut.yMin = 0;
    
    BOOL drewPoint = [sut drawDataPointDot:dataPoints[0] index:0 inContext:nil inRect:CGRectZero];
    
    XCTAssertFalse(drewPoint, @"Point was drawn when we only had 1 datapoint");
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [sut setNeedsDisplay];
    }];
}

@end
