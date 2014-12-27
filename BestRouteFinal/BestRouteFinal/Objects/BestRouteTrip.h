//
//  BestRouteTrip.h
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestRouteTimer.h"
//static const NSArray *timeOfDayCategories = NULL;

@interface BestRouteTrip : NSObject < NSCoding >{
    // Time elapsed for current trip
    double tripTime;
    // String representing time of day - Departure time is
    NSString *timeOfDay;
    
#warning These should not be ivars, they need to be created as class constants.
    NSDate *morningBeforeTrafic;// from 12:00am to 6:30am
    NSDate *morningTrafic; // from 6:30am to 9:30am
    NSDate *morningAfterTrafic; // from 9:30am to 12:00pm
    NSDate *afternoon;    // from 12:00pm to 3:30pm
    NSDate *eveningTrafic; // from 3:30pm to 6:30pm
    NSDate *eveningAfterTrafic; // from 6:30pm to 12:00p
}

/*Double representing the time of the trip*/
@property double tripTime;

/*String representation of the time of day. This is set when trip is allocated*/
@property NSString *timeOfDay;

/*Timer to track trip time*/
@property BestRouteTimer *timer;

#warning These should not be properties, they need to be created as class constants.
/*Time representing before morning trafic*/
@property NSDate *morningBeforeTrafic;// from 12:00am to 6:30am

/*Time representing the start of morning trafic*/
@property NSDate *morningTrafic; // from 6:30am to 9:30am

/*Time representing the start of morning after trafic*/
@property NSDate *morningAfterTrafic; // from 9:30am to 12:00pm

/*Time representing the start of afternoon trafic*/
@property NSDate *afternoon;    // from 12:00pm to 3:30pm

/*Time representing the start of evening trafic*/
@property NSDate *eveningTrafic; // from 3:30pm to 6:30pm

/*Time representing the start of evening after trafic*/
@property NSDate *eveningAfterTrafic; // from 6:30pm to 12:00p

// Will take the time passed in and determine a string
//   to represent the time of day and set self.timeOfDay
- (NSString *) determineTimeofDayWithTime:(NSDate *)time;

/* Returns a date with the current day, month, and year, and
 the specified hour and minute
 */
- (NSDate *)dateWithHour:(int)hour andMinute:(int)minutes;

@end
