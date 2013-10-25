//
//  Route.m
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "Route.h"

@implementation Route
@synthesize
allTripsFromRoute,
avgRouteTime,
routeName;

- (Route *)initWithRouteName:(NSString *)name {
    if ( self = [ super init ] ) {
        self.avgRouteTime = 0.0;
        self.allTripsFromRoute = [ [ NSArray alloc ] init ];
        self.routeName = name;
    }
    
    return self;
}

// Adds trip to allTripsFromRoute
- (NSArray *) addTrip:(BestRouteTrip *)newTrip {
    NSMutableArray *trips = [ [ NSMutableArray alloc ]
                             initWithArray:self.allTripsFromRoute ];
    [ trips addObject:newTrip ];
    return trips;
}

- (double) determineAverageTime {
    double average = 0.0;
    for ( BestRouteTrip *trip in allTripsFromRoute ) average += trip.tripTime;
    
    return average;
}

- (BOOL) isEqual:(Route *)route {
    return NO;
}
@end
