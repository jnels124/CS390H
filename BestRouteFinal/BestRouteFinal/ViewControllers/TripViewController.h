//
//  TripViewController.h
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/2/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BestRouteTrip.h"
#import "BestRouteDetailViewController.h"
#import "Route.h"
#import "BestRouteBrain.h"
#import "MapViewController.h"
#import "BestRouteTimer.h"

@interface TripViewController : UITableViewController
< MKMapViewDelegate, MyLocationDelegate >

/*Shared instance with master*/
@property (strong,nonatomic) BestRouteBrain *brain;

@end
