//
// Created by hello on 07/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinator.h"
@class Route;
@protocol MapViewControllerDelegate;
@interface RouteDetailsViewCoordinator : NSObject<Coordinator>
- (instancetype) initWithPresenter:(UINavigationController *) presenter route:(Route *)routel;
@property  (nonatomic) NSObject <MapViewControllerDelegate> *delegate;
@end