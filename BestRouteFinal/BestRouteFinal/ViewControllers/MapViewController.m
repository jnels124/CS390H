//
//  MapViewController.m
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/1/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () {
}

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
    mapView.showsUserLocation = YES;
}

#warning Unimplemented
- (void)didReceiveMemoryWarning {
    [ super didReceiveMemoryWarning ];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    for ( BestRouteAnnotation *anno in self.brain.currentSegment.mapAnnotations ) {
        [ self.theMap addAnnotation:anno ];
    }
    self.brain.delegate = self;
    [ self.brain.locationManager startUpdatingLocation ];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog( @"View will disappear called " );
    self.theMap.showsUserLocation = NO;
}

- (void) setBrain:(BestRouteBrain *)brain {
    if ( _brain != brain ) {
        _brain = brain;
    }
}

- (void)locationUpdate:(CLLocation *) location {
    self.theMap.region =
    MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000 );
}

- (IBAction)handleLongPress:(UIGestureRecognizer*)gestureRecognizer {
    /*
     Only handle state as the touches began
     set the location of the annotation
     */
    if ( gestureRecognizer.state == UIGestureRecognizerStateBegan ) {
        CLLocationCoordinate2D coordinate =
        [ self.theMap convertPoint:
         [ gestureRecognizer locationInView:self.theMap ] toCoordinateFromView:self.theMap ];
        [ self.theMap setCenterCoordinate:coordinate animated:YES ];
        BestRouteAnnotation *annotation =
        [ [ BestRouteAnnotation alloc ] initWithLocation:coordinate ] ;
        
        // There is already one annotation in the map for current location
        if ( self.theMap.annotations.count == 1 ) {
            annotation.coordinate = coordinate;
            annotation.title = @"Start";
            annotation.subTitle = @"Start time info"; // still needs to be set
            self.brain.currentSegment.startCoord = coordinate;
        }
        
        if ( self.theMap.annotations.count == 2 ) {
            annotation.coordinate = coordinate;
            annotation.title = @"End";
            annotation.subTitle = @"End time info";
            self.brain.currentSegment.endCoord = coordinate;
            
            self.theMap.showsUserLocation = NO;
            [ self.brain.locationManager stopUpdatingLocation ];
            [ self.brain writeData ];
            [ self.navigationController popToRootViewControllerAnimated:YES ];
        }
        
        else if ( self.theMap.annotations.count > 2 ) {
            annotation.coordinate = coordinate;
            annotation.title = @"Places To Stop";
            annotation.subTitle = @"Stop time info";
        }
    
        [ self.theMap addAnnotation:annotation ];
        
        self.brain.currentSegment.mapAnnotations =
        self.theMap.annotations;
    }
}

#warning DRY
- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView * annoView = nil;
    static NSString *ident;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [ [ segue identifier ] isEqualToString:@"toDetail" ] ) {
        [ [ segue destinationViewController ] setDetailItem:[ self.brain.currentTrip description ] ];
    }
}

@end
