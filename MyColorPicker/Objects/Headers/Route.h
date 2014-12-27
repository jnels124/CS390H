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
    // Name of route given by user
    NSString *routeName;
    // The total average time for all trips using this route
    double  avgRouteTime;
    // Array of trips which used this route
    NSArray *allTripsFromRoute;
}

@property NSString *routeName;
@property double avgRouteTime;
@property NSArray *allTripsFromRoute;

// Adds trip to allTripsFromRoute
- (NSArray *) addTrip:(BestRouteTrip *)newTrip;

- (double) determineAverageTime;

- (BOOL) isEqual:(Route *)route;

- (Route *)initWithRouteName:(NSString *)name;
@end
