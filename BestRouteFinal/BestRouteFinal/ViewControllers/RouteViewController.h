//
//  RouteViewController.h
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripViewController.h"
#import "BestRouteBrain.h"
#import "MapViewController.h"
@interface RouteViewController : UITableViewController <UIAlertViewDelegate>
/*Shared instance with master view controller*/
@property (strong, nonatomic) BestRouteBrain *brain;
@end
