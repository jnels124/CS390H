//
//  MapViewController.m
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    self.lpGesture.minimumPressDuration = 1.5;
    self.lpGesture.delegate = self;
    [ self.theMap addGestureRecognizer:self.lpGesture ];
    
    [ mapView setMapType:MKMapTypeStandard ];
    [ mapView setZoomEnabled:YES ];
    [ mapView setScrollEnabled:YES ];
    [ mapView setShowsUserLocation:YES ];
    self.theMap.delegate = self;
    //mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBrain:(BestRouteBrain *)brain {
    if ( _brain != brain ) {
        _brain = brain;
    }
}

- (IBAction)handleLongPress:(UIGestureRecognizer*)gestureRecognizer {
    /*
     Only handle state as the touches began
     set the location of the annotation
     */
    NSLog(@"Handle long press was called");
    if ( gestureRecognizer.state == UIGestureRecognizerStateBegan ) {
        CLLocationCoordinate2D coordinate =
        [ self.theMap convertPoint:
         [ gestureRecognizer locationInView:self.theMap ] toCoordinateFromView:self.theMap ];
        [ self.theMap setCenterCoordinate:coordinate animated:YES ];
        BestRouteAnnotation *annotation =
        [ [ BestRouteAnnotation alloc ] initWithLocation:coordinate ] ;
        
        // There is already one annotation in the map for starting location
        if ( self.theMap.annotations.count == 1 ) {
            annotation.coordinate = coordinate;
            annotation.title = @"Start";
            annotation.subTitle = @"Start time info";
            self.brain.currentSegment.startCoord = coordinate;
        }
        
        if ( self.theMap.annotations.count == 2 ) {
            annotation.coordinate = coordinate;
            annotation.title = @"End";
            annotation.subTitle = @"End time info";
            self.brain.currentSegment.endCoord = coordinate;
        }
        
        else if ( self.theMap.annotations.count > 2 ) {
            // Start location will be
            annotation.coordinate = coordinate;
            annotation.title = @"Places To Stop";
            annotation.subTitle = @"Stop time info";
        }
        
        [ self.theMap addAnnotation:annotation ];
        // Do anything else with the coordinate as you see fit in your application
    }
}

#pragma mark - MKMapViewDelegate methods
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    //NSLog(@"Inside didUpdateUserLocation");
    if ( !self.brain.timer.start && self.brain.currentSegment.startCoord.latitude ) {
        if ( [ self.brain isCoordinate:location WithinDistance:200
                          OfCoordinate:self.brain.currentSegment.startCoord ]) {
            
            //NSLog(@"Inside check for starting coord");
            [ self.brain.timer startTiming ];
        }
    }
    
    // Only continue if the user hasn't reached location but they have chosen an
    // ending coordinate
    if ( !self.brain.timer.end && self.brain.currentSegment.endCoord.latitude ) {
        // Has the user reached their location once ending coord has been selected
        if ( [ self.brain isCoordinate:location WithinDistance:200
                          OfCoordinate:self.brain.currentSegment.endCoord ] ){
            
            [ self.brain.timer stopTiming ];
            
            // If the segment exists, the method being called will set current
            //   segment to the one matching the dictionary entry.
            if ( ![ self.brain segmentExists:self.brain.currentSegment ] ) {
                // Get segment and route name
                self.segMentNotification =
                [ self NotificationWithTitle:@"Segment"
                                     Message:@"Name your segment" ];
                [ self.segMentNotification show ];
            }
            self.routeNotification =
            [ self NotificationWithTitle:@"Route" Message:@"Name your route" ];
        }
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView * annoView = nil;
    static NSString *ident;
    //annoView.annotation = annotation;*/
    if( [ annotation.title isEqualToString:@"Start" ] ||
       [ annotation.title isEqualToString:@"End" ] )   {
        ident =
        [ annotation.title isEqualToString:@"Start"] ? @"greenPin": @"redPin";
        annoView =
        [ mapView dequeueReusableAnnotationViewWithIdentifier:ident ];
        if ( annoView == nil ) {
            annoView =
            [ [ MKPinAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:ident ];
            
            ((MKPinAnnotationView * ) annoView).pinColor =
            [ ident isEqualToString:@"greenPin" ] ? MKPinAnnotationColorGreen
            : MKPinAnnotationColorRed;
            annoView.canShowCallout = YES;
        }
        annoView.annotation = annotation;
    } else if ( [ annotation.title isEqualToString:@"Places To Stop" ] ) {
        ident = @"purplePin";
        annoView =
        [ mapView dequeueReusableAnnotationViewWithIdentifier:ident ];
        if ( annoView == nil ) {
            annoView =
            [ [ MKPinAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:ident ];
            
            ( ( MKPinAnnotationView * ) annoView ).pinColor =
            MKPinAnnotationColorPurple;
            annoView.canShowCallout = YES;
        }
        annoView.annotation = annotation;
    }
    
    ( ( MKPinAnnotationView * ) annoView ).animatesDrop = YES;
    
    return annoView;
}

#pragma mark - UIAlertView Methods
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex {
    if ( alertView == self.startNotification ) {
        if ( buttonIndex == 0 ) {
            // Change views and show saved data
            //[ self.view addSubview:self.savedDataTable.view ];
        } // Other wise do nothing because the map view is already loaded and wating for input
    }
    
    else if ( alertView == self.segMentNotification ) {
        self.brain.currentSegment.segmentName =
        [ alertView textFieldAtIndex:0 ].text;
        NSLog(@"The segment in alert view delegate is %@ ", self.brain.currentSegment.segmentName );
        [ self.routeNotification show ];
    }
    
    else if ( alertView == self.routeNotification ) {
        Route *newRoute =
        [ [ Route alloc  ] initWithRouteName:
         [ alertView textFieldAtIndex:0 ].text ];
        BestRouteTrip *tripData = [ [ BestRouteTrip alloc ] init ];
        tripData.tripTime = [ self.brain.timer elapsedTime ];
        newRoute.allTripsFromRoute = [ newRoute addTrip:tripData ];
        self.brain.currentSegment.routesForSegment =
        [ self.brain.currentSegment addRoute:newRoute
                               withRouteName:newRoute.routeName ];
        
        [ self.brain segmentEnded:self.brain.currentSegment ];
    }
}

- (UIAlertView *)NotificationWithTitle:(NSString *)title
                               Message:(NSString *)message {
    UIAlertView *determineAction =
    [ [ UIAlertView alloc ] initWithTitle:title
                                  message:message
                                 delegate:self
                        cancelButtonTitle:nil//@"Browse Data"
                        otherButtonTitles:@"Save", nil ];
    determineAction.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    return determineAction;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toMapView"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = _objects[indexPath.row];
        BestRouteMasterViewController *source = [ segue sourceViewController ];
         NSLog(@"Going to master from map view ");
        //[ [ segue sourceViewController ] addObject:_objects ];
    }
}
@end
