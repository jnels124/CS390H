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
routeKeys,
segmentName;

- (void)encodeWithCoder:(NSCoder *)encoder {
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
    [ encoder encodeObject:self.mapAnnotations forKey:@"mapAnnotations" ];
    [ encoder encodeObject:self.routeKeys forKey:@"routeKeys" ];
}

- (id)initWithCoder:(NSCoder *)adecoder {
    if ( self = [ super init ] ) {
        self.startCoord =
        CLLocationCoordinate2DMake(
                                   [ adecoder decodeDoubleForKey:@"startCoord.latitude" ],
                                   [ adecoder decodeDoubleForKey:@"startCoord.longitude" ]
                                   );
        self.endCoord =
        CLLocationCoordinate2DMake(
                                   [ adecoder decodeDoubleForKey:@"endCoord.latitude" ],
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
        self.routeKeys =
        [ adecoder decodeObjectForKey:@"routeKeys" ];
        self.mapAnnotations =
        [ adecoder decodeObjectForKey:@"mapAnnotations" ];
    }
    
    return self;
}

- (BestRouteSegment *)initSegmentWithStartingLocation:(CLLocationCoordinate2D )start
                                    andEndingLocation:(CLLocationCoordinate2D )end {
    if ( self = [ super init ] ) {
        self.startCoord = start;
        self.endCoord = end;
        self.routesForSegment = [ [ NSDictionary alloc ] init ];
        self.mapAnnotations = [ [ NSArray alloc ] init ];
        self.routeKeys = [ [ NSArray alloc ] init ];
    }
    return self;
}

- (id)init {
 if ( self = [ super init ] ) {
     self.routesForSegment =
     [ [ NSDictionary alloc ] init ];
     self.routeKeys =
     [ [ NSArray alloc ] init ];
     self.mapAnnotations =
     [ [ NSArray alloc ] init ];
 }
    return self;
}

- (NSDictionary *) addRoute:(Route *)newRoute withRouteName:(NSString *)routeName {
    NSMutableDictionary *newRouteSet =
    [ [ NSMutableDictionary alloc ] initWithDictionary:self.routesForSegment ];
    [ newRouteSet setObject:newRoute forKey:routeName ];
    
    return newRouteSet;
}

- (NSArray *) addKey:(NSString *) key {
    NSMutableArray *newKeys =
    [ [ NSMutableArray alloc ] initWithArray:self.routeKeys ];
    [ newKeys addObject:key ];
    
    return [ [ NSArray alloc ] initWithArray:newKeys ];
}

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

#warning Unimplemented
- (NSArray *) routesByTimeOfDay {
    
    return nil;
}

#warning Unimplemented
- (NSArray *) routesByChronlogicalOrder {
    return nil;
}

- (NSArray *) routesByAverageTime {
    
    return [ self quickSort:[ self.routesForSegment allValues ] ];
}

// Returns array of routes sorted by average time
- (NSArray *) quickSort:(NSArray *) unsortedArray {
    if ( unsortedArray.count <= 1 ) return unsortedArray;
# warning Choose the pivot in a better way
    Route *pivotObject =
    [ unsortedArray objectAtIndex:unsortedArray.count / 2 ];
    
    NSMutableArray *left = [ [ NSMutableArray alloc ] init ];
    NSMutableArray *right = [ [ NSMutableArray alloc ] init ];
    for (Route* value in unsortedArray) {
        if ( value.avgRouteTime < pivotObject.avgRouteTime ) {
            [ left addObject:value ];
        } else if ( value.avgRouteTime > pivotObject.avgRouteTime ) {
            [ right addObject:value ];
        }
    }
    
    NSMutableArray* sortedArray =
    [ [ NSMutableArray alloc ] initWithCapacity:unsortedArray.count ];
    [ sortedArray addObjectsFromArray:[ self quickSort:left ] ];
    [ sortedArray addObject:pivotObject ];
    [ sortedArray addObjectsFromArray:[ self quickSort:right ] ];
    
    return [ sortedArray copy ];
}

+ (double)GetDistance:(double)lat1 long1:(double)lng1
                  la2:(double)lat2 long2:(double)lng2 {
    double radLat1 = [ BestRouteSegment rad:lat1 ];
    double radLat2 = [ BestRouteSegment rad:lat2 ];
    double a = radLat1 - radLat2;
    double b = [ BestRouteSegment rad:lng1 ] - [ BestRouteSegment rad:lng2 ];
    double s =
    2 * asin(sqrt(pow(sin(a/2),2) + cos(radLat1)*cos(radLat2)*pow(sin(b/2),2)));
    s = s * 6378.138;// Earths radius
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
