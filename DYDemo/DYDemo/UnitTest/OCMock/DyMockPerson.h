//
//  DyMockPerson.h
//  DYDemo
//
//  Created by company_2 on 2019/4/17.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DyMockPerson : NSObject

@property (nonatomic,copy) NSString *name;

- (NSString*)getPersonName;
- (NSString*)addFriend:(DyMockPerson *)f1;
- (void)funcWithBlock:(void (^)(NSDictionary *result, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
