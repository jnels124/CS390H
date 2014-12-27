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
currentRoute,
currentTrip,
segmentKeys,
delegate,
segments;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [ encoder encodeObject:segments forKey:@"segments" ];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ( self = [ super init ] ) {
        self.segments = [ decoder decodeObjectForKey:@"segments" ];
    }
    return self;
}

-(id)init {
    if ( self = [ super init ] ) {
        self.locationManager = [ CLLocationManager new ];
        self.locationManager.delegate = self;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.distanceFilter = 100;
        self.locationManager.desiredAccuracy = 20;
        self.currentSegment = [ [ BestRouteSegment alloc ] init ];
        self.segmentKeys =
        [ [ NSArray alloc ] init ];
    }
    
    return self;
}

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
    
    return theDistance <= distance;
}

- (NSDictionary *) addSegment:(BestRouteSegment *)newSegment
                withSegmentName:(NSString *)segmentName {
    NSMutableDictionary *newSegments =
    [ [ NSMutableDictionary alloc ] initWithDictionary:self.segments ];
    [ newSegments setObject:newSegment forKey:segmentName ];
    
    return newSegments;
}

- (NSArray *) addKey:(NSString *) key {
    NSMutableArray *newKeys =
    [ [ NSMutableArray alloc ] initWithArray:self.segmentKeys ];
    [ newKeys addObject:key ];
    
    return [ [ NSArray alloc ] initWithArray:newKeys ];
}

#warning No longer used.. May need for later
- (void) segmentEnded:(BestRouteSegment *)segment {

}

- (void) writeData {
    // Need to remove current location annotation as the class doesn't implement NSCoding protocol.
    NSMutableArray *tmpAnnos =
    [ [ NSMutableArray alloc ] initWithArray:self.currentSegment.mapAnnotations ];
    for ( int i = 0; i < tmpAnnos.count; i++ ) {
        if ( [ tmpAnnos[i] isKindOfClass:[MKUserLocation class] ]) {
            [ tmpAnnos removeObjectAtIndex:i ];
        }
    }
    self.currentSegment.mapAnnotations =
    [ [ NSArray alloc ] initWithArray:tmpAnnos ];
    
    NSData *data = [ NSKeyedArchiver archivedDataWithRootObject:self.segments ];
    NSData *keys = [ NSKeyedArchiver archivedDataWithRootObject:self.segmentKeys ];
    [ data writeToFile:[ self getFilePathByAppending:@"segments" ] atomically:TRUE ];
    [ keys writeToFile:[ self getFilePathByAppending:@"segmentKeys"] atomically:TRUE];
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

# pragma mark Location manager delegates
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [ eventDate timeIntervalSinceNow ];
    if ( abs(howRecent) < 15.0 ) {
       NSLog(@"New Latitude %+.6f, Longitude %+.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        [ self.delegate locationUpdate:newLocation ];
    }
}

- (void) locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", [ error description ] );
    [ self.delegate locationError:error ];
}

@end
