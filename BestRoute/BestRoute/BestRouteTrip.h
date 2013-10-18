//
//  BestRouteTrip.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
//static const NSArray *timeOfDayCategories = NULL;

@interface BestRouteTrip : NSObject {
    double tripTime;
    // String representing time of day - Departure time is
    NSString *timeOfDay;
}

// Will take the time passed in and determine a string
//   to represent the time of day and set self.timeOfDay
- (void) determineTimeofDayWithTime:(NSDate *)time;



@end
