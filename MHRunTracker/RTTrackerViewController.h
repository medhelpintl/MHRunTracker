//
//  RTViewController.h
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PSLocationManager.h"

@interface RTTrackerViewController : UIViewController <PSLocationManagerDelegate, MKMapViewDelegate, RKObjectLoaderDelegate>
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UILabel *totalDistanceLbl;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIButton *trackingBtn;
@property (nonatomic, strong) MKPolyline *routeLine; //your line
@property (nonatomic, strong) MKPolylineView *routeLineView; //overlay view
@property (nonatomic, strong) NSArray *healthData;
- (IBAction)trackingButtonSelected:(id)sender;
@end
