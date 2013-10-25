//
//  BestRouteBrain.m
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteBrain.h"

@implementation BestRouteBrain
@synthesize
locationManager,
currentSegment,
timer,
segments;

-(id)init {
    if ( self = [ super init ] ) {
        self.locationManager = [ CLLocationManager new ];
        self.locationManager.delegate = self;
        self.currentSegment = [ [ BestRouteSegment alloc ] init ];
        //self.segments = [ [ NSDictionary alloc ] init ];
    }
    return self;
}

// Returns an array sorted by time of day
- (NSArray *) routesByTimeOfDay {
    return nil;
}
// Returns an array sorted in chronological order from time of creation
- (NSArray *) routesByChronlogicalOrder {
    return nil;
}

// Returns an array sorted by average route time
- (NSArray *) routesByAverageTime {
    return nil;
}

// Searchs the dictionary to determine if the segment
//   all ready exists
//
// Return NO if segment is not in dictionary else YES
- (BOOL) segmentExists:(BestRouteSegment *)segment {
    return  YES;
}

- (BOOL) isCoordinate:(CLLocationCoordinate2D)firstCoordinate
       WithinDistance:(int)distance
         OfCoordinate:(CLLocationCoordinate2D)secondCoordinate {
    
    return [ BestRouteSegment GetDistance:firstCoordinate.latitude
                        long1:firstCoordinate.longitude
                          la2:secondCoordinate.latitude
                        long2:secondCoordinate.longitude ] >= distance;
}

// Function borrowed from StackOverflow

@end
