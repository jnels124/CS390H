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
#import "BestRouteAnnotation.h"
#import "BestRouteDetailViewController.h"

@interface MapViewController : UIViewController
<MKMapViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, MyLocationDelegate > {
}

/*shared instacne with master view controller*/
@property (strong, nonatomic) BestRouteBrain *brain;

/*captures long presses to capture location selction*/
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *lpGesture;

@property (strong, nonatomic) IBOutlet MKMapView *theMap;

@end
