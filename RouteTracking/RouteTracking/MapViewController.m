//
//  MapViewController.m
//  RouteTracking
//
//  Created by hello on 02/08/2018.
//  Copyright © 2018 hello`. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UIButton *startButton;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    if (CLLocationManager.locationServicesEnabled) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [self.locationManager requestLocation];
    }
    self.view.backgroundColor = [UIColor redColor];
    self.stackView = [self setupStackView];
    [self.view addSubview:self.stackView];
    self.startButton = [self setupStartButton];
    [self.stackView addSubview:self.startButton];
    CGFloat screenSize = MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    CGFloat spacing = screenSize/30;
    [self.stackView setSpacing:spacing];
    [NSLayoutConstraint activateConstraints:@[
            [self.stackView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:spacing],
            [self.stackView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-spacing],
            [self.stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:spacing],
            [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-spacing],

            [self.startButton.widthAnchor constraintEqualToAnchor:self.startButton.heightAnchor multiplier:2.0f],
            [self.startButton.heightAnchor constraintEqualToConstant:screenSize/10],

            ]];
    //  UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"" message:<#(nullable NSString *)message#> preferredStyle:<#(UIAlertControllerStyle)preferredStyle#>]
  //  [alert show];
    // Do any additional setup after loading the view, typically from a nib.
}
- (UIStackView *)setupStackView {
    UIStackView *stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView setAxis:UILayoutConstraintAxisVertical];
    stackView.alignment = UIStackViewAlignmentCenter;
    return stackView;
}
- (UIButton *)setupStartButton {
    UIButton *button = [UIButton new];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.titleLabel.text = @"START";
    [button addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void) startButtonTapped {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end