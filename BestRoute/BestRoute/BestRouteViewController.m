//
//  BestRouteViewController.m
//  BestRoute
//
//  Created by Jesse Nelson on 10/16/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteViewController.h"

@interface BestRouteViewController ()

@property (readonly) BestRouteBrain *brain;
@end

@implementation BestRouteViewController
@synthesize
theMap,
savedDataTable,
//currentLocation,
lpGesture;
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Causes map to center as location changes
    //[ self.theMap setUserTrackingModeFollowWithHeading:YES ];
    [ self showStartNotification ];
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    self.lpGesture.minimumPressDuration = 1.5;
    self.lpGesture.delegate = self;
    [self.theMap addGestureRecognizer:self.lpGesture ];
    
    [ mapView setMapType:MKMapTypeStandard ];
    [ mapView setZoomEnabled:YES ];
    [ mapView setScrollEnabled:YES ];
    [ mapView setShowsUserLocation:YES ];
    self.theMap.delegate = self;
    //mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Lazy instantiation of brain
- (BestRouteBrain *) brain {
    if ( !brain ) {
        brain = [ [ BestRouteBrain alloc ] init ];
    }
    return brain;
}

- (void*)showStartNotification{
    UIAlertView *determineAction =
    [ [ UIAlertView alloc ] initWithTitle:@"Start"
                                  message:@"What would you like to do?"
                                 delegate:self
                        cancelButtonTitle:nil//@"Browse Data"
                        otherButtonTitles:@"Browse Data", @"Take Trip", nil ];
    determineAction.alertViewStyle = UIAlertViewStyleDefault;
    [ determineAction show ];
    return nil;
}

- (IBAction)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    /*
     Only handle state as the touches began
     set the location of the annotation
     */
    if ( gestureRecognizer.state == UIGestureRecognizerStateBegan ) {
        NSLog(@"");
        NSLog(@"Gesture method was called");
        CLLocationCoordinate2D coordinate =
        [self.theMap convertPoint:
         [ gestureRecognizer locationInView:self.theMap ] toCoordinateFromView:self.theMap ];
        NSLog(@"The lattitude is %f", coordinate.latitude );
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
            annotation.coordinate = self.selectedLocation;
            annotation.title = @"Places To Stop";
            annotation.subTitle = @"End time info";
        }
        
        [ self.theMap addAnnotation:annotation ];
        // Do anything else with the coordinate as you see fit in your application
    }
}

#pragma mark - MKMapViewDelegate methods
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    //MKCoordinateSpan span;
    //span.latitudeDelta = 0.005;
    //span.longitudeDelta = 0.005;
    
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    //region.span = span;
    //region.center = location;
    /*CLLocationDistance dist = [loc1 distanceFromLocation:loc2];

    if ( location ) {
    }*/
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(location, 600, 600);
    [ aMapView setRegion:region animated:YES ];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation {
    
   //if ( !([ annotation.title isEqualToString:@"Start"] ||
     //      [ annotation.title isEqualToString:@"End"]) ) return ;
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
            
            ((MKPinAnnotationView * ) annoView).pinColor =
            MKPinAnnotationColorPurple;
            annoView.canShowCallout = YES;
        }
        annoView.annotation = annotation;
    }
/*else {
     ident = @"redPin";
     annoView =
     [ mapView dequeueReusableAnnotationViewWithIdentifier:ident ];
     if ( annoView == nil ) {
     annoView =
     [ [ MKPinAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:ident ];
     
     ((MKPinAnnotationView * ) annoView).pinColor =
     MKPinAnnotationColorRed;
     annoView.canShowCallout = YES;
     }
     annoView.annotation = annotation;
     } */
    
    ((MKPinAnnotationView * ) annoView).animatesDrop = YES;
    
    return annoView;
}

#pragma mark - UIAlertView Methods
- ( void ) alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex {
    /*if ( buttonIndex == 1 ) {
     [ self.brain.dictionaryOfSavedColors setObject:
     [ [ NSArray alloc ] initWithObjects:
     self.brain.red.stringBuilder   ,
     self.brain.green.stringBuilder ,
     self.brain.blue.stringBuilder  ,
     nil
     ]                            forKey:
     [ alertView textFieldAtIndex:0 ].text
     ];
     
     [ [ self.brain.firebase childByAppendingPath:ROUTE_TO_SAVED ]
     setValue:self.brain.dictionaryOfSavedColors ];
     
     [ self setUpItemsForTableView ];
     }
     NSLog(@"There are %d items in alert view delegate pressed", self.savedColorView.itemsToDisplay.count );*/
}

@end
