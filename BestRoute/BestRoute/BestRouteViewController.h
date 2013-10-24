//
//  BestRouteViewController.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/16/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BestRouteBrain.h"
#import "BestRouteTableViewController.h"
#import "BestRouteAnnotation.h"

#define MAP_DELTA_LATTITUDE = 0.02
#define MAP_DELTA_LONGITUDE = 0.02

#define START_ANNOTATION    = @"Start";
@interface BestRouteViewController : UIViewController
< MKMapViewDelegate, UIGestureRecognizerDelegate > {
    BestRouteBrain *brain;
    BestRouteTableViewController *savedDataTable;
    IBOutlet MKMapView *theMap;
    IBOutlet UILongPressGestureRecognizer *lpGesture;
    CLLocationCoordinate2D selectedLocation;
}

@property (strong, nonatomic) IBOutlet MKMapView *theMap;
@property BestRouteTableViewController *savedDataTable;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *lpGesture;
@property CLLocationCoordinate2D selectedLocation;
- (void*)displayNotification;
- (void*)showStartNotification;
- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)
gestureRecognizer;
@end
