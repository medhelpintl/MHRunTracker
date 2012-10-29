//
//  RTViewController.m
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import "RTViewController.h"

@interface RTViewController ()
@property (nonatomic, readwrite, strong) NSMutableArray *wayPointsArray;
@property (nonatomic, assign) MKMapRect routeRect;
- (void)updateMapView;
- (void)infoButtonSelected:(id)sender;
@end

@implementation RTViewController
@synthesize wayPointsArray = wayPointsArray_;
@synthesize totalDistanceLbl = totalDistanceLbl_;
@synthesize infoButton = infoButton_;
@synthesize mapView = mapView_; 
@synthesize routeLine = routeLine_;
@synthesize routeLineView = routeLineView_;
@synthesize routeRect = routeRect_;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    
    self.wayPointsArray = [[NSMutableArray alloc] init];
    
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
    
    [self.wayPointsArray addObject:waypoint];
    NSLog(@"Here is the current waypoints %@", self.wayPointsArray);
    if ([self.wayPointsArray count] > 1) {
        [self updateMapView];
    }
}
- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    NSLog(@"An error occurred: %@", error);
}
- (void)locationManager:(PSLocationManager *)locationManager debugText:(NSString *)text {
    NSLog(@"Debug text: %@", text);
}

#pragma mark
#pragma mark MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 3;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

#pragma mark
#pragma mark Private

- (void)infoButtonSelected:(id)sender
{
    NSLog(@"infoButton was selected");
}

- (void)updateMapView
{
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [self.wayPointsArray count]);
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    for(int idx = 0; idx < [self.wayPointsArray count]; idx++)
    {
        
        CLLocationCoordinate2D coordinate = [[self.wayPointsArray objectAtIndex:idx] coordinate];
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);


        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
        
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:[self.wayPointsArray count]];
    free(pointArr);
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [self.mapView addOverlay:self.routeLine];
}

@end
