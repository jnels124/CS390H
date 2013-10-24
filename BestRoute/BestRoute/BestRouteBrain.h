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
@interface BestRouteBrain : NSObject <CLLocationManagerDelegate> {
    NSDictionary *segments;
    BestRouteTimer *timer;
    BestRouteSegment *currentSegment;
    //Manages attributes that communicate with GPS
    CLLocationManager *locationManager;
   //NSDictionary *routesByTimeOfDay;
   //NSDictionary *routesByAverage;
    
}

@property (strong)CLLocationManager *locationManager;
@property BestRouteSegment *currentSegment;
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

@end
