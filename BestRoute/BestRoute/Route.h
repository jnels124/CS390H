//
//  Route.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject {
    NSString *routeName;
    double  avgRouteTime;
    NSArray *allTripsFromRoute;
}

@end
