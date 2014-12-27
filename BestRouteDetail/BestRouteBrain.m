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
currentSegment,
timer,
segments,
firebase;

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSLog(@"Encode in brain was called");
    [ encoder encodeObject:segments forKey:@"segments" ];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ( self = [ super init ] ) {
        self.segments = [ decoder decodeObjectForKey:@"segments" ];
    }
    return self;
}

- (BestRouteSegment *) newSegment {
    return nil;
}

-(id)init {
    if ( self = [ super init ] ) {
        self.locationManager = [ CLLocationManager new ];
        self.locationManager.delegate = self;
        self.currentSegment = [ [ BestRouteSegment alloc ] init ];
        self.timer = [ [ BestRouteTimer alloc ] init ];
        self.locationManager.delegate = self;
        self.firebase = self.firebase = [ [ Firebase alloc ] initWithUrl:
                                         @"https://bestroute.firebaseio.com"];
        //self.segments = [ [ NSDictionary alloc ] init ];
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
// And also sets the BestRouteObjectPassed in to the mathcing segment
- (BOOL) segmentExists:(BestRouteSegment *)segment {
    for ( BestRouteSegment *seg in self.segments ) {
        if ( [ seg isEqual:segment ] ) {
            //Change the segment being passed in to point to correct segment
            segment = seg;
            return YES;
        }
    }
    return  NO;
}

- (BOOL) isCoordinate:(CLLocationCoordinate2D)firstCoordinate
       WithinDistance:(int)distance
         OfCoordinate:(CLLocationCoordinate2D)secondCoordinate {
    double theDistance = [ BestRouteSegment GetDistance:firstCoordinate.latitude
                                                  long1:firstCoordinate.longitude
                                                    la2:secondCoordinate.latitude
                                                  long2:secondCoordinate.longitude ]
    * 1609.34 ; // Convert to meters
    //NSLog(@"inside is coordinate within distance. The distance is %f", theDistance  );
    return theDistance <= distance;
}

- (void) segmentEnded:(BestRouteSegment *)segment {
    if ( !segment.segmentName )
        NSLog(@"The segment passed to segmentEnded is Null");
    
    NSMutableDictionary *savedSegments =
    [ [ NSMutableDictionary alloc ] initWithDictionary:self.segments ];
    [ savedSegments setObject:segment forKey:segment.segmentName ];
    self.segments = [ [ NSDictionary alloc ] initWithDictionary:savedSegments ];
    // Set up data to be archived
    NSData *data = [ NSKeyedArchiver archivedDataWithRootObject:self.segments ];
    //[ data ]
    //NSData *data1 =
    //[ NSKeyedArchiver archivedDataWithRootObject:self.currentSegment.routesForSegment ];
    [ data writeToFile:[ self getFilePathByAppending:@"segments" ] atomically:TRUE ];
    if ( segment != self.currentSegment ) NSLog( @"The incorrect segment came to segment Ended" );
    if (!self.currentSegment.routesForSegment)
        NSLog(@"The routes for current segment are null in segment ended" );
    NSLog(@"data was writen to file");
}

- (NSString *) getFilePathByAppending:(NSString *) name {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES );
    NSString *documentsDirectory = [ paths objectAtIndex:0 ];
    NSString *filePath =
    [ documentsDirectory stringByAppendingPathComponent:name ];
    
    return filePath;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [ eventDate timeIntervalSinceNow ];
    if ( abs(howRecent) < 15.0 ) {
        NSLog(@"New Latitude %+.6f, Longitude %+.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    }
}

@end
