//
// Created by hello on 07/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import "Route.h"

@interface Route ()
@property (readwrite, nonatomic) CGFloat time;
@property (readwrite, nonatomic) CGFloat distance;
@property (readwrite, nonatomic) CGFloat speed;

@end
@implementation Route {

}
-(instancetype) initWithTime:(CGFloat)time distance:(CGFloat)distance speed:(CGFloat)speed {
    self = [super init];
    if (self) {
        self.time = time;
        self.distance = distance;
        self.speed = speed;

    }
    return self;
}
-(instancetype) initWithTime:(CGFloat)time distance:(CGFloat)distance {
    self = [super init];
    if (self) {
        self.time = time;
        self.distance = distance;
        self.speed = distance / time;
    }
        return self;
}

@end