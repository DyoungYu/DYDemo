//
//  DyOCMockTestCase.m
//  DYDemoTests
//
//  Created by company_2 on 2019/4/17.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DyMockPerson.h"
#import <OCMock.h>

@interface DyOCMockTestCase : XCTestCase

@end

@implementation DyOCMockTestCase

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

//MARK:>>替换返回值
- (void)testReturnValue{
    //1、创建普通对象。
    DyMockPerson *p1 = [[DyMockPerson alloc]init];
    //2、创建虚拟对象
    id mockP1 = OCMClassMock([DyMockPerson class]);
    //3、模拟返回值-用”OCMock”替代原有方法的返回值。
    OCMStub([mockP1 getPersonName]).andReturn(@"mockName_2");
    
    NSLog(@"原有值==%@\n",[p1 getPersonName]);
    NSLog(@"现有值==%@\n",[mockP1 getPersonName]);
    
    //4、与原有方法的返回值对比。不等-报错。相等-打印log
//    XCTAssertEqualObjects([mockP1 getPersonName], [p1 getPersonName], @"与原有值相等");
}


//MARK:>>验证方法是否被调用。
- (void)testVerifyFuncIsRunning{
    DyMockPerson *f1 = [[DyMockPerson alloc]init];
    DyMockPerson *f2 = [[DyMockPerson alloc]init];
    
    id mockP1 = OCMClassMock([DyMockPerson class]);
    [mockP1 addFriend:f1];
    [mockP1 addFriend:f2];
    
    //只是模拟返回值，并不会发生方法的调用。
//    OCMStub([mockP1 addFriend:f1]).andReturn(@"friend_1");
    
    //Verify
    OCMVerify([mockP1 addFriend:f1]);
    OCMVerify([mockP1 addFriend:f2]);
    //[OCMArg any]:表示任何参数。
    //OCMArg类似还有：
    //[OCMArg anyPointer]
    //[OCMArg anySelector]
    OCMVerify([mockP1 addFriend:[OCMArg any]]);
    
    //期望方法执行，没执行就报错。
//    OCMExpect([mockP1 addFriend:[OCMArg isNotNil]]);
//    OCMVerifyAll(mockP1);
}

//MARK: => 表示严格的mock
//如果把OCMExpect和OCMStub注释掉时会报错，它要求你执行类中的所有方法，所以比较适合用来测试必须实现的方法，
- (void)testStrictClassMock{
    id mockP1 = OCMStrictClassMock([DyMockPerson class]);
    //注释掉会崩溃
    //[NSException raise:NSInternalInconsistencyException format:@"%@: unexpected method invoked: %@ %@",
    OCMExpect([mockP1 addFriend:[OCMArg isNotNil]]);
    OCMStub([mockP1 addFriend:[OCMArg isNotNil]]);
    
    DyMockPerson *f1 = [[DyMockPerson alloc]init];
    [mockP1 addFriend:f1];
    
    OCMVerifyAll(mockP1);
}


//MARK:>>block参数测试
//- (void)testBlockParameter{
//    id mockP1 = OCMStrictClassMock([DyMockPerson class]);
//    OCMStub([mockP1 funcWithBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
//        
//    };
//}

@end
