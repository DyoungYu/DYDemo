//
//  DyMockPerson.m
//  DYDemo
//
//  Created by company_2 on 2019/4/17.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import "DyMockPerson.h"

@implementation DyMockPerson

- (NSString*)getPersonName{
    return @"mockName_1";
}


- (NSString*)addFriend:(DyMockPerson *)f1{
    NSLog(@"添加朋友==%@\n",[f1 description]);
    return f1.name;
}


- (void)funcWithBlock:(void (^)(NSDictionary *result, NSError *error))block{
        block(@{@"dd":@"aa",@"ee":@"22"},nil);
}

@end
