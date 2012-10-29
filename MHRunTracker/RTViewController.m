//
//  RTViewController.m
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import "RTViewController.h"

@interface RTViewController ()
- (void)infoButtonSelected:(id)sender;
@end

@implementation RTViewController
@synthesize totalDistanceLbl = totalDistanceLbl_;
@synthesize infoButton = infoButton_;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Added PSLocationManager
    [PSLocationManager sharedLocationManager].delegate = self;
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
    
    [self.infoButton addTarget:self action:@selector(infoButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark PSLocationManagerDelegate

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    
}
- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    
}
- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
    self.totalDistanceLbl.text = [NSString stringWithFormat:@"%1.2fm", distance];
}
- (void)locationManager:(PSLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed {
    NSLog(@"Here is the current waypoints %@", waypoint);
    
}
- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    NSLog(@"An error occurred: %@", error);
}
- (void)locationManager:(PSLocationManager *)locationManager debugText:(NSString *)text {
    NSLog(@"Debug text: %@", text);
}

#pragma mark
#pragma mark Private

- (void)infoButtonSelected:(id)sender
{
    NSLog(@"infoButton was selected");
}

@end
