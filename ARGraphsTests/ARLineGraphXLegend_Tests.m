//
//  ARLineGraphXLegend_Tests.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/29/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "ARLineGraphXLegendView.h"
#import "ARHelpers.h"

@interface ARLineGraphXLegendView (Tests)
- (NSUInteger)getTotalNumberOfLabelsForTest;
- (UILabel*)createLabelForXAxisIndex:(NSInteger)index;
@end

@implementation ARLineGraphXLegendView (Tests)

- (NSUInteger)getTotalNumberOfLabelsForTest
{
    return [[self valueForKey:@"_totalNumberOfLabels"] unsignedIntegerValue];
}

@end

@interface ARLineGraphXLegend_Tests : XCTestCase{
    ARLineGraphXLegendView *sut;
}

@end

@implementation ARLineGraphXLegend_Tests

- (void)setUp {
    [super setUp];
    sut = [[ARLineGraphXLegendView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
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

- (void)testViewCreationPerformance {
    // This is an example of a performance test case.
    id mockDelegate = [self makeMockDelegateNumberOfDP:11];
    
    [self measureBlock:^{
        ARLineGraphXLegendView *test = [[ARLineGraphXLegendView alloc] init];
        test.delegate = mockDelegate;
        test.title = @"foo";
        [test reloadData];
        // Put the code you want to measure the time of here.
    }];
}

- (void)testGivenAWidthOf320And11DataPoints_ShouldBeAbleToFit11
{
    CGFloat width = [ARHelpers widthOfCaptionText:@"1234" inHeight:40];
    NSInteger expected = 320.0/width;
    id mockDelegate = [self makeMockDelegateNumberOfDP:11];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    XCTAssertEqual(expected, [sut getTotalNumberOfLabelsForTest], @"they wer not equal");
}

- (void)testGivenAWidthOf320And3DataPoints_ShouldBeAbleToFit3
{
    NSInteger expected = 3;
    id mockDelegate = [self makeMockDelegateNumberOfDP:3];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    XCTAssertEqual(expected, [sut getTotalNumberOfLabelsForTest], @"they wer not equal");
}

- (void)testGiven3DataPoints_ShouldCreate3Labels
{
    NSInteger __block count = 0;
    NSInteger datapoints = 3;
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
        count += 1;
    };
    OCMockObject *mockSut = [OCMockObject partialMockForObject:sut];
    [[[[[mockSut stub] andDo:proxyBlock] andReturn:[UILabel new]] ignoringNonObjectArgs] createLabelForXAxisIndex:0];
    id mockDelegate = [self makeMockDelegateNumberOfDP:datapoints];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    
    XCTAssertEqual(count, datapoints, @"did not make %li labels", datapoints);
    
}

- (void)testGiven4DataPointsWith3ExisitingLabels_ShouldCreate1Labels
{
    NSInteger __block count = 0;
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
        count += 1;
    };

    id mockDelegate = [self makeMockDelegateNumberOfDP:3];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    
    mockDelegate = [self makeMockDelegateNumberOfDP:4];
    
    sut.delegate = mockDelegate;
    OCMockObject *mockSut = [OCMockObject partialMockForObject:sut];
    [[[[[mockSut stub] andDo:proxyBlock] andReturn:[UILabel new]] ignoringNonObjectArgs] createLabelForXAxisIndex:0];
    [sut reloadData];

    XCTAssertEqual(count, 1, @"did not make %i labels", 1);
    
}

#pragma mark - Delegate tests

- (void)testReload_ShouldCallDelegateForNumberOfDataPoints {
    // This is an example of a performance test case.
    id mockDelegate = [self makeMockDelegateNumberOfDP:11];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    XCTAssertNoThrow([mockDelegate verify], @"delegate was not called");
}

- (void)testReturningNoDataPoints_ShouldNotCallValueAtIndex {
    // This is an example of a performance test case.
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARGraphXLegendDelegate)];
    [[[mockDelegate stub] andReturnValue:@0] numberOfDataPoints];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    XCTAssertNoThrow([mockDelegate verify], @"delegate was not called");
}

- (void)testReturning1DataPoints_ShouldCallValueAtIndex0 {
    // This is an example of a performance test case.
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARGraphXLegendDelegate)];
    [[[mockDelegate stub] andReturnValue:@1] numberOfDataPoints];
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:0];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    XCTAssertNoThrow([mockDelegate verify], @"delegate was not called");
}

- (void)testReturning3DataPoints_ShouldCallValueAtIndex0And1And2 {
    // This is an example of a performance test case.
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARGraphXLegendDelegate)];
    [[[mockDelegate stub] andReturnValue:@3] numberOfDataPoints];
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:0];
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:1];
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:2];
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];
    XCTAssertNoThrow([mockDelegate verify], @"delegate was not called");
}

- (void)testReturning100DataPoints_ShouldCallValues {
    // with width 100 we can fit 4 labels
    sut.frame = CGRectMake(0, 0, 100, 40);
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARGraphXLegendDelegate)];
    [[[mockDelegate stub] andReturnValue:@100] numberOfDataPoints];
    
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:0];// first
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:33];
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:66];
    [[[mockDelegate stub] andReturnValue:@5] xLegend:OCMOCK_ANY valueAtIndex:99];//last
    
    sut.delegate = mockDelegate;
    sut.showXValues = YES;
    [sut reloadData];

    XCTAssertNoThrow([mockDelegate verify], @"delegate was not called");
}

#pragma mark - helpers

- (id)makeMockDelegateNumberOfDP:(NSInteger)number
{
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ARGraphXLegendDelegate)];
    [[[mockDelegate stub] andReturnValue:@(number)] numberOfDataPoints];
    [[[[mockDelegate stub] andReturnValue:@5] ignoringNonObjectArgs] xLegend:OCMOCK_ANY valueAtIndex:0];
    return mockDelegate;
}

@end
