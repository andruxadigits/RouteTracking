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
#import "Route.h"

#define METERS_MILE 100
#define METERS_FEET 3.28084

@interface MapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate >
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) MKMapView *mapView;
@property(strong, nonatomic) UIStackView *stackView;
@property(strong, nonatomic) UIButton *startButton;
@property(strong, nonatomic) UIStackView *detailStackView;
@property(strong, nonatomic) UITextView *timeLabel;
@property(strong, nonatomic) UITextView *distanceLabel;
@property(strong, nonatomic) UITextView *speedLabel;
@property(strong, nonatomic) MKMapCamera *camera;
@end

@implementation MapViewController {
    CLLocationCoordinate2D _oldCoordinate;
    CGFloat _screenSize;
    CGFloat _spacing;
    CGFloat _latitudinalMeters;
    CGFloat _longitudinalMeters;
    NSDate *_startDate;
    NSTimer *_stopTimer;
    NSTimeInterval _timeInterval;
    CLLocationDistance _distance;
    NSDateFormatter *_dateFormatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Your location", nil)];


    //self.navigationItem.title = @"Your location";

    _oldCoordinate.longitude = 0;
    _oldCoordinate.latitude = 0;
    _latitudinalMeters = METERS_MILE;
    _longitudinalMeters = METERS_MILE;
    [_stopTimer invalidate];
    _stopTimer = nil;
    _startDate = [NSDate date];
    _distance = 0;
    _dateFormatter = [[NSDateFormatter alloc] init];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager setDelegate:self];
    [self.locationManager requestWhenInUseAuthorization];
    /*  if (CLLocationManager.locationServicesEnabled) {
          [self.locationManager requestLocation];
          [self.locationManager requestLocation];
      }*/
    CLAuthorizationStatus status = CLLocationManager.authorizationStatus;

    if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];

    }
  //  self.locationManager.distanceFilter = 1;
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];


    self.stackView = [self setupStackView];
    [self.view addSubview:self.stackView];
    self.mapView = [self setupMapView];
    [self.stackView addArrangedSubview:self.mapView];
    self.camera = [MKMapCamera cameraLookingAtCenterCoordinate:self.locationManager.location.coordinate fromEyeCoordinate:self.locationManager.location.coordinate eyeAltitude:300];
    [self.mapView setCamera:self.camera animated:YES];


    self.detailStackView = [self setupDetailStackView];
    [self.stackView addArrangedSubview:self.detailStackView];
    self.timeLabel = [self setupTimeLabel];
    [self.detailStackView addSubview:self.timeLabel];
    self.distanceLabel = [self setupDistanceLabel];
    [self.detailStackView addSubview:self.distanceLabel];
    self.speedLabel = [self setupSpeedLabel];
    [self.detailStackView addSubview:self.speedLabel];

    self.startButton = [self setupStartButton];
    [self.stackView addArrangedSubview:self.startButton];


    _screenSize = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _spacing = _screenSize / 50;
    [self.stackView setSpacing:_spacing];
    [NSLayoutConstraint activateConstraints:@[
            [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:_spacing],
            [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-_spacing],
            [self.stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:_spacing],
            [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-_spacing],

            [self.mapView.topAnchor constraintEqualToAnchor:self.stackView.topAnchor],
            [self.mapView.leftAnchor constraintEqualToAnchor:self.stackView.leftAnchor],
            [self.mapView.rightAnchor constraintEqualToAnchor:self.stackView.rightAnchor],
            [self.mapView.bottomAnchor constraintEqualToAnchor:self.detailStackView.topAnchor],
            // [self.mapView.widthAnchor constraintEqualToAnchor:self.mapView.heightAnchor multiplier:1.0f],


            [self.detailStackView.heightAnchor constraintEqualToConstant:_screenSize / 8],
            [self.detailStackView.bottomAnchor constraintEqualToAnchor:self.startButton.topAnchor],// constant:_screenSize/20],
            [self.detailStackView.leftAnchor constraintEqualToAnchor:self.stackView.leftAnchor],
            [self.detailStackView.rightAnchor constraintEqualToAnchor:self.stackView.rightAnchor],

            [self.timeLabel.leftAnchor constraintEqualToAnchor:self.detailStackView.leftAnchor],
            [self.timeLabel.topAnchor constraintEqualToAnchor:self.detailStackView.topAnchor],
            [self.timeLabel.bottomAnchor constraintEqualToAnchor:self.detailStackView.bottomAnchor],
            [self.timeLabel.rightAnchor constraintEqualToAnchor:self.distanceLabel.leftAnchor],

            [self.distanceLabel.topAnchor constraintEqualToAnchor:self.detailStackView.topAnchor],
            [self.distanceLabel.bottomAnchor constraintEqualToAnchor:self.detailStackView.bottomAnchor],
            [self.distanceLabel.rightAnchor constraintEqualToAnchor:self.speedLabel.leftAnchor],

            [self.speedLabel.topAnchor constraintEqualToAnchor:self.detailStackView.topAnchor],
            [self.speedLabel.bottomAnchor constraintEqualToAnchor:self.detailStackView.bottomAnchor],
            [self.speedLabel.rightAnchor constraintEqualToAnchor:self.detailStackView.rightAnchor],

            [self.speedLabel.widthAnchor constraintEqualToAnchor:self.distanceLabel.widthAnchor],
            [self.timeLabel.widthAnchor constraintEqualToAnchor:self.distanceLabel.widthAnchor],

            [self.startButton.heightAnchor constraintEqualToConstant:_screenSize / 20],
            [self.startButton.leftAnchor constraintEqualToAnchor:self.stackView.leftAnchor],
            [self.startButton.rightAnchor constraintEqualToAnchor:self.stackView.rightAnchor],

            //  [self.startButton.widthAnchor constraintEqualToAnchor:self.startButton.heightAnchor multiplier:3.0f],
            //    [self.startButton.centerXAnchor constraintEqualToAnchor:self.mapView.centerXAnchor],

            [self.startButton.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor],

            //
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
    [button setTitle:[NSString stringWithFormat:NSLocalizedString(@"START", nil)] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:NSLocalizedString(@"FINISH", nil)]  forState:UIControlStateSelected];

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (MKMapView *)setupMapView {
    MKMapView *mapView = [MKMapView new];
    mapView.delegate = self;
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [mapView setShowsUserLocation:YES];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    return mapView;
}

- (UIStackView *)setupDetailStackView {
    UIStackView *stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView setAxis:UILayoutConstraintAxisHorizontal];
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionEqualCentering;
    stackView.backgroundColor = [UIColor blueColor];
    return stackView;
}

