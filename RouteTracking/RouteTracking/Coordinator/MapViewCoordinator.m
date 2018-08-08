//
// Created by hello on 02/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//


#import "MapViewCoordinator.h"
#import "MapViewController.h"
#import "RouteDetailsViewCoordinator.h"
@interface  MapViewCoordinator() <MapViewControllerDelegate>

@property (nonatomic) UINavigationController *presenter;
@property (nonatomic) MapViewController *mapViewController;
@end
@implementation MapViewCoordinator
    - (instancetype) initWithPresenter:(UINavigationController *) presenter {
        self = [super init];
        if (self)
            self.presenter = presenter;
        return self;
    }
    - (void) start {
    self.mapViewController = [[MapViewController alloc] initWithNibName:nil bundle:nil];
        self.mapViewController.delegate = self;
        [self.mapViewController.navigationItem setHidesBackButton:YES animated:NO];
        [self.presenter pushViewController:self.mapViewController animated:YES];
    }
-(void)selectedRouteDetailButton:(Route *)route {
    RouteDetailsViewCoordinator *routeDetailsViewCoordinator = [[RouteDetailsViewCoordinator alloc] initWithPresenter:self.presenter route:route];
    routeDetailsViewCoordinator.delegate = self;
    [routeDetailsViewCoordinator start];
}

@end