//
//  DyOperationTest.m
//  DYDemo
//
//  Created by company_2 on 2019/4/23.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import "DyOperationTest.h"
//https://www.jianshu.com/p/5ee0aa045127

@implementation DyOperationTest
{
    NSOperationQueue *_queue;
}
-(void)test{
    _queue = [[NSOperationQueue alloc]init];
    [self testBasic9];
}


#pragma mark ================
#pragma mark 基础使用
#pragma mark ================

//MARK: => NSInvocationOperation 创建操作 ---> 创建队列 ---> 操作加入队列
- (void)testBasic1{
    //1:创建操作
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handleInvocation:) object:@"123"];
    //2:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3:操作加入队列 --- 操作会在新的线程中
    [queue addOperation:op];
}


//MARK: => 当任务添加到队列中，无需手动start，否则crash。
- (void)testBasic2{
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handleInvocation:) object:@"123"];
    // 注意 : 如果该任务已经添加到队列,你再手动调回出错
    // something other than the operation queue it is in is trying to start the receiver'
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // [queue addOperation:op];
    // 手动调起操作,默认在当前线程
    [op start];
}


//MARK: => NSBlockOperation 添加到队列中无需start
- (void)testBasic3{
    //1:创建blockOperation
    NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    //1.1 设置监听
    bo.completionBlock = ^{
        NSLog(@"NSBlockOperation completionBlock");
    };
    //2:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3:添加到队列
    [queue addOperation:bo];
}


//MARK: => 测试异步并发
- (void)testBasic4{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (int i = 0; i<20; i++) {
        [queue addOperationWithBlock:^{
            NSLog(@"\n%@---%d\n",[NSThread currentThread],i);
        }];
    }
}


//MARK: ?=> 优先级。只会让CPU有更高的几率调用,不是说设置高就一定全部先完成
- (void)testBasic5{
    NSBlockOperation *bo1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"🍺\n第1个操作 %d --- %@\n", i, [NSThread currentThread]);
        }
    }];
    // 设置优先级 - 最高
    bo1.qualityOfService = NSQualityOfServiceUserInteractive;
    
    // 创建第二个操作
    NSBlockOperation *bo2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"🍺🍺\n第2个操作 %d --- %@\n", i, [NSThread currentThread]);
        }
    }];
    // 设置优先级 - 最低
    bo2.qualityOfService = NSQualityOfServiceBackground;
    
    //2:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3:添加到队列
    [queue addOperation:bo1];
    [queue addOperation:bo2];
}


//MARK: => 线程通讯
- (void)testBasic6{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"QUEUE_NAME";
    [queue addOperationWithBlock:^{
        NSLog(@"%@ = %@",[NSOperationQueue currentQueue],[NSThread currentThread]);
        //模拟请求网络
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"%@ --%@",[NSOperationQueue currentQueue],[NSThread currentThread]);
        }];
    }];
}


//MARK: => 设置最大并发数
- (void)testBasic7{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"QUEUE_NAME";
    queue.maxConcurrentOperationCount = 2;
    // self.queue + op
    for (int i = 0; i<10; i++) {
        [queue addOperationWithBlock:^{ // 一个任务
            [NSThread sleepForTimeInterval:2];
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        }];
    }
}


- (void)handleInvocation:(id)param{
    NSLog(@"\n🍺%@ --- %@\n",param,[NSThread currentThread]);
   
}

#pragma mark ================
#pragma mark 暂停和挂起
#pragma mark ================
- (void)testBasic8{
    _queue.name = @"dyoungg";
    _queue.maxConcurrentOperationCount = 2;
    for (int i = 0; i<100; i++) {
        [_queue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"🖼🖼🖼🖼f%@-----%d",[NSThread currentThread],i);
        }];
    }
}

/**
 正在执行的操作无法被挂起。
 */
- (void)pauseOrContinue{
    if (_queue.operationCount == 0) {
        NSLog(@"当前没有操作,没有必要挂起和继续");
        return;
    }
    _queue.suspended = !_queue.isSuspended;
}

- (void)cancel{
    // 执行结果发现,正在执行的操作无法取消,因为这要回想到之前的NSThread
    // 只有在内部判断才能取消完毕
    // 取消操作之后,再点继续,发现没有调度的任务没了 会
    [_queue cancelAllOperations]; // queue
    // 下次就得重新添加任务 discard
}

#pragma mark ================
#pragma mark 设置依赖
#pragma mark ================
- (void)testBasic9{
    
    NSBlockOperation *bo1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"请求token");
    }];
    
    NSBlockOperation *bo2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"拿着token,请求数据1");
    }];
    
    NSBlockOperation *bo3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"拿着数据1,请求数据2");
    }];
    
    // 建立依赖 -- 循环乔涛
    [bo2 addDependency:bo1];
    [bo3 addDependency:bo2];
    // [bo1 addDependency:bo3];
    
    [_queue addOperations:@[bo1,bo2,bo3] waitUntilFinished:YES];
    
    NSLog(@"执行完了?我要干其他事");
}


@end
