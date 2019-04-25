//
//  ViewController.m
//  DYDemo
//
//  Created by company_2 on 2019/4/3.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import "ViewController.h"
#import "UITestVC.h"
#import "HashObj.h"
#import "DyOperationTest.h"
#import "DyGCDTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DyGCDTest *pp =   [[DyGCDTest alloc]init];
    
    
    
//    [self hashEqualTest];
//    NSThread *thead =  [[NSThread alloc]initWithTarget:self selector:@selector(semaphoreSync) object:nil];
//    [thead start];
//    [self test];
}

/**
 信号量测试。
 */
//- (void)semaphoreSync {
//
//    NSLog(@"semaphore---begin");
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//
//    for (int i =0; i<20; i++) {
//        dispatch_async(queue, ^{
//            [NSThread sleepForTimeInterval:arc4random()%3];
//            NSLog(@"i=%d---thread==%@\n",i,[NSThread currentThread]);
//            dispatch_semaphore_signal(semaphore);
//        });
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    }
//
//    NSLog(@"semaphore---end");
//}


#pragma mark 重写hash和equal
- (void)hashEqualTest{
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

//unit test
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITestVC *vc = [[UITestVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
