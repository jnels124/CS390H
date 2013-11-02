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

@end
