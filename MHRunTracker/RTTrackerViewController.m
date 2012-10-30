//
//  RTViewController.m
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import "RTTrackerViewController.h"
#import "MHHealthData.h"
#import "RTRunHistoryViewController.h"

@interface RTTrackerViewController () {
    BOOL currentlyTracking_;
}
@property (nonatomic, readwrite, strong) NSMutableArray *wayPointsArray;
@property (nonatomic, assign) MKMapRect routeRect;
- (void)updateMapView;
- (void)infoButtonSelected:(id)sender;
- (void)postHealthData;
@end

@implementation RTTrackerViewController
@synthesize wayPointsArray = wayPointsArray_;
@synthesize totalDistanceLbl = totalDistanceLbl_;
@synthesize infoButton = infoButton_;
@synthesize mapView = mapView_; 
@synthesize routeLine = routeLine_;
@synthesize routeLineView = routeLineView_;
@synthesize routeRect = routeRect_;
@synthesize healthData = healthData_;
@synthesize trackingBtn = trackingBtn_;
- (void)viewDidLoad
{
    [super viewDidLoad];
    currentlyTracking_ = NO;
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
#pragma mark 

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Loaded healthData for a test: %@", objects);
    self.healthData = objects;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}


#pragma mark
#pragma mark Private

- (void)postHealthData
{
    MHHealthData* healthData = [[MHHealthData alloc] init];
    healthData.dataType = @"Running";
    healthData.value = @"60";
    healthData.startTime = @"Wed Sep 29 15:31:08 +0000 2010";
    healthData.endTime = @"Wed Sep 29 15:31:08 +0000 2010";
    
    // POST to /health_data
    [[RKObjectManager sharedManager] postObject:healthData delegate:self];
}

- (void)trackingButtonSelected:(id)sender
{
    currentlyTracking_ = !currentlyTracking_;
    if (currentlyTracking_) {
        [self.trackingBtn setTitle:@"Stop tracking" forState:UIControlStateNormal];
    } else {
        [self.trackingBtn setTitle:@"Start tracking" forState:UIControlStateNormal];
        [self postHealthData];
    }
}

- (void)infoButtonSelected:(id)sender
{
    NSLog(@"infoButton was selected");
    
    RTRunHistoryViewController *historyController = [[RTRunHistoryViewController alloc] initWithNibName:@"RTRunHistoryViewController" bundle:nil];
    
    UINavigationController *historyNavController = [[UINavigationController alloc] initWithRootViewController:historyController];
    
    [historyNavController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:historyNavController animated:YES completion:^(void){
        NSLog(@"presented view controller");
    }];
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
