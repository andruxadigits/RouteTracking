//
//  AppDelegate.h
//  RouteTracking
//
//  Created by hello on 02/08/2018.
//  Copyright © 2018 hello`. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppCoordinator;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(nonatomic) AppCoordinator *appCoordinator;

@end
