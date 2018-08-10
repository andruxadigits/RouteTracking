//
//  MapViewController.h
//  RouteTracking
//
//  Created by hello on 02/08/2018.
//  Copyright © 2018 hello`. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Route;

@protocol MapViewControllerDelegate <NSObject>
- (void)selectedRouteDetailButton:(Route *)route;
@end

//typedef void(^MapDetail)(Route *route);
@interface MapViewController : UIViewController
//- (void) showMapDetail:(MapDetail)mapdetail;
@property(nonatomic) NSObject <MapViewControllerDelegate> *delegate;
@end