- (UITextView *)setupTimeLabel {
    UITextView *label = [UITextView new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
  //  label.text = [NSString stringWithFormat:@"%@%@",@"asda",  "\n\n00.00.00.000"];

    label.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"time", nil),  @"\n\n00.00.00.000"];
   // label.text = @"time\n\n00.00.00.000";
    return label;
}
- (UITextView *)setupSpeedLabel {
    UITextView *label = [UITextView new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;

   // label.text = [NSString stringWithFormat:@"%@%@",@"asda",  "\n\n00.00.00.000"];
    label.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"speed", nil),  @"\n\n0.00"];
  //  label.text = @"speed\n\n0.00";
    return label;
}

- (UITextView *)setupDistanceLabel {
    UITextView *label = [UITextView new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;

  //  label.text = [NSString stringWithFormat:@"%@%@",@"asda",  "\n\n00.00.00.000"];
    label.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"distance", nil),  @"\n\n0.00"];
  //  label.text = @"distance\n\n0.00";
    return label;
}

- (void)startButtonTapped {
    if (self.startButton.isSelected == NO) {
        [self.startButton setSelected:YES];
        _startDate = [NSDate date];
        if (_stopTimer == nil)
            _stopTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(updateTimer)
                                                        userInfo:nil
                                                         repeats:YES];
    } else {
        [self.startButton setSelected:NO];
        _oldCoordinate.longitude = 0;
        _oldCoordinate.latitude = 0;
        [self.mapView removeOverlays:self.mapView.overlays];
        [_stopTimer invalidate];
        _stopTimer = nil;
        _startDate = [NSDate date];
        Route *route = [[Route alloc] initWithTime:_timeInterval distance:_distance];
        [self.delegate selectedRouteDetailButton:route];
        _distance = 0;

        self.timeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"time", nil),  @"\n\n00.00.00.000"];
        self.distanceLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"speed", nil),  @"\n\n0.00"];
        self.speedLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"distance", nil), @ "\n\n0.00"];
      /*  self.timeLabel.text = @"time\n\n00.00.00.000";
        self.distanceLabel.text = @"distance\n\n0.00";
        self.speedLabel.text = @"speed\n\n0.00";*/
    }
}

- (void)updateTimer {
    NSDate *currentDate = [NSDate date];
    _timeInterval = [currentDate timeIntervalSinceDate:_startDate];

    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:_timeInterval];
     [_dateFormatter setDateFormat:@"HH:mm:ss.SSS"];

    [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *timeString = [_dateFormatter stringFromDate:timerDate];

    [self.timeLabel setText:[NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"time", nil),@"\n\n", timeString]];
//    [self.timeLabel setText:[NSString stringWithFormat:@"%@%@", @"time\n\n", timeString]];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isMemberOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *pr = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        pr.strokeColor = [UIColor redColor];
        pr.lineWidth = 5;
        return pr;
    }
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;

    if (location) {
        self.camera = [MKMapCamera cameraLookingAtCenterCoordinate:location.coordinate fromEyeCoordinate:location.coordinate eyeAltitude:300];
        [self.mapView setCamera:self.camera animated:YES];
      }
    if (self.startButton.isSelected) {
        CLLocationCoordinate2D coordinates[2];
        if (_oldCoordinate.latitude == 0 && _oldCoordinate.longitude == 0)
            coordinates[0] = location.coordinate;
        else
            coordinates[0] = _oldCoordinate;
        coordinates[1] = location.coordinate;
        _oldCoordinate = coordinates[0];
        CLLocationDistance distance = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:_oldCoordinate.latitude longitude:_oldCoordinate.longitude]];
        _distance += distance;
        CGFloat totalDistance = (CGFloat) _distance;
        NSString *strTotalDistance = [NSString stringWithFormat:@"%.2f", totalDistance];
        [self.distanceLabel setText:[NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"distance", nil), @"\n\n",strTotalDistance]];
       // [self.distanceLabel setText:[NSString stringWithFormat:@"%@%@", @"distance\n\n", strTotalDistance]];
        CGFloat speed = (CGFloat) location.speed;
        NSString *strSpeed = [NSString stringWithFormat:@"%.2f", speed];

        [self.speedLabel setText:[NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"speed", nil),@"\n\n", strSpeed]];
       // [self.speedLabel setText:[NSString stringWithFormat:@"%@%@", @"speed\n\n", strSpeed]];

        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:2];
        [self.mapView addOverlay:polyline];
        _oldCoordinate = location.coordinate;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
