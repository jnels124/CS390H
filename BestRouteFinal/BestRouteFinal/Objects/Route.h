//
//  Route.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestRouteTrip.h"

@interface Route : NSObject < NSCoding >{
    NSString *routeName;
    double  avgRouteTime;
    NSArray *allTripsFromRoute;
}

/*Name of route given by user*/
@property NSString *routeName;

/*The total average time for all trips using this route*/
@property double avgRouteTime;

/*Array of trips which used this route*/
@property NSArray *allTripsFromRoute;

// Adds trip to allTripsFromRoute
- (NSArray *) addTrip:(BestRouteTrip *)newTrip;

// Determines the average of all trips taken with this route
- (double) determineAverageTime;

// Returns YES if routes are equal else, no
- (BOOL) isEqual:(Route *)route;

// Default initializer
- (Route *)initWithRouteName:(NSString *)name;
@end
