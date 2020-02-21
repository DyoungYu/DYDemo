//
//  HashObj.m
//  DYDemo
//
//  Created by company_2 on 2019/4/8.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import "HashObj.h"

@implementation HashObj

- (NSUInteger)hash {
    return [self.name hash]^self.age;
}

- (BOOL)isEqual:(id)object {
    HashObj *obj = (HashObj *)object;
    return [self.name isEqualToString:obj.name] && self.age==obj.age;
}


@end
