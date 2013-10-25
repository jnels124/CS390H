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
    // Time elapsed for current trip
    double tripTime;
    // String representing time of day - Departure time is
    NSString *timeOfDay;
    NSDate *morningBeforeTrafic;// from 12:00am to 6:30am
    NSDate *morningTrafic; // from 6:30am to 9:30am
    NSDate *morningAfterTrafic; // from 9:30am to 12:00pm
    NSDate *afternoon;    // from 12:00pm to 3:30pm
    NSDate *eveningTrafic; // from 3:30pm to 6:30pm
    NSDate *eveningAfterTrafic; // from 6:30pm to 12:00p
}

@property double tripTime;
@property NSString *timeOfDay;
@property NSDate *morningBeforeTrafic;// from 12:00am to 6:30am
@property NSDate *morningTrafic; // from 6:30am to 9:30am
@property NSDate *morningAfterTrafic; // from 9:30am to 12:00pm
@property NSDate *afternoon;    // from 12:00pm to 3:30pm
@property NSDate *eveningTrafic; // from 3:30pm to 6:30pm
@property NSDate *eveningAfterTrafic; // from 6:30pm to 12:00p

// Will take the time passed in and determine a string
//   to represent the time of day and set self.timeOfDay
- (NSString *) determineTimeofDayWithTime:(NSDate *)time;

- (NSDate *)dateWithHour:(int)hour andMinute:(int)minutes;

@end
