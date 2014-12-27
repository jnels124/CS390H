//
//  BestRouteAnnotation.m
//  BestRoute
//
//  Created by Jesse Nelson on 10/18/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteAnnotation.h"

@implementation BestRouteAnnotation
@synthesize
coordinate,
title,
subTitle;


- (id) initWithLocation:(CLLocationCoordinate2D)coord {
    if ( self = [ super init ] ) {
        self.coordinate = coord;
    }
    return self;
}

- (id) initWithLocation:(CLLocationCoordinate2D)coord
                  Title:(NSString *) t
               SubTitle:(NSString *) subT {
    if (self = [ super init ] ) {
        self.coordinate = coord;
        self.title = t;
        self.subTitle = subT;
    }
    return self;
}

// Serialize this object
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [ aCoder encodeDouble:self.coordinate.latitude
                    forKey:@"coordinate.latitude" ];
    [ aCoder encodeDouble:self.coordinate.longitude
                    forKey:@"coordinate.longitude" ];
    [ aCoder encodeObject:self.title forKey:@"title" ];
    [ aCoder encodeObject:self.subTitle forKey:@"subTitle" ];
}

// De-serialize this object
- (id)initWithCoder:(NSCoder *)adecoder {
    if ( self = [ super init ] ) {
        self.coordinate =
        CLLocationCoordinate2DMake(
                                   [ adecoder decodeDoubleForKey:@"coordinate.latitude" ],
                                   [ adecoder decodeDoubleForKey:@"coordinate.longitude" ]
                                   );
        self.title =
        [ adecoder decodeObjectForKey:@"title" ];
        self.subTitle =
        [ adecoder decodeObjectForKey:@"subTitle" ];
    }
    
    return self;
}
@end
