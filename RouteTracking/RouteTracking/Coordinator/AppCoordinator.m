//
// Created by hello on 02/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import "AppCoordinator.h"
#import "MapViewCoordinator.h"

@interface AppCoordinator ()
@property(nonatomic) UIWindow *window;
@property(nonatomic) UINavigationController *rootViewController;
@property(nonatomic) MapViewCoordinator *mapViewCoordinator;
@end

@implementation AppCoordinator
- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
        self.rootViewController = [[UINavigationController alloc] init];
        UIViewController *emptyViewController = [[UIViewController alloc] init];
        emptyViewController.view.backgroundColor = [UIColor whiteColor];
        [self.rootViewController pushViewController:emptyViewController animated:NO];
        self.mapViewCoordinator = [[MapViewCoordinator alloc] initWithPresenter:self.rootViewController];
    }
    return self;
}

- (void)start {
    self.window.rootViewController = self.rootViewController;
    [self.mapViewCoordinator start];
    [self.window makeKeyAndVisible];
}
@end
