//
//  BestRouteSegment.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
#import "BestRouteAnnotation.h"
#import <MapKit/MapKit.h>
@interface BestRouteSegment :NSObject <NSCoding> {
    NSString *segmentName;
    NSString *startingLocation;
    NSString *endingLocation;
    NSDictionary *routesForSegment;
    CLLocationCoordinate2D startCoord;
    CLLocationCoordinate2D endCoord;
}

/*Starting point of segment*/
@property CLLocationCoordinate2D startCoord;

/*Ending point of segment*/
@property CLLocationCoordinate2D endCoord;

/*String representation of starting location for reverse geo-coding*/
@property NSString *startingLocation;

/*String representation of ending location for reverse geo-coding*/
@property NSString *endingLocation;

/*Name of segment given by user*/
@property NSString *segmentName;

/*All of the routes associated with segment*/
@property NSDictionary *routesForSegment;

/*Map annotations. This is saved as persistent data*/
@property NSArray *mapAnnotations;

/*Needed in order to maintain a persistent ordered representation 
 of the dictionary*/
@property NSArray *routeKeys;

/*This should be used as the default initializer*/
- (BestRouteSegment *)initSegmentWithStartingLocation:
(CLLocationCoordinate2D )startCoord
                                    andEndingLocation:
(CLLocationCoordinate2D )endCoord;

// Returns the actual distance between the two locations. 
+(double)GetDistance:(double)lat1
               long1:(double)lng1
                 la2:(double)lat2
               long2:(double)lng2;

// Returns a new dictionary with the added route
- (NSDictionary *) addRoute:(Route *)newRoute withRouteName:(NSString *)routeName;

// Determines if two segments are the same
//    will return true if both the starting
//    and ending location of this segment
//    are within 25 meters of the passed in
//    segment
- (BOOL) isEqual:(BestRouteSegment *)segment;

// Adds a key to saved route segments
- (NSArray *)addKey:(NSString *) key;

#warning Unimplemented
// Will determine if user is on new Route
- (BOOL) determineIfNewRoute:(Route *) currentRoute;

// Returns an array sorted by time of day
- (NSArray *) routesByTimeOfDay;

// Returns an array sorted in chronological order from time of creation
- (NSArray *) routesByChronlogicalOrder;

// Returns an array sorted by average route time
- (NSArray *) routesByAverageTime;
@end
