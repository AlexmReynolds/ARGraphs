//
//  ARPieChartLayer_Tests.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/26/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "ARPieChartLayer.h"
#import "ARHelpers.h"

@interface ARPieChartLayer (Test)
- (void)animateSlicePop;
- (void)animateSliceFan;
- (void)animateReveal;

@end

@interface ARPieChartLayer_Tests : XCTestCase{
    ARPieChartLayer *sut;
}

@end

@implementation ARPieChartLayer_Tests

- (void)setUp {
    sut = [[ARPieChartLayer alloc] init];
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
    XCTAssertNotNil(sut, @"Sut was nil");
}

- (void)testSetting5Items_ShouldMake5SliceLayers
{
    sut.numberOfSlices = 5;
    sut.percentages = @[@(0.2),@(0.2),@(0.2),@(0.2),@(0.2)];
    XCTAssertEqual(sut.sublayers.count, 5, @"did not make 5 layers");
}

- (void)testSettingAnimationDefault_ShouldCallAnimateRevealMethod
{
    sut.animationType = ARSliceAnimationDefault;
    OCMockObject *mockedSut = [OCMockObject partialMockForObject:sut];
    [[mockedSut expect] animateReveal];
    [sut animate];
    XCTAssertNoThrow([mockedSut verify], @"default animation not called");
}

- (void)testSettingAnimationPop_ShouldCallPopAnimationMethod
{
    sut.animationType = ARSliceAnimationPop;
    OCMockObject *mockedSut = [OCMockObject partialMockForObject:sut];
    [[mockedSut expect] animateSlicePop];
    [sut animate];
    XCTAssertNoThrow([mockedSut verify], @"pop animation not called");
}

- (void)testSettingAnimationFan_ShouldCallFanAnimationMethod
{
    sut.animationType = ARSliceAnimationFan;
    OCMockObject *mockedSut = [OCMockObject partialMockForObject:sut];
    [[mockedSut expect] animateSliceFan];
    [sut animate];
    XCTAssertNoThrow([mockedSut verify], @"fan animation not called");
}

- (void)testChangingBaseColor_ShouldUpdateAllSliceColors
{
    sut.numberOfSlices = 5;
    sut.percentages = @[@(0.2),@(0.2),@(0.2),@(0.2),@(0.2)];
    sut.fillBaseColor = [UIColor redColor].CGColor;
    NSInteger index = 0;
    CGFloat darkenAmound = 0.1;
    CAShapeLayer *slice = [sut.sublayers objectAtIndex:index];
    CGColorRef darkened = [ARHelpers darkenColor:sut.fillBaseColor withPercent:darkenAmound * index];
    UIColor *pieColor = [UIColor colorWithCGColor:slice.fillColor];
    UIColor *fillDarkenedColor = [UIColor colorWithCGColor:darkened];
    CGColorRelease(darkened);

    XCTAssertTrue([fillDarkenedColor isEqual:pieColor], @"colors were not equal");
}

- (void)testSettingColorsArray_ShouldUpdateAllSliceColors
{
    sut.numberOfSlices = 2;
    sut.percentages = @[@(0.5),@(0.5)];
    sut.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor];
    NSInteger index = 0;
    CAShapeLayer *slice = [sut.sublayers objectAtIndex:index];
    UIColor *pieColor = [UIColor colorWithCGColor:slice.fillColor];
    
    XCTAssertTrue([[UIColor redColor] isEqual:pieColor], @"colors were not equal");
    
    index = 1;
    slice = [sut.sublayers objectAtIndex:index];
    pieColor = [UIColor colorWithCGColor:slice.fillColor];
    
    XCTAssertTrue([[UIColor blueColor] isEqual:pieColor], @"colors were not equal");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        sut.numberOfSlices = 5;
        sut.percentages = @[@(0.2),@(0.2),@(0.2),@(0.2),@(0.2)];
        [sut setNeedsLayout];
        // Put the code you want to measure the time of here.
    }];
}

@end
