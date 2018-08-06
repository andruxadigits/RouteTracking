//
//  MapViewController.h
//  RouteTracking
//
//  Created by hello on 02/08/2018.
//  Copyright © 2018 hello`. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MKMapViewDelegate <NSObject>;
@end

@protocol CLLocationManagerDelegate<NSObject>
        @end
@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>;


@end
