//
//  BestRouteSegment.m
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteSegment.h"

@implementation BestRouteSegment
@synthesize
startCoord,
endCoord,
startingLocation,
endingLocation,
routesForSegment,
segmentName;

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSLog(@"Encode in segment was called");
    [ encoder encodeDouble:self.startCoord.latitude
                    forKey:@"startCoord.latitude" ];
    [ encoder encodeDouble:self.startCoord.longitude
                    forKey:@"startCoord.longitude" ];
    [ encoder encodeDouble:self.endCoord.latitude
                    forKey:@"endCoord.latitude" ];
    [ encoder encodeDouble:self.endCoord.longitude
                    forKey:@"endCoord.longitude" ];
    [ encoder encodeObject:self.segmentName
                    forKey:@"segmentName" ];
    [ encoder encodeObject:self.startingLocation
                    forKey:@"startingLocation" ];
    [ encoder encodeObject:self.endingLocation
                    forKey:@"endingLocation" ];
    [ encoder encodeObject:self.routesForSegment
                    forKey:@"routesForSegment" ];
}

- (id)initWithCoder:(NSCoder *)adecoder {
    NSLog(@"Init with coder was called in segment");
    if ( self = [ super init ] ) {
        self.startCoord =
        CLLocationCoordinate2DMake(
                                   [ adecoder decodeDoubleForKey:@"startCoord.lattitude" ],
                                   [ adecoder decodeDoubleForKey:@"startCoord.longitude" ]
                                   );
        self.endCoord =
        CLLocationCoordinate2DMake(
                                   [ adecoder decodeDoubleForKey:@"endCoord.lattitude" ],
                                   [ adecoder decodeDoubleForKey:@"endCoord.longitude" ]
                                   );
        self.segmentName =
        [ adecoder decodeObjectForKey:@"segmentName" ];
        self.startingLocation =
        [ adecoder decodeObjectForKey:@"startingLocation" ];
        self.endingLocation =
        [ adecoder decodeObjectForKey:@"endingLocation" ];
        self.routesForSegment =
        [ adecoder decodeObjectForKey:@"routesForSegment" ];
        //[ adecoder decodeObjectForKey:@"routesForSegment" ];
        
    }
    return self;
}
// This should be used as the default initializer
- (BestRouteSegment *)initSegmentWithStartingLocation:(CLLocationCoordinate2D )start
                                    andEndingLocation:(CLLocationCoordinate2D )end {
    if ( self = [ super init ] ) {
        self.startCoord = start;
        self.endCoord = end;
        self.routesForSegment = [ [ NSDictionary alloc ] init ];
    }
    return self;
}

/*- (id)init {
 if ( self = [ super init ] ) {
 self.startCoord =
 }
 }*/
#warning Unimplemented method
// Displays segments to choose from
- (void) showSegments {
    
}

// Returns a new dictionary with the added route
- (NSDictionary *) addRoute:(Route *)newRoute withRouteName:(NSString *)routeName {
    NSMutableDictionary *newRouteSet =
    [ [ NSMutableDictionary alloc ] initWithDictionary:self.routesForSegment ];
    [ newRouteSet setObject:newRoute forKey:routeName ];
    
    return newRouteSet;
}

// Determines if two segments are the same
//    will return true if both the starting
//    and ending location of this segment
//    are within 100 meters of the passed in
//    segment
- (BOOL) isEqual:(BestRouteSegment *)segment {
    
    double startDistance =
    [ BestRouteSegment GetDistance:self.startCoord.latitude
                             long1:self.startCoord.longitude
                               la2:segment.startCoord.latitude
                             long2:segment.startCoord.longitude ];
    
    double endDistance =
    [ BestRouteSegment GetDistance:self.endCoord.latitude
                             long1:self.endCoord.longitude
                               la2:segment.endCoord.latitude
                             long2:segment.endCoord.longitude ];
    
    return startDistance <= 100 && endDistance <= 100;
}

+ (double)GetDistance:(double)lat1 long1:(double)lng1 la2:(double)lat2 long2:(double)lng2 {
    //NSLog(@"latitude 1:%.7f,longitude1:%.7f,latitude2:%.7f,longtitude2:%.7f",lat1,lng1,lat2,lng2);
    double radLat1 = [ BestRouteSegment rad:lat1 ];
    double radLat2 = [ BestRouteSegment rad:lat2 ];
    double a = radLat1 - radLat2;
    double b = [ BestRouteSegment rad:lng1 ] - [ BestRouteSegment rad:lng2 ];
    double s =
    2 * asin(sqrt(pow(sin(a/2),2) + cos(radLat1)*cos(radLat2)*pow(sin(b/2),2)));
    s = s * 6378.138;
    s = round(s * 10000) / 10000;
    return s;
}

+(double)rad:(double)d {
    return d *3.14159265 / 180.0;
}
// Searches dictionary of routes to determine if route exists
//   ***for future use***
- (BOOL) determineIfNewRoute:(Route *)currentRoute {
    return NO;
}
@end
