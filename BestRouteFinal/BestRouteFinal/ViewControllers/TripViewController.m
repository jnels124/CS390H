//
//  TripViewController.m
//  BestRouteFinal
//
//  Created by Jesse Nelson on 11/2/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "TripViewController.h"

@interface TripViewController () {
    NSMutableArray *_itemsToDisplay;
}

@end

@implementation TripViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

#warning unimplemented
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    _itemsToDisplay = [ [ NSMutableArray alloc ] init ];
    
    // reconstruct volatile data from stored object
    for( int i =0; i < self.brain.currentRoute.allTripsFromRoute.count; i++ ) {
        BestRouteTrip * object =
        self.brain.currentRoute.allTripsFromRoute[i];
        NSString *itemToDisplay =
        [ @"Trip" stringByAppendingString:
         [ NSString stringWithFormat:@"%d", _itemsToDisplay.count + 1 ] ];
        
        itemToDisplay =
        [ itemToDisplay stringByAppendingString:
         [ NSString stringWithFormat:@" ( %f min ), ", object.tripTime ] ];
        itemToDisplay =
        [ itemToDisplay stringByAppendingString:object.timeOfDay];
        [ _itemsToDisplay insertObject:itemToDisplay atIndex:_itemsToDisplay.count ];
    }
    self.brain.delegate = self;
}

// Non-atomic property set by the pushing view controller
- (void) setBrain:(BestRouteBrain *)brain {
    if ( _brain != brain ) {
        _brain = brain;
    }
}

/* Initiates a new trip by allocating a trip on the heap and begins
 requesting location updates
 */
- (void)insertNewObject:(id)sender {
    if ( !_itemsToDisplay ) {
        _itemsToDisplay = [ [ NSMutableArray alloc ] init ];
    }
    self.brain.currentTrip = [ [ BestRouteTrip alloc ] init ];
    self.brain.currentRoute.allTripsFromRoute =
    [ self.brain.currentRoute addTrip:self.brain.currentTrip ];
    [ self.brain.locationManager startUpdatingLocation ];
    
#warning Bad UI technique
    // Hide back and add button from user
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"Trip Active ...";
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _itemsToDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = _itemsToDisplay[ indexPath.row ];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *newTrips =
        [ [ NSMutableArray alloc ] initWithArray:self.brain.currentRoute.allTripsFromRoute ];
        // Reset object attributes
        [ newTrips removeObjectAtIndex:indexPath.row ];
        self.brain.currentRoute.allTripsFromRoute =
        [ [ NSArray alloc ] initWithArray:newTrips ];
        [ self.brain writeData ];
        
        // Reset volatile data
        [ _itemsToDisplay removeObjectAtIndex:indexPath.row ];
        [ tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade ];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)locationUpdate:(CLLocation *) newLocation {
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    
    if ( !self.brain.currentTrip.timer.start &&
        self.brain.currentSegment.startCoord.latitude ) {
        if ( [ self.brain isCoordinate:location WithinDistance:200
                          OfCoordinate:self.brain.currentSegment.startCoord ]) {
            // Don't start timing until destination is selected
            if ( self.brain.currentSegment.endCoord.latitude )
                [ self.brain.currentTrip.timer startTiming ];
        }
    }
    
    if ( !self.brain.currentTrip.timer.end && self.brain.currentSegment.endCoord.latitude ) {
        // Has the user reached their location once ending coord has been selected
        if ( [ self.brain isCoordinate:location WithinDistance:200
                          OfCoordinate:self.brain.currentSegment.endCoord ] ){
            [ self.brain.currentTrip .timer stopTiming ];
            self.brain.currentTrip.tripTime =
            [ self.brain.currentTrip.timer elapsedTime ] / 60.0; // Convert to minutes
            [ self.brain.locationManager stopUpdatingLocation ];
            NSIndexPath *indexPath =
            [ NSIndexPath indexPathForRow:_itemsToDisplay.count inSection:0 ];
            
            NSString *itemToDisplay =
            [ @"Trip" stringByAppendingString:
             [ NSString stringWithFormat:@"%d", _itemsToDisplay.count + 1 ] ];
            itemToDisplay =
            [ itemToDisplay stringByAppendingString:[ NSString stringWithFormat:@" ( %f min)", self.brain.currentTrip.tripTime ] ];
            itemToDisplay =
            [ itemToDisplay stringByAppendingString:@", " ];
            [ itemToDisplay stringByAppendingString:self.brain.currentTrip.timeOfDay];
            [ _itemsToDisplay insertObject:itemToDisplay atIndex:
             _itemsToDisplay.count ];
            
            [ self.tableView insertRowsAtIndexPaths:@[indexPath]
                                   withRowAnimation:UITableViewRowAnimationAutomatic ];
            self.brain.currentRoute.avgRouteTime =
            [ self.brain.currentRoute determineAverageTime ];
            // Put buttons back on navigation bar
            self.navigationItem.hidesBackButton = NO;
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
            self.navigationItem.rightBarButtonItem = addButton;
            self.navigationItem.title = @"Trips";
            
            //[ self.deepSleepPreventer stopPreventSleep ];
            [ self.brain writeData ];
        }
    }
}

- (void)locationError:(NSError *) error {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [ [ segue identifier ] isEqualToString:@"toDetailView" ] ) {
        
        NSIndexPath *indexPath =
        [ self.tableView indexPathForSelectedRow ];
        BestRouteTrip *object =
        self.brain.currentRoute.allTripsFromRoute[ indexPath.row ];
        self.brain.currentTrip = object;
        [ [ segue destinationViewController ] setDetailItem:[ object description ] ];
    }
    
    /*if ( [ [ segue identifier ] isEqualToString:@"toMapView" ] ) {
     [ [ segue destinationViewController ] setDelegate:self ];
     [ [ segue destinationViewController ] setBrain:self.brain ];
     } */
}
@end
