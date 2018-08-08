//
// Created by hello on 02/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinator.h"

@interface MapViewCoordinator : NSObject <Coordinator>
- (instancetype) initWithPresenter:(UINavigationController *) presenter;

@end