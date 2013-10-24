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
currentSegment;

-(id)init {
    if ( self = [ super init ] ) {
        self.locationManager = [ CLLocationManager new ];
        self.locationManager.delegate = self;
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
@end
