//
// Created by hello on 02/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//


#import "MapViewCoordinator.h"
#import "MapViewController.h"
@interface  MapViewCoordinator()

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
    [self.presenter pushViewController:self.mapViewController animated:YES];
    }


@end