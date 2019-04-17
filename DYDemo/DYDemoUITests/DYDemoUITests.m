//
//  DYDemoUITests.m
//  DYDemoUITests
//
//  Created by company_2 on 2019/4/3.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DYDemoUITests : XCTestCase

@end

@implementation DYDemoUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


#pragma mark UI测试
- (void)testLoginUI{
    
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    //拿到self.view 并且tap
//    [[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"View"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element tap];
//    //拿到self.view
//    XCUIElement *element = [[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"login"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
//    //获取到账号输入框
//    XCUIElement *acField = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0];
//    XCUIElement *pwField = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:1];
//    [acField tap];
//    [acField typeText:@"123456"];
//    [pwField tap];
//    [pwField typeText:@"123"];
//
//    //获取到button
////    XCUIElementQuery *btnQuery = [element childrenMatchingType:XCUIElementTypeButton];
////    XCUIElement *loginBtn = [btnQuery elementBoundByIndex:0];
//
//    [app.buttons[@"login"] tap];
//

    
}

@end
