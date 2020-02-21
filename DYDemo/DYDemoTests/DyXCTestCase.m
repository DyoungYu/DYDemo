//
//  DyXCTestCase.m
//  DYDemoTests
//
//  Created by company_2 on 2019/4/17.
//  Copyright © 2019 dyoung. All rights reserved.
//

//参考
//http://liuyanwei.jumppo.com/2016/03/10/iOS-unit-test.html
//常用宏的介绍
//https://blog.csdn.net/nunchakushuang/article/details/38112091

#import <XCTest/XCTest.h>
#import "Test1.h"

@interface DyXCTestCase : XCTestCase

@end

@implementation DyXCTestCase
{
    Test1 *_t1;
}
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _t1 = [[Test1 alloc]init];
}

- (void)tearDown {
    _t1 = nil;
}

- (void)testBlock {
    
    //1、全局block __NSGlobalBlock__
    //● 定义在函数外面的block是global类型的
    //● 定义在函数内部的block，但是没有捕获任何自动变量
    void (^myBlock)(void) = ^{

    };
    //全局block copy后仍然是全局block。 copy不会做任何事。
    NSLog(@"block == %@",[myBlock copy]);
    
    
    //2、堆block。
//    捕获外部变量
//    int a = 10;
//    void (^myBlock)(void) = ^{
//        NSLog(@"a == %d",a);
//    };
//    NSLog(@"block == %@",myBlock);
    
}

#pragma mark 逻辑测试
- (void)testLogic {
    //1、判断第一个和第二个参数是否相等，不等报错。
    NSInteger value = [_t1 addActionP1:30 p2:10];
    XCTAssertEqual(value,40,@"出错");
    //条件判断，第一个条件是否成立。???
    //    XCTAssert(value<20, @"出错2");
}

#pragma mark 期望测试
- (void)testAsynExample {
    
    //expectationForPredicate  谓词计算
    //expectationForNotification
    XCTestExpectation *exp = [self expectationWithDescription:@"这里可以是操作出错的原因描述。。。"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要2秒后才能获取结果，比如一个异步网络请求
        sleep(2);
        //模拟获取的异步操作后，获取结果，判断异步方法的结果是否正确
        XCTAssertEqual(@"a", @"a");
        //如果断言没问题，就调用fulfill宣布测试满足
        [exp fulfill];//表示满足期望
    }];
    
    //设置延迟多少秒后，如果没有满足测试条件就报错
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

#pragma mark 性能测试
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSMutableArray * mutArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9999; i++) {
            NSObject * object = [[NSObject alloc] init];
            [mutArray addObject:object];
        }
    }];
}

#pragma mark 部分测试
- (void)testPerformance {
    //XCTPerformanceMetric_WallClockTime 测试标准。
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        [self action];//提供条件
        [self startMeasuring];
        [self action];//局部测试
        [self stopMeasuring];
    }];
}
- (void)action {
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9999; i++) {
        NSObject * object = [[NSObject alloc] init];
        [mutArray addObject:object];
    }
}




@end
