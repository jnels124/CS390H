//
//  BestRouteTrip.m
//  BestRoute
//
//  Created by Jesse Nelson on 10/17/13.
//  Copyright (c) 2013 Jesse Nelson. All rights reserved.
//

#import "BestRouteTrip.h"
@implementation BestRouteTrip {
    
}
@synthesize
timeOfDay,
tripTime,
morningBeforeTrafic,
morningTrafic,
morningAfterTrafic,
afternoon,
eveningTrafic,
eveningAfterTrafic;

// Serialize this object
- (void)encodeWithCoder:(NSCoder *)encoder {
    [ encoder encodeObject:self.timeOfDay forKey:@"timeOfDay" ];
    [ encoder encodeDouble:self.tripTime forKey:@"tripTime" ];
}

// De-serialize this object
- (id)initWithCoder:(NSCoder *)adecoder {
    if ( self = [ super init ] ) {
        self.timeOfDay =
        [ adecoder decodeObjectForKey:@"timeOfDay" ];
        self.tripTime =
        [ adecoder decodeDoubleForKey:@"tripTime" ];
    }
    return self;
}


- (id)init {
    if ( self = [ super init ] ) {
        self.tripTime = 0.0;
        self.timer =
        [ [ BestRouteTimer alloc ] init ];
#warning This block should be constants, not ivars!
        self.morningBeforeTrafic = [ self dateWithHour:0 andMinute:0 ];
        self.morningTrafic = [ self dateWithHour:6 andMinute:30 ];
        self.morningAfterTrafic = [ self dateWithHour:9 andMinute:30 ];
        self.afternoon = [ self dateWithHour:12 andMinute:0 ];
        self.eveningTrafic = [ self dateWithHour:15 andMinute:30 ];
        self.eveningAfterTrafic = [ self dateWithHour:18 andMinute:30 ];
        
        self.timeOfDay = [ self determineTimeofDayWithTime:[ NSDate date ] ] ;
    }
    return self;
}

// Will take the time passed in and return a string
//   to represent the time of day
- (NSString *) determineTimeofDayWithTime:(NSDate *)time {
    if ( ( [ self.morningBeforeTrafic compare:time ] == NSOrderedAscending ||
          [ self.morningBeforeTrafic compare:time ] == NSOrderedSame  ) &&
        [ time compare:self.morningTrafic ] == NSOrderedAscending ) {
        return @"Morning, before traffic.";
    }
    
    else if ( ( [ self.morningTrafic compare:time ] == NSOrderedAscending ||
               [ self.morningTrafic compare:time ] == NSOrderedSame  ) &&
             [ time compare:self.morningAfterTrafic ] == NSOrderedAscending ) {
        return @"Morning Traffic!";
    }
    
    else if ( ( [ self.morningAfterTrafic compare:time ] == NSOrderedAscending ||
               [ self.morningAfterTrafic compare:time ] == NSOrderedSame  ) &&
             [ time compare:self.afternoon ] == NSOrderedAscending ) {
        return @"Morning, after traffic ";
    }
    
    else if ( ( [ time compare:self.afternoon ] == NSOrderedAscending ||
               [ self.afternoon compare:time ] == NSOrderedSame  ) &&
             [ self.eveningTrafic compare:time ] == NSOrderedAscending ) {
        return @"Afternoon";
    }
    
    else if ( ( [ self.eveningTrafic compare:time ] == NSOrderedAscending ||
               [ self.eveningTrafic compare:time ] == NSOrderedSame  ) &&
             [ time compare:self.eveningAfterTrafic ] == NSOrderedAscending ) {
        return @"Evening Traffic!";
    }
    
    return @"Evening, after traffic";
}

- (NSDate *)dateWithHour:(int)hour andMinute:(int)minutes {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar ];
    
    [ calendar setTimeZone:[ NSTimeZone localTimeZone ] ];
    
    NSDate *today = [ NSDate date ];
    NSDateComponents *todayComps =
    [ calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |NSTimeZoneCalendarUnit) fromDate:today ];
    
    todayComps.timeZone = [ NSTimeZone localTimeZone ];
    todayComps.minute = minutes;
    todayComps.hour = hour;
    NSDate *newDate = [ calendar dateFromComponents:todayComps ];
    return newDate;
}

- (NSString *) description {
    NSString *data = [ [ NSString alloc ] init];
    data = [ data stringByAppendingString:
            [ NSString stringWithFormat:@"Time of Day: %@", self.timeOfDay ] ];
    data = [ data stringByAppendingString:[ NSString stringWithFormat:@"\nTrip Time: %f", self.tripTime ] ];
    return data;
}

@end
