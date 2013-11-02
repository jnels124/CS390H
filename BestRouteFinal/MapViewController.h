//
//  MapViewController.h
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BestRouteMasterViewController.h"
@interface MapViewController : UIViewController
<MKMapViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate > {
}
@property (strong, nonatomic) BestRouteBrain *brain;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *lpGesture;
@property (weak, nonatomic) IBOutlet MKMapView *theMap;
@property UIAlertView *startNotification;
@property UIAlertView *segMentNotification;
@property UIAlertView *routeNotification;
@end
