//
// Created by hello on 07/08/2018.
// Copyright (c) 2018 ___FULLUSERNAME___`. All rights reserved.
//

#import "RouteDetailsViewController.h"
#import "Route.h"
@interface RouteDetailsViewController ()
@property (strong, nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UILabel *totalTime;
@property (strong,nonatomic) UILabel *totalDistance;
@property (strong,nonatomic) UILabel *averageSpeed;

@end
@implementation RouteDetailsViewController {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.stackView = [self setupStackView];
    [self.view addSubview:self.stackView];

    self.totalTime = [self setupTotalTime];
    [self.stackView addArrangedSubview:self.totalTime];
    NSString *timeStr = [NSString stringWithFormat:@"%2f", self.route.time];

    [self.totalTime setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Total time:  ", nil),timeStr]];
    //[self.totalTime setText:[NSString stringWithFormat:@"%@%@",@"Total time:  " ,timeStr]];

    self.totalDistance = [self setupTotalDistance];
    [self.stackView addArrangedSubview:self.totalDistance];
    NSString *distanceStr = [NSString stringWithFormat:@"%2f", self.route.distance];

    [self.totalDistance setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Total distance:  ", nil),distanceStr]];
   // [self.totalDistance setText:[NSString stringWithFormat:@"%@%@",@"Total distance:  " ,distanceStr]];

    self.averageSpeed = [self setupAverageSpeed];
    [self.stackView addArrangedSubview:self.averageSpeed];
    NSString *speedStr = [NSString stringWithFormat:@"%2f", self.route.speed];

    [self.averageSpeed setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Average speed:  ", nil),speedStr]];
   // [self.averageSpeed setText:[NSString stringWithFormat:@"%@%@",@"Average speed:  " ,speedStr]];

    CGFloat _screenSize = MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    CGFloat _spacing = _screenSize/50;
    [self.stackView setSpacing:_spacing];

    [NSLayoutConstraint activateConstraints:@[
            [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:_spacing],
            [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-_spacing],
            [self.stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:_spacing],
            [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-_spacing],

            [self.totalTime.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor],
            [self.totalTime.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
            [self.totalTime.topAnchor constraintEqualToAnchor:self.stackView.topAnchor],
            [self.totalTime.bottomAnchor constraintEqualToAnchor:self.totalDistance.topAnchor],
            [self.totalTime.heightAnchor constraintEqualToAnchor:self.totalDistance.heightAnchor],


            [self.totalDistance.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor],
            [self.totalDistance.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
            [self.totalDistance.bottomAnchor constraintEqualToAnchor:self.averageSpeed.topAnchor],
            [self.averageSpeed.heightAnchor constraintEqualToAnchor:self.totalDistance.heightAnchor],

            [self.averageSpeed.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor],
            [self.averageSpeed.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
        //    [self.averageSpeed.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor],
    ]];


}
- (UIStackView *)setupStackView {
    UIStackView *stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView setAxis:UILayoutConstraintAxisVertical];
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    return stackView;
}
- (UITextView *)setupTotalTime {
    UITextView *label = [UITextView new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor blackColor];
    label.textAlignment = UITextAlignmentLeft;
    [label setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30]];
    return label;
}
- (UITextView *)setupTotalDistance {
    UITextView *label = [UITextView new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor blackColor];
    label.textAlignment = UITextAlignmentLeft;
    [label setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30]];
    return label;
}
- (UITextView *)setupAverageSpeed {
    UITextView *label = [UITextView new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor blackColor];
    label.textAlignment = UITextAlignmentLeft;
    [label setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30]];
    return label;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end