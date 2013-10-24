//
//  Route.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestRouteTrip.h"

@interface Route : NSObject {
    // Name of route given by user
    NSString *routeName;
    // The total average time for all trips using this route
    double  avgRouteTime;
    // Array of trips which used this route
    NSArray *allTripsFromRoute;
}

// Adds trip to allTripsFromRoute
- (void) addTrip:(BestRouteTrip *)newTrip;

- (void) determineAverageTime;

// Determines if two routes are the same
//    will return true if both the starting
//    and ending location of this segment
//    are within 25 meters of the passed in
//    segment
- (BOOL) isEqual:(Route *)segment;
@end
