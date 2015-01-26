//
//  ARHelpers_Tests.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/26/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ARHelpers.h"

@interface ARHelpers_Tests : XCTestCase

@end

@implementation ARHelpers_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDarkenMethod {
    // This is an example of a functional test case.
    CGColorRef color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
    CGFloat percent = 0.2;
    CGFloat totalPercent = 1 - percent;
    CGColorRef darkenedColor = [ARHelpers darkenColor:color withPercent:percent];
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(color);
    CGFloat* darkenedComponents = (CGFloat *)CGColorGetComponents(darkenedColor);

    CGColorRelease(darkenedColor);
    XCTAssertEqual(oldComponents[0] * totalPercent, darkenedComponents[0], @"Color was not darkened");
    XCTAssertEqual(oldComponents[1] * totalPercent, darkenedComponents[1], @"Color was not darkened");
    XCTAssertEqual(oldComponents[2] * totalPercent, darkenedComponents[2], @"Color was not darkened");
    
}

- (void)testDarkenMethodIfColorIsTooDark_ShouldReturnZero {
    // This is an example of a functional test case.
    CGColorRef color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    CGFloat percent = 0.2;
    CGColorRef darkenedColor = [ARHelpers darkenColor:color withPercent:percent];
    
    CGFloat* darkenedComponents = (CGFloat *)CGColorGetComponents(darkenedColor);
    
    CGColorRelease(darkenedColor);
    XCTAssertEqual(0, darkenedComponents[0], @"Color was not darkened");
    XCTAssertEqual(0, darkenedComponents[1], @"Color was not darkened");
    XCTAssertEqual(0, darkenedComponents[2], @"Color was not darkened");
    
}

- (void)testLightenMethod {
    // This is an example of a functional test case.
    CGColorRef color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
    CGFloat percent = 0.2;
    CGFloat totalPercent = 1 + percent;
    CGColorRef lightenColor = [ARHelpers lightenColor:color withPercent:percent];
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(color);
    CGFloat* lightenedComponents = (CGFloat *)CGColorGetComponents(lightenColor);
    
    CGColorRelease(lightenColor);
    XCTAssertEqual(oldComponents[0] * totalPercent, lightenedComponents[0], @"Color was not lightened");
    XCTAssertEqual(oldComponents[1] * totalPercent, lightenedComponents[1], @"Color was not lightened");
    XCTAssertEqual(oldComponents[2] * totalPercent, lightenedComponents[2], @"Color was not lightened");
    
}

- (void)testLightenMethodIfColorIsTooLight_ShouldReturnZero {
    // This is an example of a functional test case.
    CGColorRef color = [UIColor colorWithRed:1.0 green:9.0 blue:9.2 alpha:1.0].CGColor;
    CGFloat percent = 0.2;
    CGColorRef lightenColor = [ARHelpers lightenColor:color withPercent:percent];
    
    CGFloat* darkenedComponents = (CGFloat *)CGColorGetComponents(lightenColor);
    
    CGColorRelease(lightenColor);
    XCTAssertEqual(1, darkenedComponents[0], @"Color was not lightened");
    XCTAssertEqual(1, darkenedComponents[1], @"Color was not lightened");
    XCTAssertEqual(1, darkenedComponents[2], @"Color was not lightened");
    
}

- (void)testLightenMethodIfColorIsGrey {
    // This is an example of a functional test case.
    CGColorRef color = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    CGFloat percent = 0.2;
    CGFloat totalPercent = 1 + percent;

    CGColorRef lightenColor = [ARHelpers lightenColor:color withPercent:percent];
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(color);
    CGFloat* lightenedComponents = (CGFloat *)CGColorGetComponents(lightenColor);
    
    CGColorRelease(lightenColor);
    
    XCTAssertEqual(oldComponents[0] * totalPercent, lightenedComponents[0], @"Color was not lightened");
    XCTAssertEqual(oldComponents[0] * totalPercent, lightenedComponents[1], @"Color was not lightened");
    XCTAssertEqual(oldComponents[0] * totalPercent, lightenedComponents[2], @"Color was not lightened");
}

