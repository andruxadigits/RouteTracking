//
// Created by hello on 07/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import "Route.h"

@interface Route ()
@property(readwrite, nonatomic) NSTimeInterval time;
@property(readwrite, nonatomic) CGFloat distance;
@property(readwrite, nonatomic) CGFloat speed;

@end

@implementation Route {

}

- (instancetype)initWithTime:(NSTimeInterval)time distance:(CGFloat)distance {
    self = [super init];
    if (self) {
        self.time = time;
        self.distance = distance;
        self.speed = distance / time;
    }
    return self;
}

@end