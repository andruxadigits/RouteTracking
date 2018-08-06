//
//  MapViewController.m
//  RouteTracking
//
//  Created by hello on 02/08/2018.
//  Copyright © 2018 hello`. All rights reserved.
//

#import "MapViewController.h"
#import <Mapkit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#define METERS_MILE 2000
#define METERS_FEET 3.28084

@interface MapViewController ()
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UIButton *startButton;
@end

@implementation MapViewController{
    CLLocationCoordinate2D oldCoordinate;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Your location";

    oldCoordinate.longitude = 0;
    oldCoordinate.latitude = 0;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager setDelegate:self];
    [self.locationManager requestWhenInUseAuthorization];
  /*  if (CLLocationManager.locationServicesEnabled) {
        [self.locationManager requestLocation];
        [self.locationManager requestLocation];
    }*/
   CLAuthorizationStatus *status = CLLocationManager.authorizationStatus;

   if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
       [self.locationManager requestAlwaysAuthorization];
       [self.locationManager requestWhenInUseAuthorization];

   }

   [self.locationManager startUpdatingLocation];
   [self.locationManager startUpdatingHeading];



     self.stackView = [self setupStackView];
     [self.view addSubview:self.stackView];
     self.mapView = [self setupMapView];
     [self.stackView addArrangedSubview:self.mapView];

     self.startButton = [self setupStartButton];
     [self.stackView addArrangedSubview:self.startButton];


     CGFloat screenSize = MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
     CGFloat spacing;
     spacing = screenSize/50;
     [self.stackView setSpacing:spacing];
     [NSLayoutConstraint activateConstraints:@[
             [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:spacing],
             [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-spacing],
             [self.stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:spacing],
           //  [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-spacing],

             [self.mapView.leftAnchor constraintEqualToAnchor:self.stackView.leftAnchor],
             [self.mapView.rightAnchor constraintEqualToAnchor:self.stackView.rightAnchor],
             [self.mapView.widthAnchor constraintEqualToAnchor:self.mapView.heightAnchor multiplier:1.0f],

             [self.startButton.heightAnchor constraintEqualToConstant:screenSize/20],
           //  [self.startButton.widthAnchor constraintEqualToAnchor:self.startButton.heightAnchor multiplier:3.0f],
         //    [self.startButton.centerXAnchor constraintEqualToAnchor:self.mapView.centerXAnchor],
           // [self.startButton.topAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:spacing]

             ]];

    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view, typically from a nib.
}
- (UIStackView *)setupStackView {
    UIStackView *stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView setAxis:UILayoutConstraintAxisVertical];
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionEqualCentering;
    return stackView;
}
- (UIButton *)setupStartButton {
    UIButton *button = [UIButton new];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"START" forState:UIControlStateNormal];
    [button setTitle:@"FINISH" forState:UIControlStateSelected];
    [button setSelected:NO];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // button.
    [button addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (MKMapView *)setupMapView {
    MKMapView *mapView = [MKMapView new];
    mapView.delegate = self;
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [mapView setShowsUserLocation:YES];
    mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    return mapView;
}

- (void) startButtonTapped {
    if (self.startButton.state == UIControlStateNormal)
    [self.startButton setSelected:YES];
    else {
        [self.startButton setSelected:NO];
        []
    }

}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

   //LLocationCoordinate2D coordinates[]
    CLLocation *oldLocationNew = oldLocation;
    CLLocationCoordinate2D oldCoordinates;
    CLLocationCoordinate2D newCoordinates;
    CLLocationCoordinate2D coordinates[2];
    oldCoordinates = oldLocationNew.coordinate;
    newCoordinates = newLocation.coordinate;
    if (oldLocationNew!=nil) {

        coordinates[0]=oldCoordinates;coordinates[1]=newCoordinates;
        MKPolyline *polyline= [MKPolyline polylineWithCoordinates:coordinates count:2] ;
        [self.mapView addOverlay:polyline];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if ([overlay isMemberOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *pr = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        pr.strokeColor = [UIColor redColor];
        pr.lineWidth =5;
        return pr;
    }
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    if (self.startButton.state == UIControlStateSelected)
    {
        CLLocationCoordinate2D coordinates[2];
        if (oldCoordinate.latitude == 0 && oldCoordinate.longitude == 0)
            coordinates[0] = location.coordinate;
        else
            coordinates[0] = oldCoordinate;
        coordinates[1] = location.coordinate;

        MKPolyline *polyline= [MKPolyline polylineWithCoordinates:coordinates count:2] ;
        [self.mapView addOverlay:polyline];
        oldCoordinate = location.coordinate;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
