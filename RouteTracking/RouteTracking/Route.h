//
// Created by hello on 07/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Route : NSObject
@property(readonly, nonatomic) CGFloat time;
@property(readonly, nonatomic) CGFloat distance;
@property(readonly, nonatomic) CGFloat speed;

- (instancetype)initWithTime:(NSTimeInterval)time distance:(CGFloat)distance;
@end