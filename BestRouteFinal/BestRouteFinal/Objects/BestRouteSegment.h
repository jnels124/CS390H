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

@interface BestRouteSegment :NSObject <NSCoding>{
    // Name of segment
    NSString *segmentName;
    // String reprsenting starting location for segment
    NSString *startingLocation;
    // String representing ending location for segment
    NSString *endingLocation;
    //Key is name of route and value is a route object;
    NSDictionary *routesForSegment;
    CLLocationCoordinate2D startCoord;
    CLLocationCoordinate2D endCoord;
}

@property CLLocationCoordinate2D startCoord;
@property CLLocationCoordinate2D endCoord;
@property NSString *startingLocation;
@property NSString *endingLocation;
@property NSString *segmentName;
@property NSDictionary *routesForSegment;

// This should be used as the default initializer
- (BestRouteSegment *)initSegmentWithStartingLocation:
(CLLocationCoordinate2D )startCoord
                                    andEndingLocation:
(CLLocationCoordinate2D )endCoord;

+(double)GetDistance:(double)lat1
               long1:(double)lng1
                 la2:(double)lat2
               long2:(double)lng2;
// Displays segments to choose from
- (void) showSegments;

// Returns a new dictionary with the added route
- (NSDictionary *) addRoute:(Route *)newRoute withRouteName:(NSString *)routeName;

// Determines if two segments are the same
//    will return true if both the starting
//    and ending location of this segment
//    are within 25 meters of the passed in
//    segment
- (BOOL) isEqual:(BestRouteSegment *)segment;

- (BOOL) determineIfNewRoute:(Route *) currentRoute;
@end