- (void)testPointInCircleWithNoInset_ShouldReturnPoint
{
    CGPoint center = CGPointMake(100, 100);
    CGPoint returnedPoint = [ARHelpers pointInCircle:center insetFromCenterBy:0 angle:90];
    XCTAssertEqual(center.x, returnedPoint.x, @"points were not equal");
    XCTAssertEqual(center.y, returnedPoint.y, @"points were not equal");
}

- (void)testPointInCircleWith10Inset
{
    CGPoint center = CGPointMake(100, 100);
    CGFloat inset = 10.0;
    CGPoint returnedPoint = [ARHelpers pointInCircle:center insetFromCenterBy:inset angle:90];
    XCTAssertEqualWithAccuracy(center.x, returnedPoint.x, 1.0, @"points were not equal");
    XCTAssertEqual(center.y + inset, returnedPoint.y, @"points were not equal");
}

- (void)testPointInCircleWith10InsetWith45Angle
{
    CGPoint center = CGPointMake(100, 100);
    CGFloat inset = 10.0;
    CGFloat offset = sqrt((inset * inset)/2);
    CGPoint returnedPoint = [ARHelpers pointInCircle:center insetFromCenterBy:inset angle:45];
    XCTAssertEqualWithAccuracy(center.x + offset, returnedPoint.x, 1.0, @"points were not equal");
    XCTAssertEqualWithAccuracy(center.y + offset, returnedPoint.y, 1.0, @"points were not equal");
}

- (void)testPointInCircleWith10InsetWith135Angle
{
    CGPoint center = CGPointMake(100, 100);
    CGFloat inset = 10.0;
    CGFloat offset = sqrt((inset * inset)/2);
    CGPoint returnedPoint = [ARHelpers pointInCircle:center insetFromCenterBy:inset angle:135];
    XCTAssertEqualWithAccuracy(center.x - offset, returnedPoint.x, 1.0, @"points were not equal");
    XCTAssertEqualWithAccuracy(center.y + offset, returnedPoint.y, 1.0, @"points were not equal");
}

- (void)testPointInCircleWith10InsetWith225Angle
{
    CGPoint center = CGPointMake(100, 100);
    CGFloat inset = 10.0;
    CGFloat offset = sqrt((inset * inset)/2);
    CGPoint returnedPoint = [ARHelpers pointInCircle:center insetFromCenterBy:inset angle:225];
    XCTAssertEqualWithAccuracy(center.x - offset, returnedPoint.x, 1.0, @"points were not equal");
    XCTAssertEqualWithAccuracy(center.y - offset, returnedPoint.y, 1.0, @"points were not equal");
}

- (void)testPointInCircleWith10InsetWith30Angle
{
    CGPoint center = CGPointMake(100, 100);
    CGFloat inset = 10.0;
    CGFloat yOffset = 5;
    CGFloat xOffset = sqrt((inset * inset) - (yOffset * yOffset));
    CGPoint returnedPoint = [ARHelpers pointInCircle:center insetFromCenterBy:inset angle:30];
    XCTAssertEqualWithAccuracy(center.x + xOffset, returnedPoint.x, 1.0, @"points were not equal");
    XCTAssertEqualWithAccuracy(center.y + yOffset, returnedPoint.y, 1.0, @"points were not equal");
}

- (void)testPointInCircleWith10InsetWith60Angle
{
    CGPoint center = CGPointMake(100, 100);
    CGFloat inset = 10.0;
    CGFloat xOffset = 5;
    CGFloat yOffset = sqrt((inset * inset) - (xOffset * xOffset));
    CGPoint returnedPoint = [ARHelpers pointInCircle:center insetFromCenterBy:inset angle:60];
    XCTAssertEqualWithAccuracy(center.x + xOffset, returnedPoint.x, 1.0, @"points were not equal");
    XCTAssertEqualWithAccuracy(center.y + yOffset, returnedPoint.y, 1.0, @"points were not equal");
}
@end
