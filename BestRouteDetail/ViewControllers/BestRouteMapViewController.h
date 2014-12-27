//
//  BestRouteMapViewController.h
//  BestRouteDetail
//
//  Created by Jesse Nelson on 10/31/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BestRouteBrain.h"
@interface BestRouteMapViewController : UIViewController
<MKMapViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate > {
    //BestRouteBrain *brain;
}
- (IBAction)hadleLongPress:(id)sender;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *lpGesture;
@property (weak, nonatomic) IBOutlet MKMapView *theMap;
@property UIAlertView *startNotification;
@property UIAlertView *segMentNotification;
@property UIAlertView *routeNotification;
@property (strong, nonatomic) id detailItem;
@property (strong,nonatomic) BestRouteBrain *brain;
@end
