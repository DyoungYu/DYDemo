
//
//  DyOtherTest.m
//  DYDemoTests
//
//  Created by mac on 2020/2/21.
//  Copyright © 2020 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HashObj.h"

@interface DyOtherTest : XCTestCase

@end

@implementation DyOtherTest

- (void)testHashEqual {
    //加入“相同”对象进入set
    HashObj *obj = [[HashObj alloc]init];
    obj.name = @"obj";
    obj.age = 1;
   
    
    HashObj *obj2 = [[HashObj alloc]init];
    obj2.name = @"obj";
    obj2.age =1;
    
    NSMutableSet *set = [[NSMutableSet alloc]init];
    [set addObject:obj];
    [set addObject:obj2];
    NSLog(@"setCount == %ld",set.count);
    
    //比较颜色相等。
    UIColor *color1 = [UIColor redColor];
    UIColor *color2 = [UIColor redColor];
    NSLog(@" ？？？: %@",color1 == color2 ? @"YES" : @"NO");
        

    //    if (obj==obj2) {//比较对象地址，即是否为同一对象。
    //        NSLog(@"相等");
    //    }
    //    if ([obj isEqual:obj2]) {
    //        NSLog(@"isEqual相等");
    //    }
    //    NSLog(@"obj == %p\n",obj);
    //    NSLog(@"obj == %ld\n",(NSInteger)obj);  
    //    NSLog(@"objHash == %ld\n",[obj hash]);
}

@end
