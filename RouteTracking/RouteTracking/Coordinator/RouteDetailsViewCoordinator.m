//
// Created by hello on 07/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import "RouteDetailsViewCoordinator.h"
#import "RouteDetailsViewController.h"
#import "Route.h"
@interface  RouteDetailsViewCoordinator ()

@property (nonatomic) UINavigationController *presenter;
@property (nonatomic) RouteDetailsViewController *routeDetailsViewController;
@property (strong, nonatomic) Route *route;
@end
@implementation RouteDetailsViewCoordinator
- (instancetype) initWithPresenter:(UINavigationController *) presenter route:(Route *)route{
    self = [super init];
    if (self)
        self.presenter = presenter;
        self.route = route;
    return self;
}
- (void) start {
    self.routeDetailsViewController = [[RouteDetailsViewController alloc] initWithNibName:nil bundle:nil];
    self.routeDetailsViewController.route = self.route;
    [self.presenter pushViewController:self.routeDetailsViewController animated:YES];
}


@end