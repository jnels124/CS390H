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

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSLog(@"Encode in trip was called");
    [ encoder encodeObject:self.timeOfDay forKey:@"timeOfDay" ];
    [ encoder encodeDouble:self.tripTime forKey:@"tripTime" ];
}

- (id)initWithCoder:(NSCoder *)adecoder {
    NSLog(@"init with coder in trip was called");
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
        self.morningBeforeTrafic = [ self dateWithHour:0 andMinute:0 ];
        self.morningTrafic = [ self dateWithHour:6 andMinute:30 ];
        self.morningAfterTrafic = [ self dateWithHour:9 andMinute:30 ];
        self.afternoon = [ self dateWithHour:12 andMinute:0 ];
        self.eveningTrafic = [ self dateWithHour:15 andMinute:30 ];
        self.eveningAfterTrafic = [ self dateWithHour:18 andMinute:30 ];
        
        self.timeOfDay = [ self determineTimeofDayWithTime:[ NSDate date ] ];
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
    
    else if ( ( [ self.afternoon compare:time ] == NSOrderedAscending ||
               [ self.afternoon compare:time ] == NSOrderedSame  ) &&
             [ time compare:self.eveningTrafic ] == NSOrderedAscending ) {
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
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [ [ NSCalendar alloc ]
                             initWithCalendarIdentifier:NSGregorianCalendar ];
    NSDateComponents *components =
    [ gregorian components:(NSDayCalendarUnit |
                            NSWeekdayCalendarUnit) fromDate:today];
    [ components setHour:hour ];
    [ components setMinute:minutes ];
    return [ gregorian dateFromComponents:components ];
}


@end
