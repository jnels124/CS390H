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

- (void)encodeWithCoder:(NSCoder *)encoder {
    [ encoder encodeObject:self.allTripsFromRoute forKey:@"allTripsFromRoute" ];
    [ encoder encodeDouble:self.avgRouteTime forKey:@"avgRouteTime" ];
    [ encoder encodeObject:self.routeName forKey:@"routeName" ];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ( self = [ super init ] ) {
        self.allTripsFromRoute =
        [ aDecoder decodeObjectForKey:@"allTripsFromRoute" ];
        self.avgRouteTime =
        [ aDecoder decodeDoubleForKey:@"avgRouteTime" ];
        self.routeName =
        [ aDecoder decodeObjectForKey:@"routeName" ];
    }
    return self;
}

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

// Determines the average of all trips taken with this route
- (double) determineAverageTime {
    if ( !self.allTripsFromRoute.count ) return 0;
    double average = 0.0;
    for ( BestRouteTrip *trip in self.allTripsFromRoute ) average += trip.tripTime;
    return average / self.allTripsFromRoute.count;
}

#warning Unimplemented
// Returns YES if routes are equal else, no
- (BOOL) isEqual:(Route *)route {
    return NO;
}

@end
