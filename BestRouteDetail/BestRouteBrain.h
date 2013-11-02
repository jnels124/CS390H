//
//  BestRouteBrain.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestRouteTimer.h"
#import "BestRouteSegment.h"
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>
#define ROUTE_TO_SAVED     @"/saved"
@interface BestRouteBrain : NSObject < CLLocationManagerDelegate, NSCoding > {
    NSDictionary *segments;
    BestRouteTimer *timer;
    BestRouteSegment *currentSegment;
    //Manages attributes that communicate with GPS
    CLLocationManager *locationManager;
    Firebase *firebase;
   //NSDictionary *routesByTimeOfDay;
   //NSDictionary *routesByAverage;
}

@property ( strong ) CLLocationManager *locationManager;
@property BestRouteSegment *currentSegment;
@property BestRouteTimer *timer;
@property NSDictionary *segments;
@property Firebase *firebase;

// Returns an array sorted by time of day
- (NSArray *) routesByTimeOfDay;
// Returns an array sorted in chronological order from time of creation
- (NSArray *) routesByChronlogicalOrder;
// Returns an array sorted by average route time
- (NSArray *) routesByAverageTime;

// Searchs the dictionary to determine if the segment
//   all ready exists
//
// Return NO if segment is not in dictionary else YES
- (BOOL) segmentExists:(BestRouteSegment *)segment;

- (BOOL) isCoordinate:(CLLocationCoordinate2D)firstCoordinate
       WithinDistance:(int)distance
         OfCoordinate:(CLLocationCoordinate2D)secondCoordinate;

- (void) segmentEnded:(BestRouteSegment *) segment;
- (NSString *) getFilePathByAppending:(NSString *)name;

@end
